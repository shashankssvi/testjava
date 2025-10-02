# --- Stage 1: The Build Stage ---
# Use a full JDK image to build your Kotlin application
FROM eclipse-temurin:17-jdk as builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Gradle wrapper files first to leverage Docker layer caching
COPY gradlew ./
COPY gradle ./gradle/

# Copy the build configuration files
COPY build.gradle.kts ./
COPY settings.gradle.kts ./

# Grant execute permission to the gradlew script
# This is the critical fix for the 'exit code 127' error
RUN chmod +x ./gradlew

# Now, copy the rest of your source code
COPY src ./src

# Build the application. This creates the JAR file.
# The --no-daemon flag is recommended for CI/CD environments like this.
RUN ./gradlew build --no-daemon

# --- Stage 2: The Final Stage ---
# Use a lightweight JRE-only image for the final, small container
FROM eclipse-temurin:17-jre-alpine

# Set the working directory
WORKDIR /app

# Copy ONLY the built JAR file from the 'builder' stage to the final container
# Gradle builds the JAR in the 'build/libs' directory
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose the port your application runs on (default for Spring Boot is 8080)
EXPOSE 8080

# The command to run your application
ENTRYPOINT ["java","-jar","app.jar"]
