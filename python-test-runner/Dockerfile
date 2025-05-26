# Use slim Python image for efficiency
FROM python:3-slim

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy test execution script
COPY run-tests.sh .

# Set entry point
ENTRYPOINT ["/bin/bash", "run-tests.sh"]
