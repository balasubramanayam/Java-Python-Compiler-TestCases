package com.execution.controller;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.execution.dto.JavaExecutionRequest;
import com.execution.dto.PythonExecutionRequest;
import com.execution.service.ExecutionService;

@RestController
@RequestMapping("/execute")  
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001"})
public class ExecutionController {

    @Autowired
    private ExecutionService executionService;

    @PostMapping("/java") 
    public String executeJava(@RequestBody JavaExecutionRequest request) {
        return executionService.runJavaCode(
            request.getCode(),
            request.getTestCases(),
            request.getTestClassName() 
        );
    }
   
    
    @PostMapping("/python")
    public String executePython(@RequestBody PythonExecutionRequest request) {
        return executionService.runPythonCode(
            request.getCode(),
            request.getTestCases(),
            request.getTestClassName()
        );
    }
}






