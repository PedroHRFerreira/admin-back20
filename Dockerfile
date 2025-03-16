# Usa a imagem oficial do PHP com Apache
FROM php:8.2-apache

# Instala dependências do sistema e extensões PHP necessárias
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring zip

# Instala o Composer (usando a imagem oficial do Composer)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Ativa o mod_rewrite e define um ServerName para evitar avisos
RUN a2enmod rewrite && echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Configura o DocumentRoot para apontar para a pasta public do Laravel
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Define o diretório de trabalho
WORKDIR /var/www/html

# Copia os arquivos da aplicação para dentro do container
COPY . .

# Instala as dependências do Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Ajusta permissões para pastas críticas do Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expõe a porta 80 para acesso HTTP
EXPOSE 80

# Comando para iniciar o Apache em primeiro plano
CMD ["apache2-foreground"]
