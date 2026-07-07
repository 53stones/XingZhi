package org.wl.outdoor.service;

import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.entity.EmergencyContact;

import java.util.List;

public interface EmergencyContactService {
    List<EmergencyContact> selectList(Long id);
}
