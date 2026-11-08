# Tahap 1: build jar
FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B dependency:go-offline
COPY src ./src
RUN mvn -B package -DskipTests

# Tahap 2: jalankan jar
FROM eclipse-temurin:25-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENV APP_PORT=8080
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
