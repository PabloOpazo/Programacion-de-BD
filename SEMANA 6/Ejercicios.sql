SET SERVEROUTPUT ON;

-- EJERCICIO 1:     1 CURSOR EXPLÍCITO
DECLARE

    CURSOR c_medico IS
        SELECT 
            m.med_run||'-'|| m.dv_run RUN,
            m.apaterno||' '||m.amaterno||' '||m.pnombre||' '||m.snombre NOMBRE,
            c.nombre CARGO
        FROM medico m JOIN cargo c ON(m.car_id = c.car_id);
    reg_medicos c_medico%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('INFORME DE MEDICOS Y SUS CARGOS');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------------------');
    OPEN c_medico;
    LOOP
        FETCH c_medico INTO reg_medicos;
        EXIT WHEN c_medico%NOTFOUND;        
        DBMS_OUTPUT.PUT_LINE(reg_medicos.RUN ||' '||reg_medicos.NOMBRE||' es '|| reg_medicos.CARGO);
    END LOOP;
    CLOSE c_medico;
    
END;

-- EJERCICIO 2
DECLARE
    CURSOR c_atencion (p_periodo VARCHAR2) IS
        SELECT
            a.pac_run RUN,
            p.apaterno||' '||p.amaterno||' '||p.pnombre||' '||p.snombre NOMBRE
             
        FROM atencion a JOIN paciente p ON(a.pac_run = p.pac_run)
        WHERE TO_CHAR(fecha_atencion,'MM-YYYY') = p_periodo;
    reg_atencion c_atencion%ROWTYPE;
    periodo_c VARCHAR2(7):= '&periodo_c';
    total NUMBER;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('PACIENTES ATENDIDOS DURANTE '||periodo_c);
    
    SELECT
        COUNT(pac_run)
    INTO total
    FROM atencion
    WHERE TO_CHAR(fecha_atencion,'MM-YYYY') = periodo_c;
    
    OPEN c_atencion(periodo_c);
    LOOP
        FETCH c_atencion INTO reg_atencion;
        EXIT WHEN c_atencion%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE(reg_atencion.NOMBRE);
        
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('TOTAL PACIENTES: '||total);
    CLOSE c_atencion;
END;
