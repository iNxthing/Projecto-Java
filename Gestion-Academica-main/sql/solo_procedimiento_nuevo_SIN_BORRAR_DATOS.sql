USE gestion_academica;
DELIMITER //

DROP PROCEDURE IF EXISTS sp_combo_asignaturas_profesor //
CREATE PROCEDURE sp_combo_asignaturas_profesor(IN p_id_profesor INT)
BEGIN
    SELECT 
        a.id_asignatura AS idAsignatura, 
        CONCAT(a.nombre, ' (', g.nombre, ')') AS nombreAsignatura
    FROM usuario u
    INNER JOIN asignatura a ON u.idAsignatura = a.id_asignatura
    INNER JOIN grado g ON a.id_grado = g.id_grado
    WHERE u.idUsuario = p_id_profesor;
END //

DELIMITER ;
