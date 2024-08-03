# Set of commands to create a docker image
# the instructions to convert our application to a docker image
# Base image
# docker commands 
# we are giving an alias builder for this image
FROM openjdk:11-jdk-slim as builder

# we are navigating to /app
WORKDIR /app
#copies file/directory from src location to destination location
# we need below files to be copied so container can use use maven commands to download the dependencies
COPY mvnw .
COPY .mvn .mvn 
COPY pom.xml .

# Run the dos2unix command - this utility is installed in the container
# below utility is required required to get rid of some line ending issues 
# we face while tranferring text files from windows to unix
RUN apt-get update && apt-get install -y dos2unix

#creates a container
# Ensure the Maven wrapper is executable and convert line endings
# we want our container to run mvn package, the below downloads the dependencies in the container
RUN dos2unix mvnw && chmod +x mvnw && ./mvnw -B dependency:go-offline
#builds an image having all the dependencies in the image and disposes the container

# copies the src to src of /app in the image, we must not share the src to the customer
# we are going to create a brand new image later it will not have src
COPY src src
# this runs the package command to compile & build the jar for the application
# we are skipping tests as we don't need this while building the artifact else it simply takes time
RUN ./mvnw package -DskipTests
# by this time jar is ready in the target folder of the image

# we are telling the container to create a target/dependency and 
# extract the content of the jar file to the dependency folder
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)
# at this place one stage ends we should not give this image because it has so many unnecessary things
# it also have source code, if you give source code then why would customer return to you
# hence we need to write an instruction for the image in another stage that uses the image using above instructions
# the image we get from the next stage will be shared with the customer that will have the 
# application which can be run, but not the above image
# look at the 1st line it has JDK which not required for execution, it needs only for the compilation
#---------------------Here the one stage ends and we create the next image from the above images that is shared with the customer --------------------#

# this creates a brand new image, but this time it uses JRE
FROM openjdk:11.0.13-jre-slim-buster as stage

#argument we are creating a variable having the below path
ARG DEPENDENCY=/app/target/dependency

# copies the above image from source to destination 
# here the source is builder which is the above image, from that the 
#  DEPENDENCY which is /app/target/dependency 
# and its content like BOOT-INF, META-INF which are source, and destination is app folder
# Copy the dependency application file from builder stage artifact
COPY --from=builder ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=builder ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=builder ${DEPENDENCY}/BOOT-INF/classes /app

# just for development purpose
RUN apt update && apt install -y curl
EXPOSE 8081
# once you run the container below command is executed which searches the entry point inside app/lib
ENTRYPOINT ["java", "-cp", "app:app/lib/*", "com.classpathio.order.OrderMicroserviceApplication"]