using System.ComponentModel.DataAnnotations;
using CodeQuest2026.Server.Application.Common;
using CodeQuest2026.Server.Application.Courses;
using CodeQuest2026.Server.Application.Courses.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CodeQuest2026.Server.Controllers;

[ApiController]
[AllowAnonymous]
[Route("courses")]
[ProducesResponseType<ApiErrorDto>(StatusCodes.Status500InternalServerError)]
public sealed class CoursesController(ISender sender) : ControllerBase
{
    /// <summary>Lista públicamente los cursos activos paginados, ordenados por título e ID.</summary>
    /// <remarks>No incluye descripción, temario, habilidades, requisitos ni embeddings.</remarks>
    [HttpGet]
    [ProducesResponseType<PagedResultDto<CourseDto>>(StatusCodes.Status200OK)]
    [ProducesResponseType<ApiErrorDto>(StatusCodes.Status400BadRequest)]
    public async Task<ActionResult<PagedResultDto<CourseDto>>> List(
        [FromQuery, Range(1, int.MaxValue)] int page = GetCoursesQuery.DefaultPage,
        [FromQuery, Range(1, GetCoursesQuery.MaxPageSize)] int pageSize = GetCoursesQuery.DefaultPageSize,
        [FromQuery] string? search = null,
        CancellationToken cancellationToken = default)
    {
        var courses = await sender.Send(new GetCoursesQuery(page, pageSize, search), cancellationToken);

        return Ok(courses);
    }

    /// <summary>Consulta públicamente los datos básicos de un curso activo.</summary>
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
