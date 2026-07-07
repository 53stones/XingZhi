package org.wl.outdoor.controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
@RestController
public class TestController {
    @GetMapping("/test")
    public String test() {
        return "outdoor help system started";
    }
}
