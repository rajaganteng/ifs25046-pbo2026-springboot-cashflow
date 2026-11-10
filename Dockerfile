# Tahap 1: build jar (profile production wajib untuk Vaadin)
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -B -Pproduction dependency:go-offline
COPY src ./src
COPY frontend ./frontend
COPY package.json package-lock.json tsconfig.json types.d.ts ./
RUN mvn -B -Pproduction package -DskipTests

# Tahap 2: jalankan jar
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
ENV APP_PORT=8080
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
