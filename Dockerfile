# --- Stage 1: The Build Stage ---
# Use a full JDK image to build the application
FROM eclipse-temurin:21-jdk as builder

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# --- FIX IS HERE ---
# Grant execute permission to the gradlew script
RUN chmod +x ./gradlew

# Now, build your project
RUN ./gradlew build

# --- Stage 2: The Final Stage ---
# Use a lightweight JRE-only image for the final container
FROM eclipse-temurin:21-jre-alpine

# Set the working directory
WORKDIR /app

# Copy ONLY the built JAR file from the 'builder' stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose the port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
