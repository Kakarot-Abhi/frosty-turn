# Use the official Coturn Docker image
FROM coturn/coturn:latest

## Switch to root to install curl
#USER root
#
## Install curl for external IP detection
#RUN apt-get update && \
#    apt-get install -y curl && \
#    apt-get clean
#
## Switch back to the default user (if needed by your Coturn setup)
#USER coturn

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
ENTRYPOINT ["sh", "-c", "turnserver -c /etc/turnserver.conf"]
