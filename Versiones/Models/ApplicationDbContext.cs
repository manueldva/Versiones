using Microsoft.EntityFrameworkCore;
using Versiones.Models;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
    {
    }

    public DbSet<Empleado> Empleados { get; set; }
}
