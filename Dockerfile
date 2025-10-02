# --- Stage 1: The Build Stage ---
# Use a full JDK image to build the application
FROM eclipse-temurin:21-jdk as builder

# Set the working directory
WORKDIR /app

# Copy the project files into the build stage
COPY . .

# --- IMPORTANT ---
# This line builds your project.
# If you are using Gradle, use: RUN ./gradlew build
# If you are using Maven, use: RUN ./mvnw package
# If your project doesn't have a wrapper, you might need to adjust this.
# For now, let's assume a generic build command might create the 'out' folder.
# If you have a build script, run it here. For now, I'll use a placeholder.
# PLEASE VERIFY YOUR BUILD COMMAND. For an IntelliJ project, it might be more complex.
# If you build the JAR locally and push it, that's another strategy, but building in Docker is better.
# For this example, I'll assume a standard Gradle build which creates a jar in build/libs.
RUN ./gradlew build

# --- Stage 2: The Final Stage ---
# Use a lightweight JRE-only image for the final container
FROM eclipse-temurin:21-jre-alpine

# Set the working directory
WORKDIR /app

# Copy ONLY the built JAR file from the 'builder' stage to the final stage
# NOTE: The path might be different depending on your build tool.
# Gradle puts it in 'build/libs/'. Maven in 'target/'.
# We need to confirm where your specific build process creates the JAR.
# Assuming Gradle for this example:
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose the port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java","-jar","app.jar"]
