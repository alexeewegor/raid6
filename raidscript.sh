#!/bin/bash
#просмотр дисков
sudo lshw -short | grep disk
sudo fdisk -l
#обнулим суперблоки
sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
#создаем raid 6 из 4 дисков
sudo mdadm --create --verbose /dev/md0 -l 6 -n 4 /dev/sd{b,c,d,e}
#просмотр созданного raid
cat /proc/mdstat
#создаем mdadm.conf 
sudo echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
#ломаем raid
sudo mdadm /dev/md0 --fail /dev/sde
#смотрим что стало с ним
cat /proc/mdstat
#удалим диск
sudo mdadm /dev/md0 --remove /dev/sde
#вставляем новый диск и смотрим на синхронизацию
sudo mdadm /dev/md0 --add /dev/sde
cat /proc/mdstat
#создаем GPT на raid
sudo parted -s /dev/md0 mklabel gpt
#создаем партиции
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%
#создаем ext4
sudo for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
#монтируем по каталогам
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
 


