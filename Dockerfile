FROM php:7.4-cli-alpine

# Install unzip (busybox version is buggy)
RUN apk update && apk add unzip

# Install PHP extensions
COPY --from=mlocati/php-extension-installer \
    /usr/bin/install-php-extensions \
    /usr/bin/
RUN install-php-extensions apcu intl opcache xdebug xsl zip

# Set up PHP config
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
COPY config/php/apcu.ini $PHP_INI_DIR/conf.d/
COPY config/php/docker-php.ini $PHP_INI_DIR/conf.d/
COPY config/php/opcache.ini $PHP_INI_DIR/conf.d/
COPY config/php/xdebug.ini $PHP_INI_DIR/conf.d/

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
