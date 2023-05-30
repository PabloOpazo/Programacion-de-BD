CREATE OR REPLACE FUNCTION fn_monto_total_atencion(p_rut NUMBER, p_periodo VARCHAR2)
RETURN NUMBER
IS
    monto_total NUMBER;
BEGIN
    --calcular monto total de las atenciones del medico en el periodo
    SELECT
        NVL(SUM(costo),0)
    INTO monto_total
    FROM atencion
    WHERE med_run = p_rut AND TO_CHAR(fecha_atencion, 'MM-YYYY') = p_periodo;
    
    RETURN monto_total;
END;

--vamo a proarlo (la función 😏)
SET SERVEROUTPUT ON;

DECLARE
    D NUMBER;
BEGIN
    D := fn_monto_total_atencion(6117105, '01-2021');
    DBMS_OUTPUT.PUT_LINE(D);
END;

CREATE OR REPLACE PACKAGE pkg_medicos IS
    periodo VARCHAR2(7);
    limite_antiguedad NUMBER;
    --FUNCION Y PROCEDIMIENTO PUBLICO
    FUNCTION fn_cantidad_atenciones(p_rut NUMBER) RETURN NUMBER;
    PROCEDURE sp_informe;
    
END;
    
--CUERPO DEL PAQUETE
CREATE OR REPLACE PACKAGE BODY pkg_medicos IS
    FUNCTION fn_cantidad_atenciones(p_rut NUMBER) RETURN NUMBER
    IS
        cantidad_atenciones NUMBER;
    BEGIN
        SELECT
            COUNT(ate_id)
        INTO cantidad_atenciones
        FROM atencion
        WHERE p_rut = med_rut AND TO_CHAR(fecha_atencion, 'MM-YYYY') = pkg_medicos.periodo;
        RETURN cantidad_atenciones;
    END;
END;
