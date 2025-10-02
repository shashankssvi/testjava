# --- Stage 1: The Build Stage ---
FROM eclipse-temurin:21-jdk as builder
WORKDIR /app
COPY . .

# --- DEBUGGING STEP ---
# This will list all files and their permissions so we can see what's happening
RUN ls -la

# --- The rest of the file (will fail after the step above) ---
RUN chmod +x ./gradlew
RUN ./gradlew build

# --- Stage 2: The Final Stage ---
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
