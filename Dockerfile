# Use an official Ubuntu image
FROM ubuntu:20.04

# Install Coturn
RUN apt-get update && \
    apt-get install -y coturn && \
    apt-get clean

# Set the TURN server name as an environment variable
ENV TURN_SERVER_NAME=frosty-turn

# Copy the TURN server configuration file
COPY turnserver.conf /etc/turnserver.conf

# Expose necessary ports
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 443/tcp

# Start the TURN server
ENTRYPOINT ["turnserver", "-c", "/etc/turnserver.conf", "--no-cli"]
