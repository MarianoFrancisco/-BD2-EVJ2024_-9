USE BD2;

-- ===
-- PR6
-- ===

CREATE PROCEDURE proyecto1.PR6
    @EntityName NVARCHAR(50),
    @FirstName NVARCHAR(MAX) = NULL,
    @LastName NVARCHAR(MAX) = NULL,
    @Name NVARCHAR(MAX) = NULL,
    @CreditsRequired INT = NULL,
    @IsValid BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
	-- Validaciones de Usuario
    IF @EntityName = 'Usuarios'
    BEGIN
        IF ISNULL(@FirstName, '') NOT LIKE '%[^a-zA-Z ]%' AND ISNULL(@LastName, '') NOT LIKE '%[^a-zA-Z ]%'
            SET @IsValid = 1;
        ELSE
            SET @IsValid = 0;
    END
    -- Validacion de Curso
    ELSE IF @EntityName = 'Course'
    BEGIN
        IF ISNULL(@Name, '') NOT LIKE '%[^a-zA-Z1-9 ]%' AND @Name NOT LIKE '%[1-9]%[^1-9 ]'  AND ISNUMERIC(@CreditsRequired) = 1
            SET @IsValid = 1;
        ELSE
            SET @IsValid = 0;
    END
    ELSE
    BEGIN
        -- No valida
        SET @IsValid = 0;
    END;
END;

-- ===
-- PR1
-- ===

CREATE PROCEDURE proyecto1.PR1
    @Firstname VARCHAR(max),
    @Lastname VARCHAR(max), 
    @Email VARCHAR(max), 
    @DateOfBirth datetime2(7), 
    @Password VARCHAR(max), 
    @Credits INT
AS
BEGIN
    DECLARE @UserId UNIQUEIDENTIFIER;
    DECLARE @RolId UNIQUEIDENTIFIER;
    DECLARE @ErrorMessage NVARCHAR(250);
    DECLARE @ErrorSeverity INT;
    DECLARE @Description NVARCHAR(MAX);

    -- Validaciones de cada campo
    IF (@Firstname IS NULL OR @Firstname = '')
    BEGIN 
        SET @ErrorMessage = 'Error, El nombre no puede ir vacío';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    IF (@Lastname IS NULL OR @Lastname = '')
    BEGIN 
        SET @ErrorMessage = 'Error, El apellido no puede ir vacío';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    IF (@Email IS NULL OR @Email = '')
    BEGIN 
        SET @ErrorMessage = 'Error, El campo correo no puede ir vacío';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    IF (@DateOfBirth IS NULL)
    BEGIN
        SET @ErrorMessage = 'Error, La fecha de nacimiento no puede ir vacía';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    IF (@Password IS NULL OR @Password = '')
    BEGIN
        SET @ErrorMessage = 'Error, El password no puede estar vacío';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    IF (@Credits < 0)
    BEGIN
        SET @ErrorMessage = 'Error, No puede ingresar una cantidad de créditos negativa';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

		-- Validaci?n de datos utilizando el procedimiento PR6
        DECLARE @IsValid BIT;
        EXEC proyecto1.PR6 'Usuarios', @Firstname, @Lastname, NULL, NULL, @IsValid OUTPUT;
        IF(@IsValid = 0)
        BEGIN
            SET @ErrorMessage = 'Los campos son incorrectos, solo deben contener letras';
            SET @ErrorSeverity = 16;
            RAISERROR(@ErrorMessage,@ErrorSeverity,1);
            RETURN;
        END  

        -- Validar si el correo ya está asociado con otra cuenta
        IF EXISTS (SELECT * FROM proyecto1.Usuarios WHERE Email = @Email)
        BEGIN
            SET @ErrorMessage = 'Ya hay un usuario asociado con el correo indicado';
            SET @ErrorSeverity = 16;
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END

        -- Creación de rol estudiante
        SET @RolId = (SELECT Id FROM proyecto1.Roles WHERE RoleName = 'Student');
        IF @RolId IS NULL
        BEGIN
            SET @ErrorMessage = 'El rol del estudiante no existe';
            SET @ErrorSeverity = 16;
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END
        
        -- Insertar en la tabla Usuarios
        SET @UserId = NEWID();
        INSERT INTO proyecto1.Usuarios(Id, Firstname, Lastname, Email, DateOfBirth, Password, LastChanges, EmailConfirmed)
        VALUES (@UserId, @Firstname, @Lastname, @Email, @DateOfBirth, @Password, GETDATE(), 1);

        -- Insertar en la tabla UsuarioRole
        INSERT INTO proyecto1.UsuarioRole (RoleId, UserId, IsLatestVersion)
        VALUES (@RolId, @UserId, 1);

        -- Insertar en la tabla ProfileStudent
        INSERT INTO proyecto1.ProfileStudent (UserId, Credits)
        VALUES (@UserId, @Credits);

        -- Insertar en la tabla TFA
        INSERT INTO proyecto1.TFA (UserId, Status, LastUpdate)
        VALUES (@UserId, 1, GETDATE());

        -- Insertar en la tabla Notification
        INSERT INTO proyecto1.Notification (UserId, Message, Date)
        VALUES (@UserId, 'Se ha registrado satisfactoriamente', GETDATE());

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El estudiante ha sido registrado satisfactoriamente';
    END TRY
    BEGIN CATCH
        -- Error - cancelar transacción 
        ROLLBACK;
        SELECT @ErrorMessage = ERROR_MESSAGE();
        SET @Description = 'Registro de Estudiante Fallido.';
        BEGIN TRY
            INSERT INTO proyecto1.HistoryLog (Date, Description)
            VALUES (GETDATE(), @Description);
        END TRY
        BEGIN CATCH
            PRINT 'Error al insertar en HistoryLog: ' + ERROR_MESSAGE();
        END CATCH;
        RAISERROR(@ErrorMessage, 16, 1);
        PRINT 'El registro del estudiante no fue satisfactorio';
    END CATCH;
