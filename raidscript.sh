#!/bin/bash
#�������� ������
sudo lshw -short | grep disk
sudo fdisk -l
#������� ����������
sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
#������� raid 6 �� 4 ������
sudo mdadm --create --verbose /dev/md0 -l 6 -n 4 /dev/sd{b,c,d,e}
#�������� ���������� raid
cat /proc/mdstat
#������� mdadm.conf 
sudo echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
sudo mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
#������ raid
sudo mdadm /dev/md0 --fail /dev/sde
#������� ��� ����� � ���
cat /proc/mdstat
#������ ����
sudo mdadm /dev/md0 --remove /dev/sde
#��������� ����� ���� � ������� �� �������������
sudo mdadm /dev/md0 --add /dev/sde
cat /proc/mdstat
#������� GPT �� raid
sudo parted -s /dev/md0 mklabel gpt
#������� ��������
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%
#������� ext4
sudo for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
#��������� �� ���������
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
 


