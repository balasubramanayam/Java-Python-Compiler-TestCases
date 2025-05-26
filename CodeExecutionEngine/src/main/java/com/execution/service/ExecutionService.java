package com.execution.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import org.springframework.stereotype.Service;



@Service
public class ExecutionService {
    public String runJavaCode(String code, String testCases, String testClassName) {
        try {
            String formattedCode = code.replace("\"", "\\\"");
            String formattedTestCases = testCases.replace("\"", "\\\"");
            String[] command = {
                "docker", "run", "--rm",
                "-e", "USER_CODE=" + formattedCode,
                "-e", "TEST_CODE=" + formattedTestCases,
                "-e", "TEST_CLASS_NAME=" + testClassName,
                "java-test-runner"
            };

            ProcessBuilder processBuilder = new ProcessBuilder(command);
            processBuilder.redirectErrorStream(true);

            Process process = processBuilder.start();
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder output = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }
            process.waitFor();

            String result = output.toString().trim();
            if (result.isEmpty()) {
                return "Error: No output received from Docker execution.";
            } else if (result.contains("Error response from daemon")) {
                return "Docker error: " + result;
            }
            return result;

        } catch (Exception e) {
            System.err.println("Error executing code: " + e.getMessage());
            return "Error executing code: " + e.getMessage();
        }
    }

    public String runPythonCode(String code, String testCases, String testFileName) {
        try {
            // Properly escape double quotes for each argument
            String formattedCode = code.replace("\"", "\\\"");
            String formattedTestCases = testCases.replace("\"", "\\\"");
            String formattedTestFileName = testFileName.replace("\"", "\\\"");

            String[] command = {
                "docker", "run", "--rm",
                "-e", "USER_CODE=" + formattedCode,
                "-e", "TEST_CODE=" + formattedTestCases,
                "-e", "TEST_FILE_NAME=" + formattedTestFileName,
                "python-test-runner"
            };

            ProcessBuilder processBuilder = new ProcessBuilder(command);
            processBuilder.redirectErrorStream(true);

            Process process = processBuilder.start();

            // Read process output
            BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder output = new StringBuilder();
            String line;

            while ((line = reader.readLine()) != null) {
                output.append(line).append("\n");
            }

            process.waitFor();

            String result = output.toString().trim();
            if (result.isEmpty()) {
                return "Error: No output received from Docker execution.";
            } else if (result.contains("Error response from daemon")) {
                return "Docker error: " + result;
            }
            return result;

        } catch (Exception e) {
            System.err.println("Error executing code: " + e.getMessage()); 
            return "Error executing code: " + e.getMessage();
        }
    }
	
	
}



