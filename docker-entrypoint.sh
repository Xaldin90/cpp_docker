#!/bin/bash


#git clone
cd /tmp/
git clone https://github.com/Xaldin90/ctf_cpp.git
cd /tmp/ctf_cpp/src

cd /

#user anlegen
useradd ctf3
echo 'ctf3:ctf3' | chpasswd #password for user
groupadd ctf
usermod -a -G ctf ctf3 #user gruppe zuweisen

useradd winner #winner user anlegen
echo 'winner:7T6hO29v' | chpasswd
usermod -a -G ctf winner

#create some bare minimum directores
mkdir -p /var/ctf3_jail/{dev,etc,lib,lib64,usr,bin}
mkdir -p /var/ctf3_jail/etc/skel
mkdir -p /var/ctf3_jail/usr/bin
mkdir -p /var/ctf3_jail/usr/lib
mkdir -p /var/ctf3_jail/lib/x86_64-linux-gnu
mkdir -p /var/ctf3_jail/usr/lib/x86_64-linux-gnu
mkdir -p /var/ctf3_jail/usr/share
mkdir -p /var/ctf3_jail/usr/local
mkdir -p /var/ctf3_jail/home
chown root:root /var/ctf3_jail #base directory owned by root
#chmod 0755 /var/ctf3_jail keiner außer root darf ich schreiben

#copy crypt0 to new home
mv /tmp/ctf_cpp/ /var/ctf3_jail/home
cd /var/ctf3_jail/home/ctf_cpp/src/
mv crypt0.cpp /var/ctf3_jail/home/
mv base64.h /var/ctf3_jail/home/
mv comparePw /var/ctf3_jail/home/
cd /var/ctf3_jail/home/
g++ -std=c++11 -g crypt0.cpp -o crypt0 -lssl -lcrypto
rm base64.h
rm -rf ctf_cpp/

#create the /dev files:
mknod -m 666 /var/ctf3_jail/dev/null c 1 3
mknod -m 666 /var/ctf3_jail/dev/tty c 5 0
mknod -m 666 /var/ctf3_jail/dev/zero c 1 5
mknod -m 666 /var/ctf3_jail/dev/random c 1 8


#fill etc directory with minimum files:
cd /var/ctf3_jail/etc
cp /etc/{passwd,group} .
#cp -R /etc/skel /var/ctf3_jail/etc/skel
cp /etc/ld.so.cache .
cp /etc/ld.so.conf .
cp /etc/nsswitch.conf .
cp /etc/hosts .

#copy accessible command binarys to jail
cd /var/ctf3_jail/usr/bin
cp /usr/bin/gdb .

cd /var/ctf3_jail/bin
cp /bin/ls .
#cp /bin/bash .
cp /bin/sh .


#copy needed libs
#cd /var/ctf3_jail/lib/x86_64-linux-gnu
cp -a /lib/x86_64-linux-gnu/. /var/ctf3_jail/lib/x86_64-linux-gnu # copy all

cd /var/ctf3_jail/lib64
cp /lib64/ld-linux-x86-64.so.2 . #ls
#cp /lib64/ld-linux-x86-64.so.2 . #sh
#cp /lib64/ld-linux-x86-64.so.2 . #gdb

#cd /var/ctf3_jail/usr/lib/x86_64-linux-gnu
cp -a /usr/lib/x86_64-linux-gnu/. /var/ctf3_jail/usr/lib/x86_64-linux-gnu #copy all

# python stuff for gdb
cp -r /usr/share/py* /var/ctf3_jail/usr/share/
cp -r /usr/lib/py* /var/ctf3_jail/usr/lib/

# vi stuff
cp -r /usr/bin/vim.basic /var/ctf3_jail/usr/bin/
cd /var/ctf3_jail/usr/bin/
#ln -s vim.basic ./vi #symbolic link doesnt work in ctf env

# flag stuff
mkdir /var/ctf3_jail/home/flag/
mv /var/ctf3_jail/home/comparePw /var/ctf3_jail/home/flag/
cd /var/ctf3_jail/home/flag
#echo '3d4544546d687a645452474e744a4453' > comparePw
echo 'SJgGRQ>P!-2){h}=' > passwd
chown -R winner /var/ctf3_jail/home/flag/
chmod 500 /var/ctf3_jail/home/flag/
chmod 400 /var/ctf3_jail/home/flag/comparePw
chmod 400 /var/ctf3_jail/home/flag/passwd


#cd /var/ctf3_jail/usr/local
cp -a /usr/local/. /var/ctf3_jail/usr/local #für gdb 
rm -rf /var/ctf3_jail/usr/local/bin/docker-entrypoint.sh

#berechtigungen anpassen
 chattr +i /var/ctf3_jail/home/crypt0 #immutable machen geht nicht man braucht sudo
chown winner:ctf /var/ctf3_jail/home/crypt0
chmod 4550 /var/ctf3_jail/home/crypt0






#download script for adding libs
#cd /sbin
#wget -O http://www.cyberciti.biz/files/lighttpd/l2chroot.txt
#chmod +x l2chroot

#add needed libs with script
#cd /usr/local/bin
#chmod +x l2chroot #make executable
#l2chroot ls #libs für ls dahin kopieren wo benötigt
#l2chroot sh



#add jail to sshd_config
cd /etc/ssh/
#STR=$'\nMatch user ctf3\nPasswordAuthentication yes\nChrootDirectory /var/ctf3_jail'
#echo STR >> sshd_config 
echo 'Match user ctf3' >> sshd_config
echo 'PasswordAuthentication yes' >> sshd_config
echo 'ChrootDirectory /var/ctf3_jail' >> sshd_config

echo 'Match user winner' >> sshd_config
echo 'PasswordAuthentication yes' >> sshd_config
echo 'ChrootDirectory /var/ctf3_jail' >> sshd_config



#chroot /var/ctf3_jail ssh


#restart sshd service
service sshd restart



 
/usr/sbin/sshd -D
