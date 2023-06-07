-- Crear nueva tabla
CREATE TABLE resumen_region (
    id_region NUMBER PRIMARY KEY,
    nombre_region VARCHAR2(100) NOT NULL,
    total_clientes NUMBER
);

CREATE OR REPLACE FUNCTION fn_total_clientes(p_region NUMBER) RETURN NUMBER
IS
    total NUMBER;
BEGIN
    SELECT
        COUNT(numrun)
    INTO total
    FROM cliente
    WHERE cod_region = p_region;
    
    RETURN total;
END;

CREATE OR REPLACE PROCEDURE sp_resumen 
IS
    CURSOR c_regiones IS
        SELECT
            cod_region AS id,
            nombre_region AS nombre
        FROM region;
    total_clientes NUMBER;
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_region';
    FOR reg_region IN c_regiones LOOP
        total_clientes := fn_total_clientes(reg_region.id);
        INSERT INTO resumen_region VALUES (reg_region.id, reg_region.nombre, total_clientes);
    END LOOP;
    
END;

CREATE OR REPLACE TRIGGER trg_resumen
AFTER INSERT OR UPDATE OF cod_region ON cliente
FOR EACH ROW
BEGIN    
    UPDATE resumen_region
    SET total_clientes = total_clientes + 1
    WHERE id_region = :NEW.cod_region;
    
    IF UPDATING THEN
        UPDATE resumen_region
        SET total_clientes = total_clientes - 1
        WHERE id_region = :OLD.cod_region;
    END IF;
END;

--PRUEBAS

UPDATE cliente
SET cod_region = 9
WHERE numrun = 16000472;

EXECUTE sp_resumen;
