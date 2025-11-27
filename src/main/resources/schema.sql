####################################################################
###                                                             ####
### Author: Junior RT                                           ####
### License: Get Arrays LLC License (https://getarrays.io)      ####
### Date: August 20th, 2022                                     ####
### Version: 1.0                                                ####
###                                                             ####
####################################################################

/*
 * --- General Rules ---
 * Use underscore_names instead of camelCase
 * Table names should be plural
 * Spell out id fields (item_id instead of id)
 * Don't use ambiguous column names
 * Name foreign key columns the same as the columns they refer to
 * Use caps for all SQL queries
 */

CREATE SCHEMA IF NOT EXISTS securecapita;

SET TIME ZONE 'US/Eastern';

DROP TABLE IF EXISTS Users CASCADE;

CREATE TABLE Users
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    email      VARCHAR(100) NOT NULL,
    password   VARCHAR(255) DEFAULT NULL,
    address    VARCHAR(255) DEFAULT NULL,
    phone      VARCHAR(30) DEFAULT NULL,
    title      VARCHAR(50) DEFAULT NULL,
    bio        VARCHAR(255) DEFAULT NULL,
    enabled    BOOLEAN DEFAULT FALSE,
    non_locked BOOLEAN DEFAULT TRUE,
    using_mfa  BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    image_url  VARCHAR(255) DEFAULT 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
    CONSTRAINT UQ_Users_Email UNIQUE (email)
);

DROP TABLE IF EXISTS Roles CASCADE;

CREATE TABLE Roles
(
    id         BIGSERIAL PRIMARY KEY,
    name       VARCHAR(50) NOT NULL,
    permission VARCHAR(255) NOT NULL,
    CONSTRAINT UQ_Roles_Name UNIQUE (name)
);

DROP TABLE IF EXISTS UserRoles CASCADE;

CREATE TABLE UserRoles
(
    id      BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (role_id) REFERENCES Roles (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT UQ_UserRoles_User_Id UNIQUE (user_id)
);

DROP TABLE IF EXISTS Events CASCADE;

CREATE TABLE Events
(
    id          BIGSERIAL PRIMARY KEY,
    type        VARCHAR(50) NOT NULL CHECK(type IN ('LOGIN_ATTEMPT', 'LOGIN_ATTEMPT_FAILURE', 'LOGIN_ATTEMPT_SUCCESS', 'PROFILE_UPDATE', 'PROFILE_PICTURE_UPDATE', 'ROLE_UPDATE', 'ACCOUNT_SETTINGS_UPDATE', 'PASSWORD_UPDATE', 'MFA_UPDATE')),
    description VARCHAR(255) NOT NULL,
    CONSTRAINT UQ_Events_Type UNIQUE (type)
);

DROP TABLE IF EXISTS UserEvents CASCADE;

CREATE TABLE UserEvents
(
    id         BIGSERIAL PRIMARY KEY,
    user_id    BIGINT NOT NULL,
    event_id   BIGINT NOT NULL,
    device     VARCHAR(100) DEFAULT NULL,
    ip_address VARCHAR(100) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (event_id) REFERENCES Events (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS AccountVerifications CASCADE;

CREATE TABLE AccountVerifications
(
    id      BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    url     VARCHAR(255) NOT NULL,
    -- date     TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_AccountVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_AccountVerifications_Url UNIQUE (url)
);

DROP TABLE IF EXISTS ResetPasswordVerifications CASCADE;

CREATE TABLE ResetPasswordVerifications
(
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL,
    url             VARCHAR(255) NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_ResetPasswordVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_ResetPasswordVerifications_Url UNIQUE (url)
);

DROP TABLE IF EXISTS TwoFactorVerifications CASCADE;

CREATE TABLE TwoFactorVerifications
(
    id              BIGSERIAL PRIMARY KEY,
    user_id         BIGINT NOT NULL,
    code            VARCHAR(10) NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT UQ_TwoFactorVerifications_User_Id UNIQUE (user_id),
    CONSTRAINT UQ_TwoFactorVerifications_Code UNIQUE (code)
);