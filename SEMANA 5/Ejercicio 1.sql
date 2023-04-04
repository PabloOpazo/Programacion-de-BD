SET SERVEROUTPUT ON;

DECLARE
    id_cliente cliente_todosuma.nro_cliente%TYPE;
    run_cliente cliente_todosuma.run_cliente%TYPE;
    nom_cliente cliente_todosuma.nombre_cliente%TYPE;
    desc_tipo_cliente cliente_todosuma.tipo_cliente%TYPE;
    total_creditos cliente_todosuma.monto_solic_creditos%TYPE;
    monto_pesos cliente_todosuma.monto_solic_creditos%TYPE;
    
    edad NUMBER;
    
    min_id_cl NUMBER;
    max_id_cl NUMBER;
    
    fecha_consulta VARCHAR2(7) := '&mes_año';
    
BEGIN
    SELECT
        MIN(nro_cliente),
        MAX(max_id_cl)
    INTO min_id_cl, max_id_cl
    FROM cliente;
    
    FOR id_cl IN min_id_cl..max_id_cl LOOP
    
        SELECT
            c.numrun,
            c.pnombre,
            tc.nombre_tipo_cliente,
            NVL(SUM(cc.monto_credito), 0),
            TRUNC((TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'))- TO_NUMBER(TO_CHAR(c.fecha_nacimiento,'YYYYMMDD')))/1000)
            
        INTO
            run_cliente,
            nom_cliente,
            desc_tipo_cliente,
            total_creditos,
            edad
            
        
        FROM cliente c
        JOIN tipo_cliente tc ON(c.cod_tipo_cliente = tc.cod_tipo_cliente)
        JOIN credito_cliente cc ON(c.nro_cliente = cc.nro_cliente)
        WHERE c.nro_cliente = id_cl AND TO_CHAR(fecha_otorga_cred, 'MM/YYYY') = TO_CHAR(fecha_consulta, 'MM/YYYY') 
        GROUP BY c.numrun, c.pnombre, tc.nombre_tipo_cliente, TRUNC((TO_NUMBER(TO_CHAR(SYSDATE,'YYYYMMDD'))- TO_NUMBER(TO_CHAR(c.fecha_nacimiento,'YYYYMMDD')))/1000);
        
        
        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('FIN');
END;
