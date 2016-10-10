FROM debian:7.8

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php-pear \
        php-apc \
        wkhtmltopdf \
        ghostscript \
        xvfb && \
    rm -rf /var/lib/apt/lists/*

ADD run.sh /run.sh
RUN chmod 755 /*.sh

RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/local/bin \
    && chmod a+x /usr/local/bin/composer

ADD apache2_pdfgenerator.local /etc/apache2/sites-available/pdfgenerator.local.conf
RUN a2ensite pdfgenerator.local.conf && a2dissite default

COPY tmp/ /var/www/

RUN cd /var/www/pdfGenerator && \
    chown -R www-data: /var/www/pdfGenerator && \
    su www-data -c "SYMFONY_ENV=prod composer install -on --prefer-dist --no-dev" && \
    rm -rf /var/www/.composer

EXPOSE 80
CMD ["/run.sh"]
