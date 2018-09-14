#!/usr/bin/env bash

VGA=$(lspci | grep VGA | grep NVIDIA)
if $VGA == ''
then
    GPU=0
else
    GPU=1
fi

sudo pacman -S --needed --noconfirm \
     docker \
     lzop \
     opencv

if $GPU
then
    sudo pacman -S --needed --noconfirm \
	 cuda \
	 cudnn \
	 python-tensorflow-gpu-opt 
else
    sudo pacman -S --needed --noconfirm \
	 python-tensorflow-opt
fi

pikaur -S --needed --noconfirm --noedit \
       code \
       franz-bin \
       ghq \
       google-chrome \
       chrome-remote-desktop \
       insync \
       intel-mkl \
       kr \
       logmein-hamachi-beta \
       lv \
       mendeleydesktop \
       nixnote2 \
       pcl \
       peco \
       python-keras \
       python-keras-applications \
       python-keras-preprocessing \
       python-scikit-image \
       ros-melodic-desktop \
       skypeforlinux-stable-bin \
       spotify \
       torch7-git \
       torch7-trepl-git \
       xonsh

if $GPU
then
    pikaur -S --needed --noconfirm --noedit \
	   caffe2-cuda \
	   nvidia-docker \
           torch7-cutorch-git \
           torch7-cudnn-git
else
    pikaur -S --needed --noconfirm --noedit \
	   caffe2
if

# mendeley
