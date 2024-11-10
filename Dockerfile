# Use an official Node.js base image (adjust as needed)
FROM node:16-slim

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json first (if available)
COPY package.json package-lock.json* /app/

# Install dependencies
RUN npm install

# Now copy the rest of the application files
COPY . /app/

# Expose port 8080 to match your desired port
EXPOSE 8080

# Define the command to start the application
CMD ["npm", "run", "serve", "--", "--public", "--port", "8080"]
