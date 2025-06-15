# Use OpenJDK 17 as base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Install Maven
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Copy Maven files
COPY pom.xml .
COPY src ./src
COPY web ./web

# Build the application
RUN mvn clean package -DskipTests

# Expose port (Railway will set the PORT env variable)
EXPOSE $PORT

# Create a non-root user
RUN useradd -r -s /bin/false spa-user
RUN chown -R spa-user:spa-user /app
USER spa-user

# Run the application
CMD ["java", "-jar", "target/spa-management-1.0.0.jar"] 