USE [MHO]
GO
/****** Object:  StoredProcedure [dbo].[VS_RecuperarObjetos_Cons_sp]    Script Date: 22/4/2024 21:20:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[VS_RecuperarObjetos_Cons_sp] 
 @TipoID int=null
AS

IF @TipoID IS NULL or @TipoID = 1 BEGIN

    SELECT
        CAST(ROW_NUMBER() OVER (ORDER BY TABLE_SCHEMA, TABLE_NAME) AS INT) AS ID,
        TABLE_SCHEMA,
        TABLE_NAME,
		'Select * from ' + TABLE_NAME definition
    FROM
        INFORMATION_SCHEMA.TABLES
    WHERE
        TABLE_TYPE = 'BASE TABLE'
    ORDER BY
        TABLE_SCHEMA,
        TABLE_NAME;
END 
ELSE
BEGIN
    SELECT 
		 CAST(ROW_NUMBER() OVER (ORDER BY ROUTINE_SCHEMA, ROUTINE_NAME) AS INT) AS ID,
		ROUTINE_SCHEMA AS TABLE_SCHEMA,
		ROUTINE_NAME AS TABLE_NAME,
		( SELECT isnull(definition,'Encriptado') FROM sys.all_sql_modules WHERE object_id = OBJECT_ID(ROUTINE_NAME)) definition
	FROM 
		INFORMATION_SCHEMA.ROUTINES
	WHERE 
		ROUTINE_TYPE = 'PROCEDURE'
	ORDER BY 
		ROUTINE_SCHEMA, ROUTINE_NAME;
END
