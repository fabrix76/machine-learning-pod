FROM debian:latest

LABEL maintainer "Fabrizio Mantione (fabrizio.mantione@gmail.com)"
LABEL description "Jupyter lab (port 8888) with cron and crontab-ui web frontend (port 80) to manage cron schedulation"

ENV PATH=/usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ENV DEBIAN_FRONTEND=noninteractive

ENV CRON_PATH /etc/crontabs
ENV CRON_IN_DOCKER true

USER root

WORKDIR /opt/jupyter

RUN apt-get update \
    && apt-get install -y --no-install-recommends cron nano nodejs npm python3 python3-dev python3-pip python3-setuptools mariadb-common libmariadb-dev build-essential git curl supervisor julia php php-zmq scilab octave \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
COPY supervisord.conf /etc/supervisord.conf
COPY start-crontab-ui.sh /start-crontab-ui.sh
COPY install_kernel.jul /tmp

RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install --trusted-host pypi.python.org -r requirements.txt --use-feature=2020-resolver

RUN curl https://raw.githubusercontent.com/alberthier/git-webui/master/install/installer.sh | bash

RUN npm config set user 0
RUN npm config set unsafe-perm true

RUN npm install -g crontab-ui

RUN julia /tmp/install_kernel.jul
RUN rm /tmp/install_kernel.jul

RUN python3 -m bash_kernel.install
RUN python3 -m octave_kernel install

RUN curl https://getcomposer.org/composer-stable.phar --output /tmp/composer-stable.phar
RUN chmod +x /tmp/composer-stable.phar
RUN mv /tmp/composer-stable.phar /usr/local/bin/composer

RUN curl https://litipk.github.io/Jupyter-PHP-Installer/dist/jupyter-php-installer.phar --output /tmp/jupyter-php-installer.phar
RUN chmod +x /tmp/jupyter-php-installer.phar
RUN /tmp/jupyter-php-installer.phar install
RUN rm /tmp/jupyter-php-installer.phar

RUN jupyter lab build

COPY . .

EXPOSE 8888 80 8080 8000

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
