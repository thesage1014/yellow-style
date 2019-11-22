#!/bin/bash

# APT_PACKAGES="apt-utils ffmpeg libav-tools x264 x265"
# apt-install() {
# 	export DEBIAN_FRONTEND=noninteractive
# 	apt-get update -q
# 	apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" $APT_PACKAGES
# 	return $?
# }

# #install ffmpeg to container
# add-apt-repository -y ppa:jonathonf/ffmpeg-3 2>&1
# apt-install || exit 1

apt-get update
apt-get install wget -y
apt-get update && apt-get install -y software-properties-common

# Install "ffmpeg"
add-apt-repository ppa:mc3man/xerus-media
apt-get update && apt-get install -y ffmpeg

mkdir /artifacts/checkpoints

pip install moviepy Pillow scipy==0.18.1 numpy

python style.py --checkpoint-dir /artifacts/checkpoints \
		 --train-path /datasets/coco \
		 --epochs 2 \
		 --model-dir /artifacts \
		 --batch-size 12 \
		 --checkpoint-iterations 2000 \
		 --vgg-path /storage/vgg/imagenet-vgg-verydeep-19.mat \
		 --style /storage/burns.jpg 2>&1
