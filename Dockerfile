# --- Stage 1: Build the project from source ---
# Use the JDK 21 image to build the project
FROM eclipse-temurin:21-jdk as builder

WORKDIR /app
COPY gradlew ./
COPY gradle ./gradle/
COPY build.gradle.kts ./
RUN chmod +x ./gradlew
COPY src ./src
RUN ./gradlew build --no-daemon

# --- Stage 2: Run the built JAR file ---
# Use the lightweight JRE 21 image for the final container
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
