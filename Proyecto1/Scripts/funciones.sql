-- PRIMERA FUNCION
CREATE FUNCTION proyecto1.Func_course_usuarios (@CodCourse INT)
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
CREATE FUNCTION proyecto1.Func_tutor_course (@TutorId UNIQUEIDENTIFIER)
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
CREATE FUNCTION proyecto1.Func_notification_usuarios (@UserId UNIQUEIDENTIFIER)
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
CREATE FUNCTION proyecto1.Func_logger ()
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
CREATE FUNCTION proyecto1.Func_usuarios (@UserId UNIQUEIDENTIFIER)
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
        proyecto1.Roles r ON u.Id = r.Id
    WHERE 
        u.Id = @UserId
);
