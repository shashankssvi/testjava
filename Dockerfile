# Use a lightweight official Java runtime as a parent image
FROM eclipse-temurin:21-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy thefat JAR file into the container at /app
# The path 'target/*.jar' works for Maven. If you use Gradle, it's 'build/libs/*.jar'
COPY out/*.jar app.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["java","-jar","app.jar"]