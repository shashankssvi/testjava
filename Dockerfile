# --- Stage 1: The Build Stage ---
# Use the JDK 21 image to build the project
FROM eclipse-temurin:21-jdk as builder
WORKDIR /app

# Copy the Maven wrapper and pom.xml to leverage Docker layer caching
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Grant execute permission to the Maven wrapper
RUN chmod +x ./mvnw

# Copy the rest of your source code
COPY src ./src

# Build the application and package it into a JAR file. Skipping tests speeds up the build.
RUN ./mvnw package -DskipTests

# --- Stage 2: The Final Stage ---
# Use the lightweight JRE 21 image for the final container
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy ONLY the built JAR file from the builder stage. Maven builds to the 'target' directory.
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
