--PARTE 1
DECLARE
    id_pais pais.codpais%TYPE;
    nombre_pais pais.nompais%TYPE;
    cant_productos NUMBER;
    proporcion informe_pais.proporcion_pais%TYPE;
    categoria informe_pais.categoria%TYPE;
    
    ini_pais NUMBER;
    fin_pais NUMBER;
    total_general NUMBER;
    
BEGIN
    --truncar tabla
    EXECUTE IMMEDIATE 'TRUNCATE TABLE informe_pais';
    
    -- definimos el valor mínimo y el valor máximo de los CODPAIS
    SELECT
        MIN(codpais),
        MAX(codpais)
    INTO ini_pais, fin_pais
    FROM pais;
    
    -- total de productos
    SELECT
        COUNT(codproducto)
    INTO total_general
    FROM producto;
    
    
    
    FOR cod_pais IN ini_pais..fin_pais LOOP
    
        -- Extraemos el ID y NOMBRE de cada país
        SELECT
            codpais,
            nompais
        INTO id_pais, nombre_pais
        FROM pais
        WHERE codpais = cod_pais;
        
        -- Extraemos la CANTIDAD DE PRODUCTOS de cada pais
        SELECT
            COUNT(codproducto)
        INTO cant_productos
        FROM producto
        WHERE codpais = cod_pais;
        
        -- definimos la proporción 
        proporcion := ROUND(cant_productos/total_general, 2);
        
        -- Categoría
        categoria := CASE 
        WHEN proporcion = 0 THEN
            '-'
        WHEN proporcion < 0.1 THEN
            'C1'
        WHEN proporcion BETWEEN 0.1 AND 0.5 THEN
            'C2'
        ELSE
            'C3'
        END;
        -- INSERTAMOS los valores en tabla INFORME_PAIS
        INSERT INTO informe_pais VALUES (SEQ_INFORME.NEXTVAL, cod_pais, nombre_pais, cant_productos, proporcion, categoria);
    
    END LOOP;
END;



