# Use the official Coturn Docker image
FROM coturn/coturn:latest

# Install curl for external IP detection if necessary
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean

# Copy your TURN server configuration file
COPY turnserver.conf /etc/turnserver.conf

# Expose necessary ports for Coturn
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 443/tcp

# Set environment variables for external IP detection
ENV DETECT_EXTERNAL_IP=yes
ENV DETECT_RELAY_IP=yes

# Start the TURN server with logging to stdout
ENTRYPOINT ["turnserver", "-c", "/etc/turnserver.conf", "--log-file=stdout"]
