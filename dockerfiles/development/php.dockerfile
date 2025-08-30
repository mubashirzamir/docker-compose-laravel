ARG PHP_VERSION=php:8.3-fpm-alpine

FROM php:8.3-fpm-alpine

ARG COMPOSER_VERSION="composer:2.6"
ARG PHP_EXTENSIONS="pdo pdo_pgsql"
ARG UID
ARG GID

ENV COMPOSER_VERSION=${COMPOSER_VERSION}
ENV PHP_EXTENSIONS=${PHP_EXTENSIONS}
ENV UID=${UID}
ENV GID=${GID}

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

# TODO: Need to figure out how to make composer installation dynamic
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup --gid ${GID} --system laravel
RUN adduser -DS -G laravel -s /bin/sh -u ${UID} laravel

# TODO: How to make laravel installer version configurable.
# Install Laravel installer as laravel user
USER laravel
RUN composer global require laravel/installer
USER root
RUN ln -s /home/laravel/.composer/vendor/bin/laravel /usr/local/bin/laravel

RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

RUN set -ex \
  && apk --no-cache add \
    postgresql-dev

RUN docker-php-ext-install ${PHP_EXTENSIONS}

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

# Conduct impact analysis
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions xdebug @composer

USER laravel

CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]
