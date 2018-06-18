#!/bin/bash

#/etc/init.d/apache2 start
#useradd -M ctf3
#groupadd ctf
#usermod -a -G ctf ctf3
#usermod -d /home/ctf
#chmod -R o -wx /
#chmod -R o -rx +w /tmp



cd /tmp/
git clone https://github.com/Xaldin90/ctf_cpp.git
cd /ctf_cpp/src
g++ -std=c++11 abc.cpp -o crypt0 -lssl -lcrypto
#mv crypt0 /home/ctf
#rm -rf /tmp/ctf_cpp




 
/usr/sbin/sshd -D