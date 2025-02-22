# Utiliser une image PHP avec Apache
FROM php:8.0-apache

# Installer les extensions PHP nécessaires pour Laravel
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql

# Activer mod_rewrite pour Apache (important pour Laravel)
RUN a2enmod rewrite

# Copier les fichiers du projet Laravel dans le conteneur
COPY . /var/www/html

# Définir le répertoire de travail
WORKDIR /var/www/html

# Installer Composer pour gérer les dépendances PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Installer les dépendances du projet via Composer
RUN composer install --no-dev --optimize-autoloader

# Donner les permissions appropriées pour les dossiers de Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exposer le port 80 pour Apache
EXPOSE 80

# Commande pour démarrer Apache et Laravel
CMD ["apache2-foreground"]
