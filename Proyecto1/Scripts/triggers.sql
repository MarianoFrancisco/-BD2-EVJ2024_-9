USE BD2;

-- ============
-- Tabla Course
-- ============

CREATE TRIGGER proyecto1.Trigger1
ON proyecto1.Course
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;

-- ==============
-- Tabla Usuarios
-- ==============

CREATE TRIGGER proyecto1.Trigger2
ON proyecto1.Usuarios
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    -- Tu l?gica aqu?...
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;

-- ===========
-- Tabla Roles
-- ===========

CREATE TRIGGER proyecto1.Trigger3
ON proyecto1.Roles
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    -- Tu l?gica aqu?...
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;

-- ======================
-- Tabla CourseAssignment
-- ======================

CREATE TRIGGER proyecto1.Trigger4
ON proyecto1.CourseAssignment
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    -- Tu l?gica aqu?...
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;

-- =================
-- Tabla CourseTutor
-- =================

CREATE TRIGGER proyecto1.Trigger5
ON proyecto1.CourseTutor
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    -- Tu l?gica aqu?...
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;

-- ==================
-- Tabla Notification
-- ==================

CREATE TRIGGER proyecto1.Trigger6
ON proyecto1.Notification
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    -- Tu l?gica aqu?...
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;

-- ====================
-- Tabla ProfileStudent
-- ====================

CREATE TRIGGER proyecto1.Trigger7
ON proyecto1.ProfileStudent
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    -- Tu l?gica aqu?...
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;

-- =========
-- Tabla TFA
-- =========

CREATE TRIGGER proyecto1.Trigger8
ON proyecto1.TFA
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    -- Tu l?gica aqu?...
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;

-- ===================
-- Tabla TutorProfile
-- ===================

CREATE TRIGGER proyecto1.Trigger9
ON proyecto1.TutorProfile
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    -- Tu l?gica aqu?...
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;

-- =================
-- Tabla UsuarioRole
-- =================

CREATE TRIGGER proyecto1.Trigger10
ON proyecto1.UsuarioRole
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Operacion VARCHAR(20);
    DECLARE @Resultado VARCHAR(20);
    DECLARE @Descripcion VARCHAR(100);

    -- Determinar el tipo de operaci?n
   IF EXISTS (SELECT * FROM inserted)
        SET @Operacion = 'INSERT';
    ELSE IF EXISTS (SELECT * FROM deleted)
        SET @Operacion = 'DELETE';
    ELSE
        SET @Operacion = 'UPDATE';
    -- L?gica para manejar las operaciones en las tablas
    -- Tu l?gica aqu?...
    SET @Descripcion = 'Operacion ' + @Operacion + ' Exitosa';

    -- Insertar el registro en la tabla HistoryLog
    INSERT INTO proyecto1.HistoryLog ([Date], Description)
    VALUES (GETDATE(), @Descripcion);
END;