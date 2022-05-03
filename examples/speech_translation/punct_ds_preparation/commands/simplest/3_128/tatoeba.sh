python prepare_big_data_for_punctuation_capitalization_task_simple.py \
  --output_dir /media/apeganov/DATA/punctuation_and_capitalization/simplest/3_128/tatoeba_x1_03.05.2022 \
  --corpus_types "tatoeba" \
  --create_model_input \
  --bert_labels \
  --autoregressive_labels \
  --sequence_length_range 3 128 \
  --allowed_punctuation '.,?' \
  --only_first_punctuation_character_after_word_in_autoregressive \
  --no_label_if_all_characters_are_upper_case \
  --input_files_or_dirs /media/apeganov/DATA/tatoeba/eng_sentences.tsv \
  --num_jobs 24 \
  --num_passes_through_dataset 1 \
  --dev_size 10000 \
  --test_size 0