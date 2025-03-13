# Use Node.js runtime as the base image
#FROM node:18
FROM node:18-bookworm

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install
RUN apt-get update && apt-get install -y libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2


# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
#EXPOSE 8080

# Command to run the application
CMD ["node", "dashjs_world.js"]
#CMD tail -f /dev/null
