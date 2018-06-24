FROM ubuntu:16.04

RUN apt-get update && apt-get install -y git openssh-server libssl-dev openssl software-properties-common g++ libc6-dbg gdb valgrind nano
# SSH stuff
RUN mkdir /var/run/sshd
RUN echo 'root:123456789' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22:22

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat



CMD ["/docker-entrypoint.sh"]
