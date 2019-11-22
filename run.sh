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
#create folders

# mkdir models


# cd /storage
# mkdir data
# cd data

# mkdir vgg
# mkdir train

# cd train
# wget http://173.255.194.181:5000/simpsons.tar.gz
# tar -xzf simpsons.tar.gz
# rm simpsons.tar.gz

# cd vgg
# wget http://www.vlfeat.org/matconvnet/models/beta16/imagenet-vgg-verydeep-19.mat

# cd /paperspace


#run style transfer on video
# python transform_video.py --in-path examples/content/fox.mp4 \
#   --checkpoint ./scream.ckpt \
#   --out-path /artifacts/out.mp4 \
#   --device /gpu:0 \
#   --batch-size 4 2>&1
# wget https://www.broadcastingcable.com/.image/t_share/MTU3NTE4OTY0OTYyODk1MDUw/patrick-stewart-picard-star-trek-cbs.jpg

pip install moviepy

python3 style.py --checkpoint-dir /artifacts \
		 --train-path /datasets/coco \
		 --epochs 2 \
		 --batch-size 4 \
		 --checkpoint-iterations 1000 \
		 --vgg-path /storage/vgg/imagenet-vgg-verydeep-19.mat \
		 --style /storage/burns.jpg 2>&1
