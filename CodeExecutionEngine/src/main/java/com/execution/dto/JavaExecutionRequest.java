package com.execution.dto;

public class JavaExecutionRequest {
    private String code;
    private String testCases;
    private String testClassName; // Optional, if needed

    // Getters and setters
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getTestCases() { return testCases; }
    public void setTestCases(String testCases) { this.testCases = testCases; }

    public String getTestClassName() { return testClassName; }
    public void setTestClassName(String testClassName) { this.testClassName = testClassName; }
}