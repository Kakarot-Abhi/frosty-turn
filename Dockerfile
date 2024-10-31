# Use an official Ubuntu image
FROM ubuntu:20.04

# Install Coturn and necessary packages
RUN apt-get update && \
    apt-get install -y coturn curl openssl && \
    apt-get clean && \
    mkdir -p /var/lib/turn && \
    chown -R turnserver:turnserver /var/lib/turn && \
    chmod -R 755 /var/lib/turn

# Set the TURN server name as an environment variable
ENV TURN_SERVER_NAME=frosty-turn

# Generate self-signed certificates
RUN openssl req -new -x509 -days 365 -nodes \
    -out /etc/turn_server_cert.pem \
    -keyout /etc/turn_server_pkey.pem \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=frosty-turn.onrender.com"

# Copy the TURN server configuration file
COPY turnserver.conf /etc/turnserver.conf

# Expose necessary ports
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 443/tcp

# Start the TURN server with dynamically fetched external IP
ENTRYPOINT ["sh", "-c", "turnserver -c /etc/turnserver.conf --external-ip $(curl -s ifconfig.me)"]
