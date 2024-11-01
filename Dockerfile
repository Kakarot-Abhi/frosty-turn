# Use a base image with Debian
FROM debian:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    coturn \
    certbot \
    sudo

# Set the user to root
USER root

# Copy the Coturn configuration file
COPY ./turnserver.conf /etc/coturn/turnserver.conf

# Create the scripts directory
RUN mkdir -p /scripts

# Generate the start-coturn.sh script
RUN echo '#!/bin/bash\n\
\n\
# Start Certbot to generate/renew certificates\n\
certbot certonly --standalone --preferred-challenges http -d frosty-turn.onrender.com --agree-tos --email kakaroto79333@gmail.com --non-interactive\n\
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
