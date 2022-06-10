FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN  apt-get update && \
     apt-get -y install \
             software-properties-common

RUN apt-get install webp  -y
RUN apt-get install unzip  -y

# Install Apache and PHP
RUN add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get -y install \
            zip \
            curl \
            apache2 \
            php8.1 \
            libapache2-mod-php8.1 \
            php8.1-mysql \
            php8.1-curl \
            php8.1-gd \
            php8.1-imagick \
            php8.1-cli \
            php8.1-mbstring \
            php8.1-zip \
            php8.1-xml \
            php8.1-soap \
            php8.1-xdebug \
            php8.1-pcov \
            php8.1-redis \
       --no-install-recommends && \
       apt-get clean && \
       rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable apache mods
RUN a2enmod rewrite headers expires php8.1

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    composer clear-cache

# Install NodeJS
RUN apt -y install dirmngr apt-transport-https lsb-release ca-certificates

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -

RUN apt -y install nodejs

RUN apt install iputils-ping -y
RUN apt install telnet -y
RUN apt install vim -y
RUN apt install php8.1-sqlite3 -y

COPY image-files/ /

RUN rm ~/.ssh -rf
RUN mkdir ~/.ssh && ln -s /run/secrets/host_ssh_key ~/.ssh/id_rsa

WORKDIR /app

EXPOSE 80

ADD start.sh /
RUN chmod +x /start.sh

CMD ["/start.sh"]
#CMD ["/usr/sbin/apachectl","-DFOREGROUND"]
