FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY out/artifacts/demo_jar/demo.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
