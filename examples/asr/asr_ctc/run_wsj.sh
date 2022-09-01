#!/bin/bash
python speech_to_text_ctc_bpe_ts.py \
--config-path=../conf/conformer \
--config-name=conformer_ctc_bpe_ts_conformer.yaml \
model.tokenizer.type=bpe \
model.tokenizer.dir=/home/yangzhang/code/ts_asr/tokenizer_conformer/ctc_medium/tokenizer_spe_unigram_v128/ \
model.train_ds.manifest_filepath=/mnt/data/wsj/wsj0-2mix/manifests/train.json \
trainer.max_epochs=50 \
model.validation_ds.manifest_filepath=/mnt/data/wsj/wsj0-2mix/manifests/cv.json \
model.train_ds.max_duration=16 \
model.train_ds.augmentor.rir_noise_speaker.prob=1.0 \
model.tokenizer.type=bpe \
trainer.num_sanity_val_steps=0 \
model.test_ds.manifest_filepath=/mnt/data/wsj/wsj0-2mix/manifests/test.json \
model.speaker_embeddings.freeze_decoder=True \
model.speaker_embeddings.freeze_encoder=True \
model.freeze_asr_decoder=False \
model.freeze_asr_encoder=False \
model.train_ds.max_duration=16 \
model.train_ds.batch_size=4 \
model.train_ds.synthetic_generation=True \
model.train_ds.num_workers=8 \
model.validation_ds.num_workers=2 \
model.validation_ds.augmentor.rir_noise_speaker.prob=1.0 \
model.validation_ds.batch_size=1 \
model.validation_ds.synthetic_generation=False \
model.test_ds.num_workers=2 \
model.test_ds.batch_size=1 \
model.test_ds.synthetic_generation=False \
model.test_ds.augmentor.rir_noise_speaker.prob=1.0 \
model.test_ds.sample_rate=16000 \
trainer.devices=[0] \
trainer.log_every_n_steps=50 \
model.encoder.d_model=256 \
model.encoder.subsampling_factor=4 \
model.encoder.n_heads=4 \
model.encoder.n_layers=18 \
model.spec_augment.time_masks=5 \
trainer.val_check_interval=0.1 \
+nemo_checkpoint_path=/home/yangzhang/code/ts_asr/stt_en_conformer_ctc_medium_v1.0.0/stt_en_conformer_ctc_medium.nemo
