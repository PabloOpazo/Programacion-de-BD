SET SERVEROUTPUT ON;

--EJERCICIO 1
DECLARE
    total_clientes NUMBER;
BEGIN
    SELECT 
        COUNT(numrun)
    INTO total_clientes
    FROM cliente;
    DBMS_OUTPUT.PUT_LINE('Total de clientes: '||total_clientes);
END;

--EJERCICIO 2
DECLARE
    p_minimo NUMBER;
    p_maximo NUMBER;
    
BEGIN
    SELECT 
        MIN(valorpeso),
        MAX(valorpeso)
    INTO p_minimo, p_maximo
    FROM producto;
    
    DBMS_OUTPUT.PUT_LINE('Valor mínimo: $'||p_minimo);
    DBMS_OUTPUT.PUT_LINE('Valor máximo: $'|| p_maximo);
    
END;


-- EJERCICIO 3
DECLARE
    nom_cl cliente.pnombre%TYPE;
    app_cl cliente.appaterno%TYPE;
    apm_cl cliente.apmaterno%TYPE;
    dir_cl cliente.direccion%TYPE;
    rut_consultar cliente.numrun%TYPE := &RUT;

BEGIN
    SELECT
        pnombre,
        appaterno,
        apmaterno,
        direccion
    INTO nom_cl, app_cl, apm_cl, dir_cl
    FROM cliente 
    WHERE numrun = rut_consultar;
    
    DBMS_OUTPUT.PUT_LINE('Cliente: ' || nom_cl || ' ' || app_cl || ' ' || apm_cl);
    DBMS_OUTPUT.PUT_LINE('Dirección: ' || dir_cl);
END;


-- EJERCICIO 4
DECLARE
    cant_factura NUMBER;
    mes_inicio NUMBER(2) := &mes_inicio;
    ano_inicio NUMBER(4) := &ano_inicio;
    
    mes_termino NUMBER(2) := &mes_termino;
    ano_termino NUMBER(4) := &ano_termino;
    
BEGIN
    SELECT
        COUNT(numfactura)
    INTO cant_factura
    FROM factura;
    
    DBMS_OUTPUT.PUT_LINE('FACTURAS REALIZADAS ENTRE: ' || mes_inicio || '/' || ano_inicio || ' HASTA ' || mes_termino || '/' || ano_termino);
    DBMS_OUTPUT.PUT_LINE('TOTAL: '|| cant_factura);
END;
