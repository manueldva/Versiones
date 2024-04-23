alter FUNCTION dbo.VS_GetTableDefinitionScript(@TableName NVARCHAR(128))
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @CreateScript NVARCHAR(MAX);

    SET @CreateScript = (
        SELECT 
            'CREATE TABLE ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + CHAR(13) + '(' + CHAR(13) +
            STUFF((
                SELECT CHAR(9) + ', ' + QUOTENAME(c.name) + ' ' + t.name +
                       CASE 
                           WHEN t.name IN ('text', 'ntext', 'image') THEN ''
                           WHEN c.max_length > 0 THEN '(' + CAST(c.max_length AS VARCHAR) + ')'
                           ELSE ''
                       END +
                       CASE 
                           WHEN c.is_nullable = 0 THEN ' NOT NULL'
                           ELSE ''
                       END +
                       CASE 
                           WHEN ic.index_column_id IS NOT NULL THEN ' PRIMARY KEY'
                           ELSE ''
                       END +
                       CASE 
                           WHEN c.is_identity = 1 THEN ' IDENTITY(' + CAST(ident.seed_value AS VARCHAR) + ',' + CAST(ident.increment_value AS VARCHAR) + ')'
                           ELSE ''
                       END + CHAR(13)
                FROM sys.columns c
                JOIN sys.types t ON c.user_type_id = t.user_type_id
                JOIN sys.tables tb ON c.object_id = tb.object_id
                LEFT JOIN sys.index_columns ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
                LEFT JOIN sys.identity_columns ident ON c.object_id = ident.object_id AND c.column_id = ident.column_id
                WHERE tb.name = @TableName
                ORDER BY c.column_id
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') + CHAR(13) + ');' AS CreateScript
        FROM INFORMATION_SCHEMA.TABLES t
        WHERE t.TABLE_NAME = @TableName
    );

    RETURN @CreateScript;
END;
