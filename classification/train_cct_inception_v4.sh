DATASET_DIR=/data/lila/caltech/cct_cropped_tfrecords
#TRAIN_DIR=./log/$(date +"%Y-%m-%d_%H.%M.%S")-incv4
TRAIN_DIR=log/2019-02-15_08.49.56-incv4/
CHECKPOINT_PATH=/home/loris/git/tf-classification/pre-trained/inception_v4/inception_v4.ckpt
MODEL_NAME=inception_v4
CHECKPOINT_EXCLUDE=InceptionV4/AuxLogits,InceptionV4/Logits
NUM_GPUS=1

: '
python train_image_classifier.py \
    --train_dir=${TRAIN_DIR}/init \
    --dataset_dir=${DATASET_DIR} \
    --dataset_name=cct \
    --dataset_split_name=train \
    --model_name=${MODEL_NAME} \
    --checkpoint_path=${CHECKPOINT_PATH} \
    --checkpoint_exclude_scopes=${CHECKPOINT_EXCLUDE} \
    --trainable_scopes=${CHECKPOINT_EXCLUDE} \
    --max_number_of_steps=1000000 \
    --batch_size=32 \
    --learning_rate=0.01 \
    --learning_rate_decay_type=fixed \
    --save_interval_secs=60 \
    --save_summaries_secs=60 \
    --log_every_n_steps=100 \
    --optimizer=rmsprop \
    --weight_decay=0.00004

# Run evaluation.
python eval_image_classifier.py \
    --eval_dir=${TRAIN_DIR} \
    --dataset_dir=${DATASET_DIR} \
    --dataset_name=cct \
    --dataset_split_name=test \
    --model_name=${MODEL_NAME} \
    --checkpoint_path=${TRAIN_DIR}
'
python train_image_classifier.py \
    --train_dir=${TRAIN_DIR}/all \
    --dataset_dir=${DATASET_DIR} \
    --dataset_name=cct \
    --dataset_split_name=train \
    --model_name=${MODEL_NAME} \
    --checkpoint_path=${TRAIN_DIR}/init \
    --preprocessing_name="inception_v2" \
    --max_number_of_steps=10000000 \
    --batch_size=32 \
    --learning_rate=0.0045 \
    --learning_rate_decay_factor=0.94 \
    --num_epochs_per_decay=4 \
    --save_interval_secs=60 \
    --save_summaries_secs=60 \
    --log_every_n_steps=10 \
    --optimizer=rmsprop \
    --weight_decay=0.00004
