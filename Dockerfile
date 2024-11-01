# Use a base image with Debian
FROM debian:latest

# Install necessary packages
RUN apt-get update && apt-get install -y \
    coturn \
    certbot \
    sudo \
    nginx \
    python3 \
    python3-pip

# Set the user to root
USER root

# Install Python requests library
RUN pip3 install requests

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

# Generate the Python script to get and set external IP
RUN echo 'import requests\n\
import logging\n\
\n\
# Set up logging\n\
logging.basicConfig(filename="/var/log/coturn/set_external_ip.log", level=logging.INFO)\n\
\n\
def get_external_ip():\n\
    response = requests.get("http://checkip.amazonaws.com")\n\
    return response.text.strip()\n\
\n\
def set_external_ip(ip_address):\n\
    config_file = "/etc/coturn/turnserver.conf"\n\
    with open(config_file, "r") as file:\n\
        lines = file.readlines()\n\
\n\
    with open(config_file, "w") as file:\n\
        for line in lines:\n\
            if line.startswith("external-ip"):\n\
                file.write(f"external-ip={ip_address}\\n")\n\
            else:\n\
                file.write(line)\n\
\n\
external_ip = get_external_ip()\n\
logging.info(f"Your external IP address is: {external_ip}")\n\
print(f"Your external IP address is: {external_ip}")\n\
set_external_ip(external_ip)' > /scripts/set_external_ip.py

# Generate the start-coturn.sh script
RUN echo '#!/bin/bash\n\
\n\
# Get and set the external IP\n\
python3 /scripts/set_external_ip.py\n\
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
