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
       franz-bin \
       ghq \
       google-chrome \
       chrome-remote-desktop \
       insync \
       intel-mkl \
       kr \
       logmein-hamachi-beta \
       lv \
       nixnote2 \
       pcl \
       peco \
       python-scikit-image \
       ros-melodic-desktop \
       skypeforlinux-stable-bin \
       spotify \
       xonsh

if $GPU
then
    pikaur -S --needed --noconfirm --noedit \
	   caffe2 \
	   nvidia-docker 
else
    pikaur -S --needed --noconfirm --noedit \
	   caffe2-cpu
fi
