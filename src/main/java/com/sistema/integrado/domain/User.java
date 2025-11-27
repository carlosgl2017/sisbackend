package com.sistema.integrado.domain;

import com.fasterxml.jackson.annotation.JsonInclude;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@SuperBuilder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_DEFAULT)
public class User {
    private Long id;
    @NotEmpty(message = "El nombre no puede estar vacio")
    private String firstName;
    @NotEmpty(message = "El apellido no puede estar vacio")
    private String lastName;
    @NotEmpty(message = "El correo no puede estar vacio")
    @Email(message = "El correo no es valido")
    private String email;
    @NotEmpty(message = "La contraseña no puede estar vacia")
    private String password;
    private String address;
    private String phone;
    private String title;
    private String bio;
    private String imageUrl;
    private boolean enabled;
    private boolean isNotLocked;
    private boolean isUsingMfa;
    private LocalDateTime createAt;
}
