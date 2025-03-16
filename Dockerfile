# Usa a imagem oficial do PHP com Apache
FROM php:8.2-apache

# Instala extensões do PHP necessárias para Laravel e PostgreSQL
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo pdo_pgsql

# Habilita o mod_rewrite do Apache para suportar Laravel
RUN a2enmod rewrite

# Define o diretório de trabalho
WORKDIR /var/www/html

# Copia os arquivos do projeto para o container
COPY . .

# Dá permissão ao storage e bootstrap/cache (Laravel precisa disso)
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expõe a porta 80
EXPOSE 80

# Comando para iniciar o Apache
CMD ["apache2-foreground"]
