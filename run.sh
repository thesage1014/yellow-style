#!/bin/bash

APT_PACKAGES="apt-utils ffmpeg libav-tools x264 x265"
apt-install() {
	export DEBIAN_FRONTEND=noninteractive
	apt-get update -q
	apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" $APT_PACKAGES
	return $?
}

#install ffmpeg to container
add-apt-repository -y ppa:jonathonf/ffmpeg-3 2>&1
apt-install || exit 1

pip install moviepy

python style.py --checkpoint-dir /artifacts \
		 --train-path /datasets/coco \
		 --epochs 2 \
		 --batch-size 4 \
		 --checkpoint-iterations 2000 \
		 --vgg-path /storage/vgg/imagenet-vgg-verydeep-19.mat \
		 --style /storage/burns.jpg 2>&1
