# Copyright (c) 2022, NVIDIA CORPORATION.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from typing import Dict, Optional

import torch
from torch import nn

from nemo.core.classes import Exportable, NeuralModule
from nemo.core.classes.common import typecheck
from nemo.core.neural_types import ChannelType, NeuralType

__all__ = ['PromptEncoder']


class PromptEncoder(NeuralModule, Exportable):
    """
    The prompt encoder network that is used to generate the virtual 
    token embeddings for p-tuning.
    """

    @property
    def input_types(self) -> Optional[Dict[str, NeuralType]]:
        return {
            "taskname_embeddings": NeuralType(('B', 'T', 'C'), ChannelType(), optional=False),
        }

    @property
    def output_types(self) -> Optional[Dict[str, NeuralType]]:
        return {"output_embeds": NeuralType(('B', 'T', 'C'), ChannelType())}

    def __init__(self, total_virtual_tokens: int, hidden_size: int, lstm_dropout: float, num_layers: int, existing_task_tokens=None):
        """
        Initializes the PromptEncoder module.
        Args:
            total_virtual_tokens: the total number of vitural tokens
            hidden_size: hidden dimension
            lstm_dropout: the dropout used for the LSTM
            num_layers: number of layers used in the LSTM
        """
        super().__init__()
        self.hidden_size = hidden_size
        self.total_virtual_tokens = total_virtual_tokens

        # Set fixed indicies for forward pass
        self.register_buffer('indices', torch.LongTensor(list(range(self.total_virtual_tokens))))

        # embedding
        self.embedding = torch.nn.Embedding(self.total_virtual_tokens, self.hidden_size)

        # Set embedding weights to be embeddings from prompt tokens
        if existing_task_tokens is not None:
            self.embeddings.weight = nn.Parameter(existing_task_tokens)

        # LSTM
        self.lstm_head = torch.nn.LSTM(
            input_size=self.hidden_size,
            hidden_size=self.hidden_size // 2,
            num_layers=num_layers,
            dropout=lstm_dropout,
            bidirectional=True,
            batch_first=True,
        )
        self.mlp_head = nn.Sequential(
            nn.Linear(self.hidden_size, self.hidden_size), nn.ReLU(), nn.Linear(self.hidden_size, self.hidden_size)
        )

    @typecheck()
    def forward(self, taskname_embeddings) -> torch.Tensor:
        input_embeds = self.embedding(self.indices).unsqueeze(0)
        batch_size, task_seq_length, _ = taskname_embeddings.shape
        input_embeds = input_embeds.expand(batch_size, self.total_virtual_tokens, self.hidden_size).clone()
        length = min(task_seq_length, self.total_virtual_tokens)

        # Replace general input with task specific embeddings to specify the correct task
        input_embeds[:, 0:length, :] = taskname_embeddings[:, 0:length, :]
        output_embeds = self.mlp_head(self.lstm_head(input_embeds)[0])
        return output_embeds