END;


-- ===
-- PR2
-- ===

CREATE PROCEDURE proyecto1.PR2
    @Email NVARCHAR(MAX),
    @CodCourse INT
AS
BEGIN
    DECLARE @UserId UNIQUEIDENTIFIER;
    DECLARE @RolId UNIQUEIDENTIFIER;
    DECLARE @ErrorMessage NVARCHAR(250);
    DECLARE @ErrorSeverity INT;
    DECLARE @Description NVARCHAR(MAX);

    -- Validaciones de los parámetros de entrada
    IF (@Email IS NULL OR @Email = '')
    BEGIN
        SET @ErrorMessage = 'Error, El campo correo no puede ir vacío';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    IF (@CodCourse IS NULL OR @CodCourse <= 0)
    BEGIN
        SET @ErrorMessage = 'Error, El código del curso debe ser un número positivo';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

        -- Obtener UserId basado en el Email proporcionado
        SELECT @UserId = Id FROM proyecto1.Usuarios WHERE Email = @Email;

        IF @UserId IS NULL
        BEGIN
            SET @ErrorMessage = 'No se encontró un usuario con el correo especificado.';
            SET @ErrorSeverity = 16;
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END

        -- Asignar el rol de Tutor al estudiante
        SET @RolId = (SELECT Id FROM proyecto1.Roles WHERE RoleName = 'Tutor');
        IF @RolId IS NULL
        BEGIN
            SET @ErrorMessage = 'El rol de Tutor no existe.';
            SET @ErrorSeverity = 16;
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END

        -- Insertar en la tabla UsuarioRole si el usuario no tiene el rol de Tutor
        IF NOT EXISTS (SELECT 1 FROM proyecto1.UsuarioRole WHERE UserId = @UserId AND RoleId = @RolId)
        BEGIN
            INSERT INTO proyecto1.UsuarioRole (RoleId, UserId, IsLatestVersion)
            VALUES (@RolId, @UserId, 1);
        END

        -- Insertar en la tabla TutorProfile si no existe
        IF NOT EXISTS (SELECT 1 FROM proyecto1.TutorProfile WHERE UserId = @UserId)
        BEGIN
            INSERT INTO proyecto1.TutorProfile (UserId, TutorCode)
            VALUES (@UserId, 'TUTOR' + CAST(@UserId AS NVARCHAR(50)));
        END

        -- Asignar al usuario como tutor al curso especificado en CourseTutor
        IF NOT EXISTS (SELECT 1 FROM proyecto1.CourseTutor WHERE TutorId = @UserId AND CourseCodCourse = @CodCourse)
        BEGIN
            INSERT INTO proyecto1.CourseTutor (TutorId, CourseCodCourse)
            VALUES (@UserId, @CodCourse);
        END

        -- Insertar una notificación para informar al usuario sobre su nuevo rol
        INSERT INTO proyecto1.Notification (UserId, Message, Date)
        VALUES (@UserId, '¡Felicidades! Ha sido promovido al rol de Tutor para el curso con código ' + CAST(@CodCourse AS NVARCHAR(10)), GETDATE());

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El estudiante ha sido promovido satisfactoriamente al rol de Tutor';
    END TRY
    BEGIN CATCH
        -- Error - cancelar la transacción en caso de error
        ROLLBACK;
        SELECT @ErrorMessage = ERROR_MESSAGE();
        SET @Description = 'Cambio de Rol Fallido.';
        BEGIN TRY
            INSERT INTO proyecto1.HistoryLog ([Date], Description) VALUES (GETDATE(), @Description);
        END TRY
        BEGIN CATCH
            PRINT 'Error al insertar en HistoryLog: ' + ERROR_MESSAGE();
        END CATCH;
        RAISERROR(@ErrorMessage, 16, 1);
        PRINT 'La promoción al rol de Tutor no fue satisfactoria';
    END CATCH;
