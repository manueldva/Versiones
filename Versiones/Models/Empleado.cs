using System.ComponentModel.DataAnnotations.Schema;

[Table("Empleado")]
public class Empleado
{
    public int EmpleadoID { get; set; }
    public string Nombre { get; set; }
    public string Apellido { get; set; }
    // Agrega aquí otras propiedades según los campos de tu tabla `empleado`
}
