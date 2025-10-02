# --- Stage 1: Build the project from source ---
FROM eclipse-temurin:17-jdk as builder
WORKDIR /app
COPY gradlew ./
COPY gradle ./gradle/
COPY build.gradle.kts ./
COPY settings.gradle.kts ./
RUN chmod +x ./gradlew
COPY src ./src
RUN ./gradlew build --no-daemon

# --- Stage 2: Run the built JAR file ---
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
