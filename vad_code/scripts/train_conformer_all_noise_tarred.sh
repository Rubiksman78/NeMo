DATA_DIR="./manifests_cleaned"
NAME="conformer_small_multilang_40ms_all_noise_wce"
BATCH_SIZE=64
NUM_WORKERS=8
CUDA_VISIBLE_DEVICES=0,1 python speech_to_multi_label.py \
    --config-path="./configs" --config-name="conformer_small" \
    model.train_ds.augmentor.noise.manifest_path="[${DATA_DIR}/noise/freesound_nonspeech_train_FL200_local_cleaned.json,${DATA_DIR}/noise/musan_train_FL200_local_cleaned.json]" \
    model.train_ds.is_tarred=true \
    model.train_ds.tarred_audio_filepaths="/media/data/datasets/vad_train_tarred/audio__OP_0..511_CL_.tar" \
    model.train_ds.manifest_filepath="/media/data/datasets/vad_train_tarred/tarred_audio_manifest.json" \
    model.validation_ds.manifest_filepath="[${DATA_DIR}/dev/ami_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/ch120_moved_40ms_local_cleaned.json,${DATA_DIR}/dev/fisher_2004_40ms_local_cleaned_dev.json,${DATA_DIR}/dev/fisher_2005_40ms_local_cleaned_dev.json,${DATA_DIR}/dev/french_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/german_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/mandarin_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/russian_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/spanish_dev_40ms_local_cleaned.json]" \
    model.test_ds.manifest_filepath="[${DATA_DIR}/dev/ami_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/ch120_moved_40ms_local_cleaned.json,${DATA_DIR}/dev/fisher_2004_40ms_local_cleaned_dev.json,${DATA_DIR}/dev/fisher_2005_40ms_local_cleaned_dev.json,${DATA_DIR}/dev/french_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/german_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/mandarin_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/russian_dev_40ms_local_cleaned.json,${DATA_DIR}/dev/spanish_dev_40ms_local_cleaned.json]" \
    model.train_ds.batch_size=$BATCH_SIZE \
    model.validation_ds.batch_size=$BATCH_SIZE \
    model.test_ds.batch_size=$BATCH_SIZE \
    model.train_ds.num_workers=$NUM_WORKERS \
    model.validation_ds.num_workers=$NUM_WORKERS \
    model.test_ds.num_workers=$NUM_WORKERS \
    trainer.max_epochs=50 \
    exp_manager.name=${NAME} \
    exp_manager.create_wandb_logger=false \
    exp_manager.wandb_logger_kwargs.name=${NAME} \
    exp_manager.wandb_logger_kwargs.project="Frame_VAD" \
    ++model.loss.weight="[5.44,1.22]"