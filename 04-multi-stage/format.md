```
FROM classpathio/base AS compile-stage
RUN echo 'Compiling...' > /build.txt

FROM classpathio/base AS build-stage
COPY --from=compile-stage /build.txt /build.txt
RUN echo 'Building...' > /build.txt
 
FROM classpathio/base AS test-stage
COPY --from=build-stage /build.txt /build.txt
RUN echo 'Testing...' >> /build.txt
 
FROM classpathio/base
COPY --from=test-stage /build.txt /output.txt
CMD cat /output.txt
```