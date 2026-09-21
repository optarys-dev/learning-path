# Recomendación semántica V2 con proveedores de IA

`GET /routes/recommendation/semantic/v2` requiere la misma sesión Discord y preferencias
que `GET /routes/recommendation/semantic`. Es una vista previa y no guarda una ruta.
El endpoint anterior conserva su contrato y algoritmo.

La V2 usa la selección del motor semántico existente (hasta seis cursos) y realiza una
llamada al proveedor registrado para reorganizarlos y redactar razones personalizadas.
No agrega ni elimina cursos. El backend conserva títulos, puntuaciones, objetivo y
estimaciones de semanas del resultado original; recalcula las posiciones desde el
orden devuelto por la IA. Una puntuación mayor no implica una posición anterior.

## Configuración

Groq está registrado directamente en la inyección de dependencias. Configurar en el entorno del proceso del backend:

```text
Groq__ApiKey=<tu clave de Groq>
Groq__Model=openai/gpt-oss-20b
```

Para utilizar OpenAI, sustituir `GroqProvider` por `OpenAiProvider` en los registros
`AddHttpClient` y `AddScoped<IStructuredAiProvider>` de
`Extensions/ServiceCollectionExtensions.cs`, importar su namespace y configurar:

```text
OpenAI__ApiKey=<tu clave de API>
OpenAI__Model=gpt-5.4-nano
```

También se puede usar .NET User Secrets con las claves `Groq:ApiKey`,
`Groq:Model`, `OpenAI:ApiKey` y `OpenAI:Model`. No guardar claves reales en appsettings.json.
Solo se necesita la clave del proveedor registrado. El proveedor se cambia en código;
no existe un selector por configuración.
Los modelos alternativos deben admitir el JSON Schema estricto utilizado.
Groq usa Chat Completions y OpenAI usa Responses. No se cambia automáticamente de
proveedor ante errores ni se realizan llamadas a ambos.
Se usa un timeout de 30 segundos, un máximo de 2500 tokens de salida y una sola
llamada sin reintentos automáticos. Cada petición con cursos genera una llamada;
esta versión no incluye caché. Los embeddings siguen usando el servicio local.

## Contrato y extensibilidad

[`IStructuredAiProvider`](../Application/Common/AI/IStructuredAiProvider.cs) es el contrato
común, independiente de cursos y de APIs específicas:

```csharp
public interface IStructuredAiProvider
{
    string Name { get; }
    string Model { get; }
    bool IsConfigured { get; }
    Task<StructuredAiResponse> GenerateAsync(
        StructuredAiRequest request, CancellationToken cancellationToken);
}
```

`StructuredAiRequest` contiene instrucciones, entrada, nombre y JSON Schema, y límite
de salida. `StructuredAiResponse` contiene un estado común y el JSON extraído del
sobre del proveedor. La cancelación y las excepciones de transporte se propagan al
consumidor; los estados HTTP no exitosos se normalizan como `ProviderError`.

- `GroqProvider` adapta el contrato a `response_format.json_schema` de Groq.
- `OpenAiProvider` lo adapta a `text.format` de OpenAI.
- `RouteRefinementService` prepara preferencias/metadatos, construye el esquema,
  valida el resultado y conserva la ruta original ante errores.
- `ConfigureService` registra `GroqProvider` con un `HttpClient` administrado y lo
  expone como servicio scoped de `IStructuredAiProvider`. `RouteRefinementService`
  también es scoped. No existe una extensión específica para registrar el proveedor.

Para utilizar otro proveedor, implementar `IStructuredAiProvider` y sustituir el registro
en `Extensions/ServiceCollectionExtensions.cs`. El proveedor debe conservar el
esquema solicitado y normalizar rechazos y respuestas incompletas; no necesita
conocer ni modificar el endpoint, el motor semántico o la validación de cursos.
Usar un `Name` estable en minúsculas, pues forma parte de `method`.

## Esquema y validación

