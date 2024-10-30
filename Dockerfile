# Use an official Ubuntu base image
FROM ubuntu:20.04

# Install Coturn and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y coturn && \
    apt-get clean

# Copy the TURN server configuration file
COPY turnserver.conf /etc/turnserver.conf

# Expose necessary ports (3478 for UDP/TCP, 443 for TLS)
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 443/tcp

# Start Coturn server
ENTRYPOINT ["turnserver", "-c", "/etc/turnserver.conf", "--no-cli"]
