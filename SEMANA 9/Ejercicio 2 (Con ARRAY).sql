SET SERVEROUTPUT ON;




DECLARE
    CURSOR c_especialidades IS
        SELECT
            esp_id,
            nombre
        FROM especialidad;
        
    CURSOR c_atenciones(p_especialidad NUMBER) IS
        SELECT
            ate_id,
            fecha_atencion,
            costo,
            pac_run
        FROM atencion
        WHERE esp_id =p_especialidad;
    
    total_especialistas NUMBER;
    edad NUMBER;
    error_negocio EXCEPTION;
    porcentaje PORC_DESCTO_3RA_EDAD.porcentaje_descto%TYPE;
    msg_oracle error_proceso.descripcion_oracle%TYPE;
    -- ARRAY
    TYPE t_mensajes IS VARRAY(2) OF VARCHAR2(100);
    mensajes t_mensajes;
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_especialidad';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE resumen_atenciones';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE error_proceso';
    
    -- MENSAJES DE ARRAY
    mensajes := t_mensajes('No cumple minimo deespecialistas', 'No existe %');
    
    
    FOR reg_especialidad IN c_especialidades LOOP
        -- obtener total de especialistas
        SELECT
            COUNT(med_run)
        INTO total_especialistas
        FROM especialidad_medico
        WHERE esp_id = reg_especialidad.esp_id;
        
        INSERT INTO resumen_especialidad VALUES (reg_especialidad.esp_id, reg_especialidad.nombre, total_especialistas);
        
        BEGIN
            
            IF total_especialistas < 2 THEN
                RAISE error_negocio;
            END IF;
            EXCEPTION
                    WHEN error_negocio THEN
                        INSERT INTO error_proceso VALUES(seq_error.NEXTVAL, mensajes(1), 'ERROR DE NEGOCIO', USER);
        END;
        FOR reg_atencion IN c_atenciones(reg_especialidad.esp_id) LOOP
            SELECT
                TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nacimiento)/12)
            INTO edad
            FROM paciente
            WHERE pac_run = reg_atencion.pac_run;
            BEGIN
            
                SELECT
                    porcentaje_descto
                INTO porcentaje
                FROM porc_descto_3ra_edad
                WHERE edad BETWEEN anno_ini AND anno_ter;
                
                EXCEPTION
                      WHEN no_data_found THEN
                        msg_oracle := SQLERRM;
                        INSERT INTO error_proceso VALUES(seq_error.NEXTVAL, mensajes(2), msg_oracle, USER);
            END;
            INSERT INTO resumen_atenciones VALUES (reg_especialidad.esp_id, reg_atencion.ate_id, reg_atencion.fecha_atencion, reg_atencion.costo, NVL(porcentaje, 0));
        END LOOP;
        
    END LOOP;
END;
