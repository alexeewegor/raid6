создание raid 6

 sudo mdadm --create --verbose /dev/md0 -l 6 -n 4 /dev/sd{b,c,d,e} 

проверка 
 cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdb[0] sde[4] sdd[2] sdc[1]
      507904 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]

для автосатрта нужно создать файл mdadm.conf
cat /etc/mdadm/mdadm.conf
DEVICE partitions
ARRAY /dev/md0 level=raid6 num-devices=4 metadata=1.2 name=otuslinux:0 UUID=96d09643:4da0ebad:3d3d6e7a:65d01e11

raid 6

[vagrant@otuslinux ~]$ lsblk
NAME      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda         8:0    0   40G  0 disk
└─sda1      8:1    0   40G  0 part  /
sdb         8:16   0  250M  0 disk
└─md0       9:0    0  496M  0 raid6
  ├─md0p1 259:0    0   98M  0 md
  ├─md0p2 259:1    0   99M  0 md
  ├─md0p3 259:2    0  100M  0 md
  ├─md0p4 259:3    0   99M  0 md
  └─md0p5 259:4    0   98M  0 md
sdc         8:32   0  250M  0 disk
└─md0       9:0    0  496M  0 raid6
  ├─md0p1 259:0    0   98M  0 md
  ├─md0p2 259:1    0   99M  0 md
  ├─md0p3 259:2    0  100M  0 md
  ├─md0p4 259:3    0   99M  0 md
  └─md0p5 259:4    0   98M  0 md
sdd         8:48   0  250M  0 disk
└─md0       9:0    0  496M  0 raid6
  ├─md0p1 259:0    0   98M  0 md
  ├─md0p2 259:1    0   99M  0 md
  ├─md0p3 259:2    0  100M  0 md
  ├─md0p4 259:3    0   99M  0 md
  └─md0p5 259:4    0   98M  0 md
sde         8:64   0  250M  0 disk
└─md0       9:0    0  496M  0 raid6
  ├─md0p1 259:0    0   98M  0 md
  ├─md0p2 259:1    0   99M  0 md
  ├─md0p3 259:2    0  100M  0 md
  ├─md0p4 259:3    0   99M  0 md
  └─md0p5 259:4    0   98M  0 md

с