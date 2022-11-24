FROM handsonsecurity/seed-server:apache-php

ARG WWWDir=/var/www/seed-server

COPY Code $WWWDir
COPY apache_sql_injection.conf  /etc/apache2/sites-available
RUN  a2ensite apache_sql_injection.conf 



