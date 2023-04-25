SET SERVEROUTPUT ON;

DECLARE
    -- Cursor de tarjetas
    CURSOR c_tarjetas IS
        SELECT 
            nro_tarjeta AS num_tarjeta,
            TO_CHAR(fecha_solic_tarjeta, 'MM/YYYY') AS fecha,
            numrun AS run
        FROM tarjeta_cliente;
        
    -- Cursor transacciones
    CURSOR c_transacciones(p_nrotarjeta NUMBER) IS
        SELECT
            nro_transaccion AS nro_tranc,
            TO_CHAR(fecha_transaccion, 'DD-MM-YYYY') AS fecha_tranc,
            TO_CHAR(monto_transaccion, '$999g999g999') AS monto_tranc
        FROM transaccion_tarjeta_cliente
        WHERE nro_tarjeta = p_nrotarjeta;
    -- nombre cliente
    nombre_cliente VARCHAR2(100);
    monto_total NUMBER;
    
BEGIN
    FOR reg_tarjeta IN c_tarjetas LOOP
    
        DBMS_OUTPUT.PUT_LINE('NRO. TARJETA : '|| reg_tarjeta.num_tarjeta);
        SELECT
            appaterno||' '||apmaterno||' '||pnombre
        INTO nombre_cliente
        FROM cliente
        WHERE reg_tarjeta.run = numrun;
        DBMS_OUTPUT.PUT_LINE('CLIENTE : '|| nombre_cliente);
        DBMS_OUTPUT.PUT_LINE('SOLICITADA EN : '|| reg_tarjeta.fecha);
        
        DBMS_OUTPUT.PUT_LINE('DETALLE MOVIMIENTOS ');
        FOR reg_transaccion IN c_transacciones(reg_tarjeta.num_tarjeta) LOOP            
        
            IF reg_transaccion.monto_tranc > 0 THEN
                DBMS_OUTPUT.PUT_LINE( reg_transaccion.nro_tranc||' '||reg_transaccion.fecha_tranc||' '||reg_transaccion.monto_tranc);
                
            ELSE
                DBMS_OUTPUT.PUT_LINE('TARJETA SIN MOVIMIENTOS');
            END IF;
                
            
        END LOOP;
        CASE
            DBMS_OUTPUT.PUT_LINE('MONTO TOTAL TRANSACCIONES : '||monto_total_tranc);
        
        DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    END LOOP;
END;
