# Base visual de CODE QUEST

Esta guía corresponde al issue P0-15. Los valores reutilizables viven en `frontend/src/styles/tokens.css`; los componentes base viven en `frontend/src/components/ui`.

## Fundamentos

| Grupo | Referencia |
| --- | --- |
| Fondo | `--cq-color-bg-page` `#171027` |
| Superficie | `--cq-color-bg-surface` `#1C1829` |
| Acción | gradiente entre `--cq-color-action-start` y `--cq-color-action-end` |
| Tipografía de títulos | Space Grotesk 700 |
| Tipografía de contenido | DM Sans 400/500/700 |
| Jerarquía | Display 48/56, H1 32/40, H2 24/32, título de tarjeta 20/28, cuerpo 16/24 |
| Escala | 4, 8, 12, 16, 24, 32, 48 y 64 px |
| Radios | 8 px, 18 px y 999 px |

## Componentes disponibles

`Button` tiene variantes `primary`, `secondary` y `ghost`, además de los estados `hover`, `focus-visible`, `disabled` y `isLoading`.

`CourseCard` recibe título, área, nivel, portada opcional, estado y progreso. Se debe usar para representar cursos del catálogo, no para inventar información del curso.

`BrandLogo` protege el uso de los SVG oficiales: `background="dark"` usa la versión blanca y `background="light"` la negra. Usa `size="compact"` cuando solo haya espacio para el isologo.

`StatusBadge` representa los estados `success`, `warning`, `error` e `info`. El texto del estado sigue siendo obligatorio: el color por sí solo no comunica el resultado.

## Uso

```tsx
import { Button, CourseCard } from '../components/ui';

<CourseCard
  title="Nombre del curso"
  area="Frontend"
  level="Principiante"
  state="in-progress"
  progress={40}
  action={<Button>Continuar</Button>}
/>
```

## Accesibilidad y marca

- El foco visible usa un anillo lavanda de 3 px.
- Los mensajes de éxito, advertencia, error e información deben incluir texto o ícono además del color.
- Los controles tienen una altura mínima de 48 px.
- Los SVG oficiales están en `frontend/src/assets/brand`. Consulta su `README.md` antes de elegir una variante.
