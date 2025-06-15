#!/bin/bash

echo "Building Spa Management System..."

# Clean and build with Maven
mvn clean package -DskipTests

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build successful! JAR file created at target/spa-management-1.0.0.jar"
    ls -la target/*.jar
else
    echo "Build failed!"
    exit 1
fi 