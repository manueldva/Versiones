ALTER PROCEDURE [dbo].[VS_RecuperarObjetos_Cons_sp] 
    @TipoID int = NULL,
    @PageSize int = 10,
    @PageNumber int = 1
AS
BEGIN
    IF @TipoID IS NULL OR @TipoID = 1
    BEGIN
        WITH CTE AS (
            SELECT
                ROW_NUMBER() OVER (ORDER BY TABLE_SCHEMA, TABLE_NAME) AS RowNum,
                TABLE_SCHEMA,
                TABLE_NAME,
                dbo.GetTableDefinitionScript(TABLE_NAME) AS definition
            FROM
                INFORMATION_SCHEMA.TABLES
            WHERE
                TABLE_TYPE = 'BASE TABLE'
        )
        SELECT
            CAST(RowNum AS INT) ID,
            TABLE_SCHEMA,
            TABLE_NAME,
            definition
        FROM
            CTE
        WHERE
            RowNum BETWEEN (@PageNumber - 1) * @PageSize + 1 AND @PageNumber * @PageSize
        ORDER BY
            TABLE_SCHEMA,
            TABLE_NAME;
    END 
    ELSE
    BEGIN
        WITH CTE AS (
            SELECT 
                ROW_NUMBER() OVER (ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME) AS RowNum,
                ROUTINE_SCHEMA AS TABLE_SCHEMA,
                ROUTINE_NAME AS TABLE_NAME,
                (SELECT ISNULL(definition, 'Encriptado') FROM sys.all_sql_modules WHERE object_id = OBJECT_ID(ROUTINE_NAME)) AS definition
            FROM 
                INFORMATION_SCHEMA.ROUTINES
            WHERE 
                ROUTINE_TYPE = 'PROCEDURE'
        )
        SELECT 
            CAST(RowNum AS INT) ID,
            TABLE_SCHEMA,
            TABLE_NAME,
            definition
        FROM 
            CTE
        WHERE 
            RowNum BETWEEN (@PageNumber - 1) * @PageSize + 1 AND @PageNumber * @PageSize
        ORDER BY 
            TABLE_SCHEMA, 
            TABLE_NAME;
    END
END
