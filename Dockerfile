FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/vevc/ubuntu"

ENV TZ=Asia/Shanghai \
    SSH_USER=ubuntu \
    SSH_PASSWORD=ubuntu!23 \
    START_CMD=''

COPY entrypoint.sh /entrypoint.sh
COPY reboot.sh /usr/local/sbin/reboot

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get install -y tzdata openssh-server dropbear htop nano virt-what p7zip-full sudo curl ca-certificates wget vim net-tools supervisor cron unzip iputils-ping telnet git iproute2 --no-install-recommends; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir /var/run/sshd; \
    chmod +x /entrypoint.sh; \
    chmod +x /usr/local/sbin/reboot; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone

RUN sed -i 's/^#Port 22/Port 8880/' /etc/ssh/sshd_config
RUN sed -i 's/^Port 22/Port 8880/' /etc/ssh/sshd_config
RUN echo "/usr/sbin/dropbear -p 2082" > /etc/init.d/dropbear_start.sh && \
    chmod +x /etc/init.d/dropbear_start.sh


EXPOSE 22 8880 2082


ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
CMD ["/usr/sbin/dropbear -p 2082", "-D"]
