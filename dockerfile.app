FROM php:fpm
MAINTAINER Michael Woodward <michael@wearejh.com>

RUN apt-get update \
  && apt-get install -y \
    cron \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libxslt1-dev \
    gettext \
    msmtp \
    git

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  gd \
  intl \
  mbstring \
  mcrypt \
  pdo_mysql \
  zip

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Xdebug
RUN pecl install -o -f xdebug-2.5.0

COPY .docker/php/bin/docker-configure /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-configure

COPY ./ /var/www

# xdebug and PHP configuration files
COPY .docker/php/etc/xdebug.template /usr/local/etc/php/conf.d/php-xdebug.template
COPY .docker/php/etc/php.template /usr/local/etc/php/conf.d/php-custom.template

# Shouldn't need volume
# VOLUME /var/www

# TODO: I think to make it shippable you want vendor in the image
# TODO: But... you lose all cache by doing this, and also SSH keys etc.
# TODO: Alternative we run composer install on entrypoint
# RUN composer install

ENTRYPOINT ["/usr/local/bin/docker-configure"]
CMD ["php-fpm"]