END;


-- ===
-- PR3
-- ===

CREATE PROCEDURE proyecto1.PR3
    @Email NVARCHAR(MAX),
    @CodCourse INT
AS
BEGIN
    DECLARE @UserId UNIQUEIDENTIFIER;
    DECLARE @CourseName NVARCHAR(MAX);
    DECLARE @MaxStudents INT;
    DECLARE @CurrentStudents INT;
    DECLARE @ErrorMessage NVARCHAR(250);
    DECLARE @ErrorSeverity INT;
    DECLARE @TutorId UNIQUEIDENTIFIER;
    DECLARE @Description NVARCHAR(MAX);

    -- Validaciones de los parámetros de entrada
    IF (@Email IS NULL OR @Email = '')
    BEGIN
        SET @ErrorMessage = 'Error, El campo correo no puede ir vacío';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    IF (@CodCourse IS NULL OR @CodCourse <= 0)
    BEGIN
        SET @ErrorMessage = 'Error, El código del curso debe ser un número positivo';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

        -- Obtener UserId basado en el Email proporcionado
        SELECT @UserId = Id FROM proyecto1.Usuarios WHERE Email = @Email;

        IF @UserId IS NULL
        BEGIN
            SET @ErrorMessage = 'No se encontró un usuario con el correo especificado.';
            SET @ErrorSeverity = 16;
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END

        -- Obtener el nombre y el cupo máximo de estudiantes del curso
        SELECT @CourseName = Name, @MaxStudents = CreditsRequired FROM proyecto1.Course WHERE CodCourse = @CodCourse;

        IF @CourseName IS NULL OR @MaxStudents IS NULL
        BEGIN
            SET @ErrorMessage = 'No se encontró un curso con el código especificado.';
            SET @ErrorSeverity = 16;
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END

        -- Contar la cantidad actual de estudiantes asignados al curso
        SELECT @CurrentStudents = COUNT(*) FROM proyecto1.CourseAssignment WHERE CourseCodCourse = @CodCourse;

        IF @CurrentStudents >= @MaxStudents
        BEGIN
            SET @ErrorMessage = 'El curso ya ha alcanzado su límite máximo de estudiantes.';
            SET @ErrorSeverity = 16;
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END

        -- Insertar la asignación del curso para el estudiante
        INSERT INTO proyecto1.CourseAssignment (StudentId, CourseCodCourse)
        VALUES (@UserId, @CodCourse);

        -- Insertar notificación para el estudiante
        INSERT INTO proyecto1.Notification (UserId, Message, Date)
        VALUES (@UserId, '¡Felicidades! Ha sido asignado al curso ' + @CourseName, GETDATE());

        -- Buscar al tutor del curso y notificarle
        SELECT @TutorId = TP.UserId
        FROM proyecto1.TutorProfile TP
        INNER JOIN proyecto1.CourseTutor CT ON TP.UserId = CT.TutorId
        WHERE CT.CourseCodCourse = @CodCourse;

        IF @TutorId IS NOT NULL
        BEGIN
            INSERT INTO proyecto1.Notification (UserId, Message, Date)
            VALUES (@TutorId, 'Uno de sus estudiantes ha sido asignado al curso ' + @CourseName, GETDATE());
        END

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'Asignación al curso realizada satisfactoriamente';
    END TRY
    BEGIN CATCH
        -- Error - cancelar la transacción en caso de error
        ROLLBACK;
        SELECT @ErrorMessage = ERROR_MESSAGE();
        SET @Description = 'Asignación de Curso Fallida.';
        
        -- Registro del error en la tabla HistoryLog
        INSERT INTO proyecto1.HistoryLog ([Date], Description) VALUES (GETDATE(), @Description + ' ' + @ErrorMessage);
        
        RAISERROR(@ErrorMessage, 16, 1);
        PRINT 'La asignación al curso no fue satisfactoria';
    END CATCH;
