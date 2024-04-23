CREATE FUNCTION dbo.VS_GetTableDefinitionScript(@TableName NVARCHAR(128))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @CreateScript NVARCHAR(MAX);

    SET @CreateScript = (
        SELECT 
            'CREATE TABLE ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + CHAR(13) + '(' + CHAR(13) +
            STUFF((
                SELECT CHAR(9) + ', ' + QUOTENAME(c.COLUMN_NAME) + ' ' + c.DATA_TYPE +
                       COALESCE('('+CAST(c.CHARACTER_MAXIMUM_LENGTH AS VARCHAR)+')','') +
                       CASE WHEN c.IS_NULLABLE = 'NO' THEN ' NOT NULL' ELSE '' END + CHAR(13)
                FROM INFORMATION_SCHEMA.COLUMNS c
                WHERE c.TABLE_SCHEMA = t.TABLE_SCHEMA
                  AND c.TABLE_NAME = t.TABLE_NAME
                ORDER BY c.ORDINAL_POSITION
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + ');' AS CreateScript
        FROM INFORMATION_SCHEMA.TABLES t
        WHERE t.TABLE_NAME = @TableName
    );

    RETURN @CreateScript;
END;
