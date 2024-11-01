# Use a base image with Debian
FROM debian:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    coturn \
    certbot \
    sudo \
    nginx

# Set the user to root
USER root

# Copy the Coturn configuration file
COPY ./turnserver.conf /etc/coturn/turnserver.conf

# Create the scripts directory
RUN mkdir -p /scripts

# Create a directory for the challenge files
RUN mkdir -p /var/www/certbot

# Generate the Nginx configuration file
RUN echo 'server {\n\
    listen 80;\n\
    server_name frosty-turn.onrender.com;\n\
\n\
    location /.well-known/acme-challenge/ {\n\
        root /var/www/certbot;\n\
    }\n\
\n\
    location / {\n\
        return 404;\n\
    }\n\
}' > /etc/nginx/sites-available/default

# Generate the start-coturn.sh script
RUN echo '#!/bin/bash\n\
\n\
# Start Nginx for Certbot HTTP challenge\n\
nginx\n\
\n\
# Start Certbot to generate/renew certificates\n\
certbot certonly --webroot -w /var/www/certbot -d frosty-turn.onrender.com --agree-tos --email kakaroto79333@gmail.com --non-interactive\n\
\n\
# Stop Nginx after Certbot is done\n\
nginx -s stop\n\
\n\
# Start the Coturn server\n\
turnserver -c /etc/coturn/turnserver.conf --no-cli' > /scripts/start-coturn.sh

# Make the script executable
RUN chmod +x /scripts/start-coturn.sh

# Set the necessary volumes
VOLUME /etc/letsencrypt/ /var/log/coturn/

# Expose the necessary ports
EXPOSE 80 443

# Start the Coturn server using the generated script
CMD ["/bin/bash", "/scripts/start-coturn.sh"]
