SET SERVEROUTPUT ON; 
DECLARE
    -- Almacena las tarjetas que seran procesadas
    CURSOR c_tarjetas IS
        SELECT nro_tarjeta, 
            TO_CHAR(fecha_solic_tarjeta, 'MM-YYYY') periodo,
            numrun
        FROM tarjeta_cliente;
    -- Almacena el nombre del cliente
    nombre_cliente VARCHAR2(100);
    -- Almacena las transacciones de una tarjeta
    CURSOR c_transacciones(p_nrotarjeta NUMBER) IS
        SELECT nro_transaccion, fecha_transaccion, 
            monto_transaccion
        FROM transaccion_tarjeta_cliente
        WHERE nro_tarjeta = p_nrotarjeta;
        --almacena la suma de todos los montos
        suma_total NUMBER;
        t_sin_movimientos NUMBER := 0;
        t_con_movimientos NUMBER := 0;
BEGIN
    -- Recorrer el cursor
    FOR reg_tarjeta IN c_tarjetas LOOP
        -- Imprimir los datos de la tarjeta
        DBMS_OUTPUT.PUT_LINE('NRO. TARJETA : ' || 
            reg_tarjeta.nro_tarjeta);
        -- Obtiene el nombre del cliente
        SELECT appaterno || ' ' || apmaterno || ' ' || pnombre
        INTO nombre_cliente
        FROM cliente
        WHERE numrun = reg_tarjeta.numrun;
        DBMS_OUTPUT.PUT_LINE('CLIENTE : ' || nombre_cliente);
        DBMS_OUTPUT.PUT_LINE('SOLICITADA EN : ' || reg_tarjeta.periodo);
        DBMS_OUTPUT.PUT_LINE('--');
        -- Recorrer las transacciones de la tarjeta
        suma_total := 0;
        DBMS_OUTPUT.PUT_LINE('DETALLE MOVIMIENTOS');
        FOR reg_transaccion IN
            c_transacciones(reg_tarjeta.nro_tarjeta) LOOP
            DBMS_OUTPUT.PUT_LINE(reg_transaccion.nro_transaccion || ' '
            || reg_transaccion.fecha_transaccion || ' ' ||
            TO_CHAR(reg_transaccion.monto_transaccion,'$999g999g999'));
            suma_total := suma_total + reg_transaccion.monto_transaccion;
        END LOOP;
        IF suma_total = 0 THEN
            DBMS_OUTPUT.PUT_LINE('TARJETA SIN MOVIMIENTOS');
            t_sin_movimientos := t_sin_movimientos + 1;
                
        ELSE
            DBMS_OUTPUT.PUT_LINE('MONTO TOTAL TRANSACCIONES : '|| TO_CHAR(suma_total,'$999G999G999'));
            t_con_movimientos := t_con_movimientos + 1;
        END IF;
        DBMS_OUTPUT.PUT_LINE('------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('CANTIDAD DE TARJETAS CON MOVIMIENTOS : '||t_con_movimientos);
        DBMS_OUTPUT.PUT_LINE('CANTIDAD DE TARJETAS SIN MOVIMIENTOS : '||t_sin_movimientos);
    END LOOP;
END;
