

alter procedure VS_RecuperarTipoObjetos_Cons_sp
as

SELECT 1 TipoID, 'TABLA' Tipo
union 
select 2 TipoID, 'STORE' Tipo
union 
select 3 TipoID, 'FUNCION' Tipo