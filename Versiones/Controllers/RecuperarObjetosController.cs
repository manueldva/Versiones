using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Versiones.Models;

public class RecuperarObjetosController : Controller
{
    private readonly ApplicationDbContext _context;

    public RecuperarObjetosController(ApplicationDbContext context)
    {
        _context = context;
    }

    public IActionResult Index(int? TipoID)
    {
        List<RecuperarObjeto> RecuperarObjetos = new List<RecuperarObjeto>();
        using (var command = _context.Database.GetDbConnection().CreateCommand())
        {
            command.CommandText = "VS_RecuperarObjetos_Cons_sp";
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.Add(new SqlParameter("@TipoID", TipoID)); // Agrega '?? 0' aquí
            _context.Database.OpenConnection();

            using (var result = command.ExecuteReader())
            {
                RecuperarObjetos = result.Cast<IDataRecord>()
                    .Select(x => new RecuperarObjeto()
                    {
                        ID = (int)x["ID"],
                        TABLE_SCHEMA = (string)x["TABLE_SCHEMA"],
                        TABLE_NAME = (string)x["TABLE_NAME"],
                    }).ToList();
            }
        }

        List<TipoObjeto> tiposObjeto = new List<TipoObjeto>();
        using (var command = _context.Database.GetDbConnection().CreateCommand())
        {
            command.CommandText = "VS_RecuperarTipoObjetos_Cons_sp";
            command.CommandType = CommandType.StoredProcedure;
            _context.Database.OpenConnection();

            using (var result = command.ExecuteReader())
            {
                tiposObjeto = result.Cast<IDataRecord>()
                    .Select(x => new TipoObjeto()
                    {
                        TipoID = (int)x["TipoID"],
                        Tipo = (string)x["Tipo"],
                    }).ToList();
            }
        }

        ViewData["RecuperarObjetos"] = RecuperarObjetos;
        ViewData["TiposObjeto"] = tiposObjeto;

        return View(RecuperarObjetos);

    }
}
