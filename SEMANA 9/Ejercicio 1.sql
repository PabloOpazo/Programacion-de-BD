--anasheiiii
SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_pacientes IS
        SELECT
            pac_run,
            apaterno ||' '|| amaterno||' '|| pnombre nombre_paciente
        FROM paciente;
    CURSOR c_atenciones(p_rut NUMBER) IS
        SELECT
            fecha_atencion fecha,
            costo costo
        FROM atencion
        WHERE pac_run = p_rut;
    total_atenciones NUMBER;
    porc_paciente NUMBER;
    
    --errores
    msg_oracle error_proceso.descripcion_oracle%TYPE;
    
BEGIN
    --RECORRER PACIENTES
    FOR reg_paciente IN c_pacientes LOOP
        DBMS_OUTPUT.PUT_LINE('NOMBRE PACIENTE : '||reg_paciente.nombre_paciente);
        
        --RECCORRER ATENCIONES POR PACIENTE
        FOR reg_atencion IN c_atenciones(reg_paciente.pac_run) LOOP
            DBMS_OUTPUT.PUT_LINE(reg_atencion.fecha||' : '||TO_CHAR(reg_atencion.costo,'$999g999g999'));
            SELECT 
                COUNT(ate_id)
            INTO total_atenciones
            FROM atencion
            WHERE pac_run = reg_paciente.pac_run;
            
            BEGIN                
                SELECT
                    porc_asig
                INTO porc_paciente
                FROM tramo_asig_atmed
                WHERE total_atenciones BETWEEN tramo_inf_atm AND tramo_sup_atm;
                
                EXCEPTION
                    WHEN TOO_MANY_ROWS THEN
                        msg_oracle := SQLERRM;
                        INSERT INTO error_proceso VALUES(seq_error.NEXTVAL, 'Existe mas de un registro', msg_oracle, USER);
                        
                    WHEN NO_DATA_FOUND THEN
                        porc_paciente := 0;
                        msg_oracle := SQLERRM;
                        INSERT INTO error_proceso VALUES(seq_error.NEXTVAL, 'No existen registros', msg_oracle, USER);
            END;
        END LOOP;
        
    END LOOP;
END;
