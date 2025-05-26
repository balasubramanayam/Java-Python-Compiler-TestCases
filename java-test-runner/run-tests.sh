#!/bin/bash
# Make sure this file is saved with Unix line endings (LF only, not CRLF)
# Script for executing JUnit tests inside a Docker container
set -e
 
WORKDIR="/tmp/test-execution"
mkdir -p "$WORKDIR"
cd "$WORKDIR"
 
TIMEOUT_SECONDS=30
 
# Function to cleanup
cleanup() {
    cd /
    rm -rf "$WORKDIR"
}
 
# Trap to ensure cleanup happens
trap cleanup EXIT
 
# Check if required environment variables are set
if [ -z "$USER_CODE" ]; then
    echo "ERROR: USER_CODE environment variable is not set" >&2
    exit 1
fi
 
if [ -z "$TEST_CODE" ]; then
    echo "ERROR: TEST_CODE environment variable is not set" >&2
    exit 1
fi
 
if [ -z "$TEST_CLASS_NAME" ]; then
    echo "ERROR: TEST_CLASS_NAME environment variable is not set" >&2
    exit 1
fi
 
# Extract class name from user code
USER_CLASS_NAME=$(echo "$USER_CODE" | grep -o "public class [A-Za-z_][A-Za-z0-9_]*" | head -1 | awk '{print $3}')
 
if [ -z "$USER_CLASS_NAME" ]; then
    echo "ERROR: Could not extract class name from user code" >&2
    exit 1
fi
 
echo "Detected user class name: $USER_CLASS_NAME"
 
# Write user code to file
echo "$USER_CODE" > "${USER_CLASS_NAME}.java"
 
# Write test code to file
echo "$TEST_CODE" > "${TEST_CLASS_NAME}.java"
 
# Set classpath
export CLASSPATH="/app/junit-4.13.2.jar:/app/hamcrest-core-1.3.jar:."
 
echo "Compiling user code..."
timeout "$TIMEOUT_SECONDS" javac "${USER_CLASS_NAME}.java"
USER_COMPILE_STATUS=$?
 
if [ $USER_COMPILE_STATUS -ne 0 ]; then
    echo "ERROR: User code compilation failed" >&2
    exit 1
fi
 
echo "User code compiled successfully"
 
echo "Compiling test code..."
timeout "$TIMEOUT_SECONDS" javac -cp "$CLASSPATH" "${TEST_CLASS_NAME}.java"
TEST_COMPILE_STATUS=$?
 
if [ $TEST_COMPILE_STATUS -ne 0 ]; then
    echo "ERROR: Test code compilation failed" >&2
    exit 1
fi
 
echo "Test code compiled successfully"
 
echo "Running tests..."
timeout "$TIMEOUT_SECONDS" java -cp "$CLASSPATH" org.junit.runner.JUnitCore "$TEST_CLASS_NAME" 2>&1
EXECUTION_STATUS=$?
 
if [ $EXECUTION_STATUS -eq 124 ]; then
    echo "ERROR: Test execution timed out after $TIMEOUT_SECONDS seconds" >&2
    exit 1
elif [ $EXECUTION_STATUS -ne 0 ]; then
    echo "Tests completed with failures (exit code: $EXECUTION_STATUS)"
else
    echo "All tests passed successfully"
fi
 
exit 0