#!/usr/bin/env bash

composer install

service php8.1-fpm start

nginx -g 'daemon off;'
