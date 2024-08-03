FROM openjdk:8-jdk-alpine as builder
WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
RUN chmod +x ./mvnw
RUN ./mvnw -B dependency:go-offline

COPY src src
RUN ./mvnw package -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)


# app
FROM openjdk:8-jre-alpine as stage

ARG DEPENDENCY=/app/target/dependency

# Copy the dependency application file from builder stage artifact
COPY --from=builder ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=builder ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=builder ${DEPENDENCY}/BOOT-INF/classes /app

EXPOSE 5555
ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.classpath.itemsapi.ItemsApiApplication"]
