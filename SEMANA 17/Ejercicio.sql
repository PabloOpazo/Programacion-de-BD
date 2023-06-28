CREATE OR REPLACE PACKAGE pkg_examen IS
    
    periodo VARCHAR2(7);
    total_boleta NUMBER;
    
    PROCEDURE sp_insertar_error (p_programa VARCHAR2, p_desc_sql VARCHAR2, p_desc_real VARCHAR2); 
    FUNCTION fn_total_boleta (p_id_boleta VARCHAR2) RETURN NUMBER;
    
END;
