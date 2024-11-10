# Use the official JioTVGo image from GitHub Container Registry
FROM ghcr.io/jiotv-go/jiotv_go:latest

# Set the working directory
WORKDIR /app

# Expose port 8080
EXPOSE 8080

# Set the default command to start the JioTVGo server with the desired options
CMD ["serve", "--public", "--port", "8080"]
