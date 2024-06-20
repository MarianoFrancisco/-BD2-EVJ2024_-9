USE BD2;

-- PRIMERA FUNCION
-- Func_course_usuarios
CREATE FUNCTION proyecto1.F1 (@CodCourse INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        u.Id,
        u.Firstname,
        u.Lastname,
        u.Email,
        u.DateOfBirth,
        u.Password,
        u.LastChanges,
        u.EmailConfirmed
    FROM 
        proyecto1.Usuarios u
    INNER JOIN 
        proyecto1.CourseAssignment ca ON u.Id = ca.StudentId
    WHERE 
        ca.CourseCodCourse = @CodCourse
);

-- SEGUNDA FUNCION
-- Func_tutor_course
CREATE FUNCTION proyecto1.F2 (@TutorId UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        c.CodCourse,
        c.Name,
        c.CreditsRequired
    FROM 
        proyecto1.Course c
    INNER JOIN 
        proyecto1.CourseTutor ct ON c.CodCourse = ct.CourseCodCourse
    WHERE 
        ct.TutorId = @TutorId
);

-- TERCERA FUNCION
-- Func_notification_usuarios
CREATE FUNCTION proyecto1.F3 (@UserId UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        n.Id,
        n.Message,
        n.Date
    FROM 
        proyecto1.Notification n
    WHERE 
        n.UserId = @UserId
);

-- CUARTA FUNCION
-- Func_logger
CREATE FUNCTION proyecto1.F4 ()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        Id,
        Date,
        Description
    FROM 
        proyecto1.HistoryLog
);

-- QUINTA FUNCION
-- Func_usuarios
CREATE FUNCTION proyecto1.F5 (@UserId UNIQUEIDENTIFIER)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        u.Firstname,
        u.Lastname,
        u.Email,
        u.DateOfBirth,
        ps.Credits,
        r.RoleName
    FROM 
        proyecto1.Usuarios u
    INNER JOIN 
        proyecto1.ProfileStudent ps ON u.Id = ps.UserId
    INNER JOIN 
        proyecto1.UsuarioRole ur ON u.Id = ur.UserId
    INNER JOIN 
        proyecto1.Roles r ON ur.RoleId = r.Id
    WHERE 
        u.Id = @UserId AND ur.IsLatestVersion = 1
);
