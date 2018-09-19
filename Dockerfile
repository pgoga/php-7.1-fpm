FROM php:7.1-fpm

RUN echo Europe/Moscow | tee /etc/timezone \
 && dpkg-reconfigure --frontend noninteractive tzdata \
 && apt-get update \
 && apt-get -y install -qq --force-yes \
    curl \
    libbz2-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libgmp-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libncurses5-dev \
    libpng-dev \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    netcat \
    unzip \
    zlib1g-dev \
 && apt-get install -y libpq-dev \
 && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
 && docker-php-ext-install pdo pdo_pgsql pgsql \
 && docker-php-ext-install -j$(nproc) \
    bcmath \
    bz2 \
    iconv \
    intl \
    mcrypt \
    mbstring \
    mysqli \
    opcache \
    pdo \
    pdo_mysql \
    soap \
    xsl \
    zip \
 && pecl install -o -f redis \
 &&  rm -rf /tmp/pear \
 &&  docker-php-ext-enable redis \
 && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
    --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ \
 && docker-php-ext-install -j$(nproc) gd \
 && pecl install mongodb \
 && docker-php-ext-enable mongodb \
 && mkdir -p /usr/src/php/ext/ \
 && cd /tmp \
 && curl -o php-memcached-php7.zip https://codeload.github.com/php-memcached-dev/php-memcached/zip/php7 \
 && unzip php-memcached-php7.zip \
 && mv php-memcached-php7 /usr/src/php/ext/memcached \
 && cd /usr/src/php/ext/memcached \
 && docker-php-ext-configure memcached \
 && docker-php-ext-install memcached \
 && apt-get remove --purge -y cpp python* libpython* $(apt-cache search dev|grep "\-dev"|cut -d' ' -f1|sort) \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
