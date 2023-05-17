SET SERVEROUTPUT ON;

-- Construir la funcion almacenada
CREATE OR REPLACE FUNCTION fn_total_edificios
RETURN NUMBER IS
    total NUMBER;
BEGIN
    SELECT COUNT(id_edif)
    INTO total
    FROM edificio;
    
    RETURN total;
END;

-- Probar la funci�n
DECLARE
    t NUMBER;
BEGIN
    t := fn_total_edificios();
    DBMS_OUTPUT.PUT_LINE('Total de edificios ' || t);
END;

CREATE OR REPLACE PROCEDURE sp_total_ed_adm(p_rut NUMBER,
p_total OUT NUMBER) IS
BEGIN
    SELECT COUNT(id_edif)
    INTO p_total
    FROM edificio
    WHERE numrun_adm = p_rut;
END;

-- Llamada al SP
DECLARE
    total_de_edificios NUMBER;
BEGIN
    sp_total_ed_adm(15018444, total_de_edificios);
    DBMS_OUTPUT.PUT_LINE(total_de_edificios);
END;

-- segundo SP
CREATE OR REPLACE PROCEDURE sp_informe IS
    CURSOR c_admins IS
        SELECT
            numrun_adm AS rut,
            appaterno_adm ||' '|| apmaterno_adm ||' '|| pnombre_adm AS nombre
        FROM administrador;
    
    -- total edificios
    total_general NUMBER;
    -- total del adm
    total_e_adm NUMBER;
    -- %
    porcentaje NUMBER;
BEGIN
    FOR reg_adm IN c_admins LOOP
        -- almacena total general de edificios
        total_general := fn_total_edificios();
        -- total admins
        sp_total_ed_adm(reg_adm.rut, total_e_adm);
        porcentaje := ROUND(total_e_adm/total_general*100);
        DBMS_OUTPUT.PUT_LINE(reg_adm.nombre ||' administra '||porcentaje||'% de los edificios equivalente a '|| total_e_adm ||' edificio(s)');    
    END LOOP;    
END;

BEGIN
    sp_informe;
END;

CREATE OR REPLACE PROCEDURE sp_insertar(p_nombre VARCHAR2, p_total number, p_porcentaje NUMBER) IS
BEGIN
    INSERT INTO TABLA_RESULTADO VALUES (p_nombre, p_total, p_porcentaje);
END;
