CREATE DATABASE practica1_g9;

USE practica1_g9;

CREATE TABLE habitacion (
    idHabitacion INT AUTO_INCREMENT PRIMARY KEY,
    habitacion VARCHAR(100)
);

CREATE TABLE log_habitacion (
    timestamp VARCHAR(100),
    status VARCHAR(45),
    idHabitacion INT,
    FOREIGN KEY (idHabitacion) REFERENCES habitacion(idHabitacion)
);

CREATE TABLE log_actividad (
    id_log_actividad INT AUTO_INCREMENT PRIMARY KEY,
    timestamp VARCHAR(100),
    actividad VARCHAR(500),
    idPaciente INT,
    idHabitacion INT,
    FOREIGN KEY (idPaciente) REFERENCES paciente(idPaciente),
    FOREIGN KEY (idHabitacion) REFERENCES habitacion(idHabitacion)
);

CREATE TABLE paciente (
    idPaciente INT AUTO_INCREMENT PRIMARY KEY,
    edad INT,
    genero VARCHAR(20)
);