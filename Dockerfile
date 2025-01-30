# Utiliser l'image officielle de WordPress comme base
FROM wordpress:latest

# Définir les variables d'environnement pour la base de données
ENV WORDPRESS_DB_USER=wordpress
ENV WORDPRESS_DB_PASSWORD=ilovedevops
ENV WORDPRESS_DB_NAME=wordpress
ENV WORDPRESS_DB_HOST=0.0.0.0

# Exposer le port par défaut de WordPress (80)
EXPOSE 80

# Lancer le serveur WordPress
CMD ["apache2-foreground"]
