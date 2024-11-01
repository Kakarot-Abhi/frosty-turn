# Use the official Coturn image
FROM coturn/coturn AS coturn-base

# Set the user to root
USER root

# Create an intermediate image for scripts
FROM coturn-base AS scripts-base

# Create the scripts directory and add the start-coturn.sh script
RUN mkdir -p /scripts

# Generate the start-coturn.sh script
RUN echo '#!/bin/bash\n\
\n\
# Start Certbot to generate/renew certificates\n\
certbot certonly --standalone --preferred-challenges http -d frosty-turn.onrender.com --agree-tos --email your-email@example.com --non-interactive\n\
\n\
# Start the Coturn server\n\
turnserver -c /etc/coturn/turnserver.conf' > /scripts/start-coturn.sh

# Make the script executable
RUN chmod +x /scripts/start-coturn.sh

# Final stage
FROM coturn/coturn

# Set the user to root
USER root

# Copy the Coturn configuration file
COPY ./turnserver.conf /etc/coturn/turnserver.conf

# Copy the scripts from the intermediate stage
COPY --from=scripts-base /scripts/ /scripts/

# Set the necessary volumes
VOLUME /etc/letsencrypt/ /var/log/coturn/

# Expose the necessary ports
EXPOSE 80 443

# Start the Coturn server using the generated script
CMD ["/scripts/start-coturn.sh"]
