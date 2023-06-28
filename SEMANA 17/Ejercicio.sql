CREATE OR REPLACE PACKAGE pkg_examen IS
    
    diferencia NUMBER;
    total_boleta NUMBER;
    
    PROCEDURE sp_insertar_error (p_programa VARCHAR2, p_desc_sql VARCHAR2, p_desc_real VARCHAR2); 
    FUNCTION fn_total_boleta (p_id_boleta VARCHAR2) RETURN NUMBER;
    
END;

CREATE OR REPLACE PACKAGE BODY pkg_examen IS    
    PROCEDURE sp_insertar_error (p_programa VARCHAR2, p_desc_sql VARCHAR2, p_desc_real VARCHAR2) IS
    BEGIN
        INSERT INTO log_errores VALUES (sq_error.NEXTVAL, p_programa, p_desc_sql, p_desc_real);
    END;
    
    FUNCTION fn_total_boleta (p_id_boleta VARCHAR2) RETURN NUMBER IS
        msg_oracle log_errores.le_descripcion_sql%TYPE;
    BEGIN
        SELECT
            SUM(vp_precio * bp_producto_cantidad)
        INTO
            pkg_examen.total_boleta
        FROM boleta a 
        JOIN boleta_producto b ON (a.bol_numero = b.bol_numero)
        JOIN vigencia_precio c ON (b.pro_codigo = c.pro_codigo AND a.bol_fecha BETWEEN vp_fecha_inicio_vigencia AND vp_fecha_termino_vigencia)
        WHERE a.bol_numero = p_id_boleta;    
        
        RETURN pkg_examen.total_boleta;
        
        EXCEPTION WHEN NO_DATA_FOUND THEN
            msg_oracle := SQLERRM;
            sp_insertar_error('fn_total_boleta', msg_oracle, 'Error al calcular valor de la boleta');
    END;
END;

CREATE OR REPLACE FUNCTION fn_categoria (p_id_boleta VARCHAR2) RETURN VARCHAR2 IS
    
    categoria categorizacion_categoria.cd_categoria%TYPE;
    total_boleta NUMBER;
    msg_oracle log_errores.le_descripcion_sql%TYPE;
    
BEGIN 
    total_boleta := pkg_examen.fn_total_boleta(p_id_boleta);
    SELECT
        cd_categoria
    INTO
        categoria
    FROM categorizacion_diferencia
    WHERE total_boleta BETWEEN cd_valor_minimo AND cd_valor_maximo;

    RETURN categoria;
  
    EXCEPTION WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
        msg_oracle := SQLERRM;
        pkg_examen.sp_insertar_error ('fn_categoria', msg_oracle, 'Error al calcular valor de la boleta');
        
        RETURN ('SIN CATEGORÍA');
END;

CREATE OR REPLACE PROCEDURE sp_informe IS
    CURSOR c_boletas IS
        SELECT 
            bol_numero,
            bol_fecha,
            bol_total,
            tip_nombre,
            ven_pnombre ||' '||ven_apaterno||' '||ven_apaterno AS nombre_vendedor,
            cli_correo
            
        FROM boleta a
        JOIN vendedor b ON (a.ven_rut = b.ven_rut)
        JOIN tipo_venta c ON (a.tip_id = c.tip_id)
        JOIN cliente d ON (a.cli_rut = d.cli_rut)
        WHERE c.tip_id IN (2,3);
BEGIN
    FOR reg_boleta IN c_boletas LOOP
    
    END;
END;

CREATE OR REPLACE TRIGGER trg_aaaaaaaaaaaaaaa IS
    AFTER CREATE ON DATABASE
BEGIN
    NULL;
END;
