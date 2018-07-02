FROM alpine:latest
LABEL maintainer "Rafael Martins <rafael@rafaelmartins.eng.br>"

ENV BLOGC_VERSION 0.13.9

RUN apk add --no-cache --virtual .build-deps \
        make \
        gcc \
        musl-dev \
    && apk --no-cache add \
        bash \
        git \
        openssh \
        shadow \
    && wget https://github.com/blogc/blogc/releases/download/v$BLOGC_VERSION/blogc-$BLOGC_VERSION.tar.bz2 \
    && tar -xvjf blogc-$BLOGC_VERSION.tar.bz2 \
    && rm blogc-$BLOGC_VERSION.tar.bz2 \
    && ( \
        cd blogc-$BLOGC_VERSION \
        && ./configure \
            --prefix /usr \
            --enable-make \
            --enable-git-receiver \
        && make \
        && make install \
    ) \
    && rm -rf blogc-$BLOGC_VERSION \
    && rm -r /usr/share/man \
    && apk del .build-deps \
    && sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" /etc/ssh/sshd_config \
    && echo -e "AllowUsers blogc\n" >> /etc/ssh/sshd_config \
    && echo -e "Port 22\n" >> /etc/ssh/sshd_config \
    && echo -e "PrintMotd no\n" >> /etc/ssh/sshd_config \
    && addgroup blogc \
    && adduser \
        -D \
        -S \
        -s /usr/bin/blogc-git-receiver \
        -h /home/blogc \
        -g blogc \
        blogc \
    && mkdir -p /home/blogc/.ssh \
    && chown -R blogc:blogc /home/blogc \
    && busybox passwd -u blogc

EXPOSE 22

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config"]
