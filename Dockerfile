# Use the official Coturn Docker image
FROM coturn/coturn:latest

# Copy your TURN server configuration file
COPY turnserver.conf /etc/turnserver.conf

# Expose necessary ports for Coturn
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 443/tcp

# Set environment variables for external IP detection
ENV DETECT_EXTERNAL_IP=yes
ENV DETECT_RELAY_IP=yes

# Start the TURN server with dynamically fetched external IP
ENTRYPOINT ["turnserver", "-c", "/etc/turnserver.conf"]
