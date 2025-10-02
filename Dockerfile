# Use a lightweight JRE-only image, since the code is already built
FROM eclipse-temurin:21-jre-alpine

# Set the working directory
WORKDIR /app

# Copy your pre-built JAR file from the correct path into the container
COPY build/libs/demo-0.0.1-SNAPSHOT.jar app.jar

# Expose the port your application runs on (default for Spring Boot is 8080)
EXPOSE 8080

# The command to run your application
ENTRYPOINT ["java","-jar","app.jar"]
