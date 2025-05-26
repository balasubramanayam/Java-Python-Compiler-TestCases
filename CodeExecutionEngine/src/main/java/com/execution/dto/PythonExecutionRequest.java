package com.execution.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PythonExecutionRequest {
    private String code;
    private String testCases;
    private String testClassName;

    
}