END;

-- ===
-- PR4
-- ===

CREATE PROCEDURE proyecto1.PR4
    @RoleName NVARCHAR(MAX)
AS
BEGIN
    DECLARE @RoleId UNIQUEIDENTIFIER;
	Declare @Description nvarchar(max);
    DECLARE @ErrorMessage NVARCHAR(250);
    DECLARE @ErrorSeverity INT;

    -- Validación del parámetro de entrada
    IF (@RoleName IS NULL OR @RoleName = '')
    BEGIN
        SET @ErrorMessage = 'Error, el nombre del rol no puede estar vacío';
        SET @ErrorSeverity = 16;
        RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
        RETURN;
    END

    BEGIN TRY
        -- Inicio de la transacción
        BEGIN TRANSACTION;

        -- Validar si el rol ya existe
        IF EXISTS (SELECT 1 FROM proyecto1.Roles WHERE RoleName = @RoleName)
        BEGIN
            SET @ErrorMessage = 'El rol especificado ya existe';
            SET @ErrorSeverity = 16;
            RAISERROR(@ErrorMessage, @ErrorSeverity, 1);
            RETURN;
        END

        -- Insertar el nuevo rol
        SET @RoleId = NEWID();
        INSERT INTO proyecto1.Roles (Id, RoleName)
        VALUES (@RoleId, @RoleName);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        PRINT 'El rol ha sido creado satisfactoriamente';
    END TRY
    BEGIN CATCH
        -- Error - cancelar la transacción en caso de error
        SELECT @ErrorMessage = ERROR_MESSAGE();
        SET @Description = 'Inserción de Rol Fallida.';
        INSERT INTO proyecto1.HistoryLog ([Date], Description) VALUES (GETDATE(), @Description);
        SELECT @Description AS 'Error';
		ROLLBACK TRANSACTION;
    END CATCH;
END;

-- ===
-- PR5
-- ===

CREATE PROCEDURE proyecto1.PR5 
    @CodCourse INT,
    @Name NVARCHAR(MAX),
    @CreditsRequired INT
AS 
BEGIN
    DECLARE @Description NVARCHAR(MAX);
    DECLARE @IsValid BIT;
    DECLARE @ErrorMessage NVARCHAR(MAX);

    -- Iniciar la transacción
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Validar los datos utilizando el procedimiento PR6
        EXEC proyecto1.PR6 'Course', NULL, NULL, @Name, @CreditsRequired, @IsValid OUTPUT;
        
        IF @IsValid = 0
        BEGIN
            SET @Description = 'Inserción de Curso Fallida: Nombre o Créditos Incorrectos';
            INSERT INTO proyecto1.HistoryLog ([Date], Description)
            VALUES (GETDATE(), @Description);
            SELECT @Description AS 'Error';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @CreditsRequired < 0
        BEGIN
            SET @Description = 'Inserción de Curso Fallida: Créditos no pueden ser negativos';
            INSERT INTO proyecto1.HistoryLog ([Date], Description)
            VALUES (GETDATE(), @Description);
            SELECT @Description AS 'Error';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @CodCourse < 0
        BEGIN
            SET @Description = 'Inserción de Curso Fallida: Código de Curso no puede ser negativo';
            INSERT INTO proyecto1.HistoryLog ([Date], Description)
            VALUES (GETDATE(), @Description);
            SELECT @Description AS 'Error';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Insertar el curso en la tabla Course
        INSERT INTO proyecto1.Course (CodCourse, Name, CreditsRequired)
        VALUES (@CodCourse, @Name, @CreditsRequired);

        -- Confirmar la transacción
        COMMIT TRANSACTION;
        SELECT 'Inserción de Curso exitosa' AS Mensaje;
    END TRY
    BEGIN CATCH
        -- Manejo de error - cancelar la transacción en caso de error
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        
        SET @ErrorMessage = ERROR_MESSAGE();
        SET @Description = 'Inserción de Curso Fallida: ' + @ErrorMessage;
        INSERT INTO proyecto1.HistoryLog ([Date], Description)
        VALUES (GETDATE(), @Description);
        SELECT @Description AS 'Error';
    END CATCH;
END;