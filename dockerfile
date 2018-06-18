FROM ubuntu:16.04

RUN apt-get update && apt-get install -y openssh-server apache2 git libapache2-mod-php7.0 g++ libssl-dev openssl software-properties-common
# SSH stuff
RUN mkdir /var/run/sshd
RUN echo 'root:q5*1A3n?' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22:22

RUN ls

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

CMD ["/docker-entrypoint.sh"]