# --- Use a lightweight JRE 21 image, since the code is already built ---
FROM eclipse-temurin:21-jre-alpine

# --- Set the working directory inside the container ---
WORKDIR /app

# --- Copy your pre-built JAR file from the 'target' folder ---
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# --- Expose the port your application runs on ---
EXPOSE 8080

# --- The command to run your application ---
ENTRYPOINT ["java","-jar","app.jar"]