# Use an official Ubuntu image
FROM ubuntu:20.04

# Install Coturn and create necessary directories
RUN apt-get update && \
    apt-get install -y coturn && \
    apt-get clean && \
    mkdir -p /var/lib/turn && \
    chown -R turnserver:turnserver /var/lib/turn && \
    chmod -R 755 /var/lib/turn

# Set the TURN server name as an environment variable
ENV TURN_SERVER_NAME=frosty-turn

# Pass external IP via environment variable to avoid Docker runtime issues
ARG EXTERNAL_IP
ENV EXTERNAL_IP=${EXTERNAL_IP}

# Copy the TURN server configuration file
COPY turnserver.conf /etc/turnserver.conf

# Expose necessary ports
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 443/tcp

## Start the TURN server
#ENTRYPOINT ["turnserver", "-c", "/etc/turnserver.conf", "--no-cli"]
# Add this as part of your Docker ENTRYPOINT in the Dockerfile
ENTRYPOINT ["sh", "-c", "turnserver -c /etc/turnserver.conf --external-ip $(curl -s ifconfig.me)"]