using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Courses;
using CodeQuest2026.Server.Application.Courses.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CodeQuest2026.Server.Controllers;

[ApiController]
[Authorize]
[Route("courses")]
[ProducesResponseType<ApiErrorDto>(StatusCodes.Status401Unauthorized)]
[ProducesResponseType<ApiErrorDto>(StatusCodes.Status500InternalServerError)]
public sealed class CoursesController(ISender sender) : ControllerBase
{
    /// <summary>Lista todos los cursos activos con sus datos básicos, ordenados por título e ID.</summary>
    /// <remarks>No incluye descripción, temario, habilidades, requisitos ni embeddings. Sin paginación.</remarks>
    [HttpGet]
    [ProducesResponseType<CourseDto[]>(StatusCodes.Status200OK)]
    public async Task<ActionResult<IReadOnlyList<CourseDto>>> List(CancellationToken cancellationToken)
    {
        var courses = await sender.Send(new GetCoursesQuery(), cancellationToken);

        return Ok(courses);
    }

    /// <summary>Consulta los datos básicos de un curso activo.</summary>
    /// <response code="404">El curso no existe o está inactivo.</response>
    [HttpGet("{courseId:long}")]
    [ProducesResponseType<CourseDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status404NotFound)]
    public async Task<ActionResult<CourseDto>> GetById(long courseId, CancellationToken cancellationToken)
    {
        var course = await sender.Send(new GetCourseByIdQuery(courseId), cancellationToken);

        return course is null
            ? NotFound(new ApiErrorDto("course_not_found", "No se encontró el curso solicitado."))
            : Ok(course);
    }
}
