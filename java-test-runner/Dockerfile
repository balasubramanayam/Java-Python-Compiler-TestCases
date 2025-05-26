# Use OpenJDK 17 Slim as the base image
FROM openjdk:17-slim

# Set working directory
WORKDIR /app

# Copy pre-downloaded JAR files (download these manually to your local directory)
COPY junit-4.13.2.jar /app/junit-4.13.2.jar
COPY hamcrest-core-1.3.jar /app/hamcrest-core-1.3.jar

# Copy the test runner script
COPY run-tests.sh /app/run-tests.sh

# Set permissions for script execution
RUN chmod +x /app/run-tests.sh

# Create a non-root user for security
RUN useradd -m testuser
USER testuser

# Set resource limits
ENV JAVA_OPTS="-Xmx256m -XX:MaxRAM=512m -XX:+ExitOnOutOfMemoryError"

# Set classpath for JUnit
ENV CLASSPATH="/app/junit-4.13.2.jar:/app/hamcrest-core-1.3.jar:."

# Define default command
ENTRYPOINT ["/app/run-tests.sh"]