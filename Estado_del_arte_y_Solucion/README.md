# Hito 2: Estado del Arte y Propuesta de Solución (IEEE)

Este directorio contiene los entregables del **Hito 2** del proyecto ("State of the Art and Solution Proposal"), redactados bajo el formato formal IEEE Conference en inglés, junto con las pautas de evaluación y la auditoría bibliográfica.

---

## Contenido del Directorio

| Archivo | Formato | Descripción |
| :--- | :--- | :--- |
| **`state_of_the_art_solution_ieee.tex`** | LaTeX (IEEEtran) | Código fuente formal del paper en inglés (6 páginas, dos columnas, 10pt) con 18 referencias bibliográficas. |
| **`state_of_the_art_solution_ieee.pdf`** | PDF | Paper compilado listo para entrega y evaluación por parte del profesor. |
| **`IEEEtran.cls`** | LaTeX Class | Clase de documento oficial de IEEE v1.8b para conferencias científicas. |
| **`auditoria_papers_y_apis.md`** | Markdown | Matriz técnica de auditoría de los 18 artículos científicos (DOIs, OpenAlex, CORE A/B), catálogo de 6 fuentes de datos/APIs y respuestas formales a las preguntas del profesor. |
| **`Paper_instructions.md`** | Markdown | Rúbrica oficial y pauta de evaluación entregada por el profesor para la redacción de este paper. |

---

## Cómo Compilar

Para recompilar el paper de IEEE de forma aislada:
```bash
cd Estado_del_arte_y_Solucion
pdflatex state_of_the_art_solution_ieee.tex
```
O desde la raíz del proyecto ejecutando `./compile_all.sh`.