El esquema canónico está en
[`route-refinement.schema.json`](../Application/Routes/route-refinement.schema.json),
incluido como recurso del ensamblado para que funcione también al publicar.
Ambos proveedores solicitan `type: json_schema` y `strict: true`.
Todos los campos son obligatorios y los objetos rechazan propiedades adicionales.
En cada solicitud se restringe `courseId` mediante un `enum` con los IDs elegidos y
se ajustan `minItems` y `maxItems` al número exacto de cursos.

Respuesta esperada del modelo (el orden del arreglo define la posición):

```json
{
  "explanation": "Esta ruta conecta tu interés en Python con tu objetivo de aprender backend.",
  "courses": [
    { "courseId": 12, "reason": "Empieza reforzando las bases de Python que necesitarás después." },
    { "courseId": 34, "reason": "Continúa aplicando Python al desarrollo backend que te interesa." }
  ]
}
```

El backend valida también tipos, campos, longitud de textos y que los IDs formen
exactamente una permutación sin duplicados de los cursos originales. Rechaza JSON
inválido, propiedades adicionales, explicaciones vacías, rechazos del modelo y
respuestas incompletas. El esquema no garantiza la veracidad pedagógica: el prompt
exige usar la evidencia suministrada y las pruebas con perfiles reales siguen siendo
necesarias para evaluar la calidad del orden y de las explicaciones.

Se envían objetivo, intereses, nivel, habilidades previas, idioma, tiempo semanal y
metadatos de los cursos elegidos. No se envían IDs de usuario ni credenciales Discord.
Descripción, resultados de aprendizaje, habilidades y requisitos se incluyen solo
cuando los metadatos están verificados y no proceden de `inferred-seed-v1`.
Las preferencias y los metadatos se tratan como datos, no como instrucciones.
La solicitud a OpenAI incluye `store: false`. Groq no admite ese parámetro y no se envía.

## Respuesta del endpoint

Conserva `method`, `goal`, `explanation` y `courses`, y agrega:

- `refinementStatus`: `applied` si se aplicó IA.
- `model`: modelo configurado utilizado cuando la respuesta fue aplicada; `null` en caso contrario.

Con IA aplicada, `method` es `semantic-groq-v2` o `semantic-openai-v2`. Si no se aplica, se conservan
el método, orden, razones y explicación originales y se devuelve HTTP 200 con uno de:

| refinementStatus | Motivo |
| --- | --- |
| `no_courses` | La búsqueda no produjo cursos; no se llama al proveedor. |
| `not_configured` | No hay clave del proveedor registrado; no se llama a la API. |
| `catalog_changed` | Un curso seleccionado ya no está disponible. |
| `provider_error` | El proveedor devolvió un estado HTTP no exitoso, incluido 429. |
| `provider_unavailable` | Error de conexión con el proveedor. |
| `timeout` | El proveedor no respondió dentro del tiempo límite. |
| `incomplete_response` | El proveedor no completó la respuesta. |
| `refused` | El modelo rechazó la solicitud. |
| `invalid_response` | La respuesta no cumplió el contrato o alteró el conjunto de cursos. |

La cancelación del cliente se propaga. Los errores previos de preferencias y
embeddings mantienen los códigos 409/502/503 del endpoint semántico original.

Referencias: [Structured Outputs de OpenAI](https://developers.openai.com/api/docs/guides/structured-outputs)
y [Structured Outputs de Groq](https://console.groq.com/docs/structured-outputs).

## Verificación local

```powershell
dotnet test tests/CodeQuest2026.Server.Tests
```

Las pruebas de los clientes OpenAI y Groq usan HTTP simulado y no consumen crédito ni requieren
una clave real. Cubren esquema enviado, orden, conservación de datos, IDs inventados
o duplicados, respuestas inválidas, rechazo, timeout, cancelación y errores del proveedor.
También se prueba el registro de Groq y una implementación de ejemplo
del contrato sin dependencias de ninguno de los proveedores reales.
