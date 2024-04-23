ALTER PROCEDURE [dbo].[VS_RecuperarObjetos_Cons_sp] 
    @TipoID int = NULL,
    @PageSize int = 10,
    @PageNumber int = 1
AS
BEGIN
    IF @TipoID IS NULL OR @TipoID = 1
    BEGIN
        SELECT
             CAST(ROW_NUMBER() OVER (ORDER BY TABLE_SCHEMA, TABLE_NAME) AS INT) AS ID,
            TABLE_SCHEMA,
            TABLE_NAME,
            'SELECT * FROM ' + QUOTENAME(TABLE_NAME) AS definition
        FROM
            INFORMATION_SCHEMA.TABLES
        WHERE
            TABLE_TYPE = 'BASE TABLE'
        ORDER BY
            TABLE_SCHEMA,
            TABLE_NAME
        OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
    END 
    ELSE
    BEGIN
        SELECT 
            CAST(ROW_NUMBER() OVER (ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME) AS INT) AS ID,
            ROUTINE_SCHEMA AS TABLE_SCHEMA,
            ROUTINE_NAME AS TABLE_NAME,
            (SELECT ISNULL(definition, 'Encriptado') FROM sys.all_sql_modules WHERE object_id = OBJECT_ID(ROUTINE_NAME)) AS definition
        FROM 
            INFORMATION_SCHEMA.ROUTINES
        WHERE 
            ROUTINE_TYPE = 'PROCEDURE'
        ORDER BY 
            ROUTINE_SCHEMA, ROUTINE_NAME
        OFFSET (@PageNumber - 1) * @PageSize ROWS
        FETCH NEXT @PageSize ROWS ONLY;
    END
END
