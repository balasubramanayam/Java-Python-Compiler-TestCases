#!/bin/bash
set -e

WORKDIR="/tmp/test-execution"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

TIMEOUT_SECONDS=30

cleanup() {
    cd /
    rm -rf "$WORKDIR"
}
trap cleanup EXIT

# Validate environment variables
if [ -z "$USER_CODE" ]; then
    echo "ERROR: USER_CODE environment variable is not set" >&2
    exit 1
fi
if [ -z "$TEST_CODE" ]; then
    echo "ERROR: TEST_CODE environment variable is not set" >&2
    exit 1
fi
if [ -z "$TEST_FILE_NAME" ]; then
    echo "ERROR: TEST_FILE_NAME environment variable is not set" >&2
    exit 1
fi

# Create user code and test files
printf "%b" "$USER_CODE" > user_code.py
printf "%b" "$TEST_CODE" > "$TEST_FILE_NAME"

# Check if pytest is installed
if ! command -v pytest &> /dev/null; then
    echo "ERROR: pytest is not installed. Please install it inside the container."
    exit 1
fi

echo "Running tests..."
timeout "$TIMEOUT_SECONDS" pytest "$TEST_FILE_NAME" --disable-warnings
EXECUTION_STATUS=$?

# Handle different test outcomes
if [ $EXECUTION_STATUS -eq 124 ]; then
    echo "ERROR: Test execution timed out after $TIMEOUT_SECONDS seconds" >&2
    exit 1
elif [ $EXECUTION_STATUS -ne 0 ]; then
    echo "Tests completed with failures (exit code: $EXECUTION_STATUS)"
else
    echo "All tests passed successfully"
fi

exit 0