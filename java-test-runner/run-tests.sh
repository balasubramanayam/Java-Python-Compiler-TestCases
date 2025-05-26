#!/bin/bash
# Ensure this file is saved with Unix line endings (LF only, not CRLF)
# Script for executing JUnit tests inside a Docker container

set -e

# Define workspace and timeout
WORKDIR="/tmp/test-execution"
TIMEOUT_SECONDS=30

# Function to clean up workspace
cleanup() {
    cd /
    rm -rf "$WORKDIR"
}

# Ensure cleanup on script exit
trap cleanup EXIT

# Create and navigate to workspace
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Validate required environment variables
for VAR in USER_CODE TEST_CODE TEST_CLASS_NAME; do
    if [ -z "${!VAR}" ]; then
        echo "ERROR: $VAR environment variable is not set" >&2
        exit 1
    fi
done

# Extract user class name
USER_CLASS_NAME=$(echo "$USER_CODE" | grep -o "public class [A-Za-z_][A-Za-z0-9_]*" | head -1 | awk '{print $3}')
if [ -z "$USER_CLASS_NAME" ]; then
    echo "ERROR: Could not extract class name from user code" >&2
    exit 1
fi
echo "Detected user class name: $USER_CLASS_NAME"

# Write code to respective files
echo "$USER_CODE" > "${USER_CLASS_NAME}.java"
echo "$TEST_CODE" > "${TEST_CLASS_NAME}.java"

# Set classpath
export CLASSPATH="/app/junit-4.13.2.jar:/app/hamcrest-core-1.3.jar:."

# Compile user code
echo "Compiling user code..."
timeout "$TIMEOUT_SECONDS" javac "${USER_CLASS_NAME}.java"
if [ $? -ne 0 ]; then
    echo "ERROR: User code compilation failed" >&2
    exit 1
fi
echo "User code compiled successfully"

# Compile test code
echo "Compiling test code..."
timeout "$TIMEOUT_SECONDS" javac -cp "$CLASSPATH" "${TEST_CLASS_NAME}.java"
if [ $? -ne 0 ]; then
    echo "ERROR: Test code compilation failed" >&2
    exit 1
fi
echo "Test code compiled successfully"

# Run tests
echo "Running tests..."
timeout "$TIMEOUT_SECONDS" java -cp "$CLASSPATH" org.junit.runner.JUnitCore "$TEST_CLASS_NAME" 2>&1
EXECUTION_STATUS=$?

# Handle test execution results
if [ $EXECUTION_STATUS -eq 124 ]; then
    echo "ERROR: Test execution timed out after $TIMEOUT_SECONDS seconds" >&2
    exit 1
elif [ $EXECUTION_STATUS -ne 0 ]; then
    echo "Tests completed with failures (exit code: $EXECUTION_STATUS)"
else
    echo "All tests passed successfully"
fi

exit 0
