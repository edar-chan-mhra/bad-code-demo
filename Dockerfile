# Use an outdated base image
FROM ubuntu:14.04

# Run container as root user
USER root

# Install packages without verification
RUN apt-get update && \
    apt-get install -y \
    python \
    python-pip \
    mysql-client \
    curl

# Install an insecure Python package
RUN pip install flask==0.10.1

# Copy the application files
COPY . /app

# Set the working directory
WORKDIR /app

# Expose unnecessary ports
EXPOSE 80 22

# Set environment variables with sensitive information
ENV DATABASE_USER=root
ENV DATABASE_PASSWORD=password

# Run the application
CMD ["python", "app.py"]
