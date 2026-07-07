package org.wl.outdoor.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.entity.EmergencyContact;
import org.wl.outdoor.service.EmergencyContactService;

import java.util.List;

@RestController
@RequestMapping("/users")
public class EmergencyContactController {
    @Autowired
    EmergencyContactService emergencyContactService;
    @GetMapping("/{id}/contact")
    public Result<List<EmergencyContact>> listContact(@PathVariable Long id) {
        return Result.success(emergencyContactService.selectList(id));
    }
}
