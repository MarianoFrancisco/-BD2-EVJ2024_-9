-- PROCEDIMIENTO 2 DATOS DE EJEMPLO
-- Datos de ejemplo para la tabla Usuarios
INSERT INTO proyecto1.Usuarios (Id, Firstname, Lastname, Email, DateOfBirth, Password, LastChanges, EmailConfirmed)
VALUES 
('12345678-90AB-CDEF-1234-567890ABCDEF', 'John', 'Doe', 'john.doe@example.com', '1980-01-01', 'password', GETDATE(), 1),
('87654321-0FED-CBA9-8765-43210FEDCBA9', 'Jane', 'Smith', 'jane.smith@example.com', '1990-05-15', 'password', GETDATE(), 1);

-- Datos de ejemplo para la tabla Course
INSERT INTO proyecto1.Course (CodCourse, Name, CreditsRequired)
VALUES (1, 'Mathematics', 3), (2, 'Science', 4);

-- Datos de ejemplo para la tabla Roles
INSERT INTO proyecto1.Roles (Id, RoleName)
VALUES 
('A1B2C3D4-E5F6-7890-1234-56789ABCDE01', 'Student'), 
('B2C3D4E5-F6A7-8901-2345-6789ABCDEF02', 'Tutor');

-- Datos de ejemplo para la tabla UsuarioRole
INSERT INTO proyecto1.UsuarioRole (RoleId, UserId, IsLatestVersion)
VALUES 
('A1B2C3D4-E5F6-7890-1234-56789ABCDE01', '12345678-90AB-CDEF-1234-567890ABCDEF', 1);

-- Datos de ejemplo para la tabla Notification
INSERT INTO proyecto1.Notification (UserId, Message, Date)
VALUES 
('12345678-90AB-CDEF-1234-567890ABCDEF', 'Notification 1', GETDATE()), 
('87654321-0FED-CBA9-8765-43210FEDCBA9', 'Notification 2', GETDATE());

-- Datos de ejemplo para la tabla ProfileStudent
INSERT INTO proyecto1.ProfileStudent (UserId, Credits)
VALUES 
('12345678-90AB-CDEF-1234-567890ABCDEF', 30), 
('87654321-0FED-CBA9-8765-43210FEDCBA9', 40);

-- Datos de ejemplo para la tabla CourseTutor
INSERT INTO proyecto1.CourseTutor (TutorId, CourseCodCourse)
VALUES 
('87654321-0FED-CBA9-8765-43210FEDCBA9', 1);

-- Datos de ejemplo para la tabla HistoryLog
INSERT INTO proyecto1.HistoryLog (Date, Description)
VALUES 
(GETDATE(), 'Log entry 1'), 
(GETDATE(), 'Log entry 2');


-- LLAMANDO AL PROCEDIMIENTO
-- Supongamos que el usuario con Email 'john.doe@example.com' y el curso con CodCourse = 1 existen
EXEC proyecto1.PR2 @Email = 'john.doe@example.com', @CodCourse = 1;

-- Supongamos que no existe un usuario con el correo 'nonexistent@example.com'
EXEC proyecto1.PR2 @Email = 'nonexistent@example.com', @CodCourse = 1;

-- Supongamos que el usuario con Email 'john.doe@example.com' existe, pero el curso con CodCourse = 999 no existe
EXEC proyecto1.PR2 @Email = 'john.doe@example.com', @CodCourse = 999;

-- El campo correo no puede estar vacío
EXEC proyecto1.PR2 @Email = '', @CodCourse = 1;

-- El código del curso debe ser un número positivo
EXEC proyecto1.PR2 @Email = 'john.doe@example.com', @CodCourse = -1;

