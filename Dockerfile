FROM ubuntu:22.04

# Set working directory
WORKDIR /var/www

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update && apt-get install -y nginx ca-certificates curl zip unzip

# Install PHP and extenstions
RUN apt-get install -y php8.1-fpm php8.1-xml php8.1-dom

# Install composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

# Install Symfony CLI
RUN curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash \
    && apt-get install -y symfony-cli

# Make apt-get clean
RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy custom configurations
COPY ./docker/app/etc/php/config-override.ini /etc/php/8.1/fpm/conf.d/config-override.ini
COPY ./docker/app/etc/nginx/app.conf /etc/nginx/sites-enabled/default

# Set user and group
RUN groupadd --force -g 1000 www-data
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

###> recipes ###
### recipes ###

ENTRYPOINT ["sh", "./docker/app/entrypoint.sh"]
