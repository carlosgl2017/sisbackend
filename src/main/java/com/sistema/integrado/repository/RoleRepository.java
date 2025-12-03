package com.sistema.integrado.repository;

import com.sistema.integrado.domain.Role;
import com.sistema.integrado.domain.User;

import java.util.Collection;

public interface RoleRepository <T extends Role> {
    /*Basic CRUD Operations*/
    T create(T data);
    Collection<T> list (int page, int pageSize);
    T get(Long id);
    T update(T data);
    Boolean delete(Long id);
    /*more complex operations*/
    void addRoleToUser(Long userId, String roleName);
}
