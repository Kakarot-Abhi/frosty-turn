# Use an official base image with a specific version of Node.js or other runtime based on your project needs
FROM node:16-slim

# Set the working directory
WORKDIR /app

# Copy your JioTVGo project files into the container
COPY . /app

# Install the necessary dependencies
RUN npm install

# Expose port 8080 to match your desired port
EXPOSE 8080

# Define the entrypoint for running the application
CMD ["npm", "run", "serve", "--", "--public", "--port", "8080"]
