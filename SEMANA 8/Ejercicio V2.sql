SET SERVEROUTPUT ON;
DECLARE
    CURSOR c_tarjetas IS
        SELECT 
            tc.nro_tarjeta num_tarjeta,
            TO_CHAR(tc.fecha_solic_tarjeta,'MM-YYYY') periodo,
            tc.numrun
        FROM tarjeta_cliente tc;
    nombre_cliente VARCHAR2(100); 
    CURSOR c_transacciones(p_nrotarjeta NUMBER) IS
        SELECT
            nro_transaccion,
            fecha_transaccion,
            monto_transaccion
        FROM transaccion_tarjeta_cliente
        WHERE nro_tarjeta = p_nrotarjeta;
    suma_total NUMBER;
    total_sin_movimientos NUMBER;
    total_con_movimientos NUMBER;
BEGIN
    total_sin_movimientos :=0;
    total_con_movimientos :=0;
    FOR reg_tarjetas IN c_tarjetas LOOP
        DBMS_OUTPUT.PUT_LINE('NRO, TARJETA: '|| reg_tarjetas.num_tarjeta);
        SELECT
            c.appaterno||' '||c.apmaterno||' '||c.pnombre
        INTO nombre_cliente
        FROM cliente c
        WHERE c.numrun = reg_tarjetas.numrun;
        DBMS_OUTPUT.put_line('CLIENTE : '||nombre_cliente);
        DBMS_OUTPUT.put_line('PERIODO : '||reg_tarjetas.periodo);
        suma_total :=0;
        --recorrer transacciones de la tarjeta
        FOR reg_transaccion IN c_transacciones(reg_tarjetas.num_tarjeta) LOOP
            DBMS_OUTPUT.PUT_LINE (reg_transaccion.nro_transaccion ||' '||reg_transaccion.fecha_transaccion||' '||TO_CHAR(reg_transaccion.monto_transaccion, '$999g999g999'));
            suma_total:= suma_total + reg_transaccion.monto_transaccion;
        END LOOP;
        --obtiene el total de monto de transacciones
        SELECT 
            NVL(SUM(monto_transaccion),0)
        INTO
            suma_total
        FROM transaccion_tarjeta_cliente
        WHERE nro_tarjeta = reg_tarjetas.num_tarjeta;
        --imprimir total de mensaje sin transacciones
        IF suma_total = 0 THEN
            DBMS_OUTPUT.PUT_LINE('TARJETA SIN MOVIMIENTOS');
            total_sin_movimientos := total_sin_movimientos + 1;
        ELSE
            DBMS_OUTPUT.PUT_LINE('MONTO TOTAL DE TRANSACCIONES: '||' '||TO_CHAR(suma_total, '$999g999g999'));
            total_con_movimientos := total_con_movimientos + 1;
        END IF;
    END LOOP;
    --imprimir totales
    DBMS_OUTPUT.PUT_LINE('CANTIDAD TARJETAS CON MOVIMIENTOS : '||total_con_movimientos);
    DBMS_OUTPUT.PUT_LINE('CANTIDAD TARJETAS CON MOVIMIENTOS : '||total_sin_movimientos);
END;
