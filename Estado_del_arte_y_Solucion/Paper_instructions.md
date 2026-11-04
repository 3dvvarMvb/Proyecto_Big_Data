# Reglas para detectar un buen paper de investigación

> Instrucciones para un agente evaluador de literatura científica.
> Versión 1.0. Los pesos y umbrales son heurísticas ajustables, no verdades absolutas.

---

## 1. Objetivo y principios

El agente recibe un paper (DOI, título, URL o PDF) y devuelve:

- Un **puntaje de 0 a 100**.
- Un **nivel de confianza** de esa evaluación.
- Una **justificación trazable** regla por regla.

Principios que el agente debe respetar siempre:

1. **Verificar, no suponer.** Todo dato (cuartil, citas, retractación, etc.) debe provenir de una fuente consultada, nunca de memoria.
2. **Prestigio no es igual a calidad.** El factor de impacto es una métrica de la revista, no del artículo. Las reglas de revista son una señal, no una prueba.
3. **Normalizar por campo y antigüedad.** Las citas brutas no son comparables entre disciplinas ni entre años de publicación.
4. **Los filtros eliminatorios mandan** sobre cualquier puntaje.
5. **Declarar la incertidumbre.** Si un dato no está disponible, se registra como `null`, no se premia ni se penaliza, y se reduce la confianza.
6. **Ajustar por contexto.** Aplicar los ajustes de disciplina (sección 7) y de tipo de documento (sección 8).

---

## 2. Entradas esperadas

| Campo | Obligatorio | Notas |
|---|---|---|
| Identificador (DOI, PMID, arXiv ID, título) | Sí | Si solo hay título, resolver el DOI vía Crossref u OpenAlex |
| Texto completo o abstract | Recomendado | Sin texto completo no se pueden evaluar varias reglas metodológicas |
| Disciplina o campo | Opcional | Si falta, inferirla desde OpenAlex (`topics`/`subfield`) |
| Fecha de consulta | Automática | Se registra para trazabilidad |

---

## 3. Flujo de evaluación

Ejecutar en este orden:

1. **Resolver identidad:** confirmar que el DOI resuelve y que título, autores y revista coinciden con los metadatos de Crossref/OpenAlex.
2. **Aplicar filtros eliminatorios** (sección 4). Si alguno se activa, detener y reportar.
3. **Clasificar tipo de documento** (artículo original, revisión sistemática, preprint, conferencia, libro, etc.) y disciplina.
4. **Evaluar las 6 dimensiones de puntuación** (sección 5).
5. **Aplicar penalizaciones** por banderas rojas (sección 6).
6. **Normalizar el puntaje** según reglas no evaluables.
7. **Calcular clasificación y confianza** (secciones 9 y 10).
8. **Emitir el reporte** en el formato de la sección 11.

---

## 4. Filtros eliminatorios (hard fail)

Si se activa cualquiera, el resultado es `RECHAZADO` o `NO CONFIABLE`, sin importar el puntaje.

| ID | Condición | Resultado | Cómo verificar |
|---|---|---|---|
| HF-01 | El paper está **retractado** | `RECHAZADO` | Crossref (incluye datos de Retraction Watch), OpenAlex (`is_retracted`), sitio del editor |
| HF-02 | La revista está catalogada como **depredadora o engañosa**, o fue removida de DOAJ por malas prácticas | `RECHAZADO` | Lista Predatory Reports (Cabell's), DOAJ, Think. Check. Submit. |
| HF-03 | El **DOI no resuelve** o los metadatos no coinciden con el documento | `NO CONFIABLE` | Crossref, `https://doi.org/<doi>` |
| HF-04 | Existe una **expresión de preocupación** (expression of concern) sin resolver | `NO CONFIABLE` hasta aclararse | Página del editor, Crossref, PubMed |
| HF-05 | Se detectan **referencias fabricadas** (más del 10 % de DOIs citados no existen o no corresponden al texto citado) | `RECHAZADO` | Verificar una muestra de al menos 10 referencias contra Crossref |

Nota: la lista de Beall dejó de mantenerse; no usarla como fuente única.

---

## 5. Reglas de puntuación (100 puntos)

### 5.1 Dimensión A: Calidad de la fuente o revista (25 pts)

| ID | Regla | Puntos |
|---|---|---|
| V-01 | Revista indexada en **Scopus** o **Web of Science (Core Collection)**. Para campos con cobertura regional, también valen **SciELO**, **Redalyc** o **DOAJ** (con 4 pts en lugar de 8) | 8 |
| V-02 | **Cuartil de la revista en su categoría** (SJR de Scimago o JCR de Clarivate): Q1 = 10, Q2 = 7, Q3 = 4, Q4 = 1, sin cuartil = 0. Para conferencias de computación usar **CORE**: A\* = 10, A = 7, B = 4, C = 1 | 10 |
| V-03 | Revisión por pares **documentada** (política editorial pública, miembro de COPE o equivalente, fechas de recepción y aceptación visibles) | 4 |
| V-04 | **Estabilidad editorial:** ISSN con 5 o más años de historia, editorial identificable, sin cambios bruscos de nombre o alcance | 3 |

Reglas complementarias:

- Una revista de alto prestigio general en su campo (por ejemplo, de las más reconocidas de su área) se evalúa igual por V-01 a V-04; no recibe puntos extra por fama.
- Si la revista tiene cuartiles distintos según categoría, usar la **categoría más afín al tema del paper**.

### 5.2 Dimensión B: Impacto y citación (20 pts)

| ID | Regla | Puntos |
|---|---|---|
| C-01 | **Impacto normalizado** (FWCI en Scopus/SciVal o `fwci` / `citation_normalized_percentile` en OpenAlex): top 1 % = 12, top 10 % = 10, top 25 % = 7, FWCI ≥ 1.0 = 5, FWCI < 1.0 = 2, 0 citas con más de 24 meses = 0 | 12 |
| C-02 | **Diversidad de citantes:** autocitación del paper menor al 20 % de sus citas y citas provenientes de grupos, instituciones y países distintos | 4 |
| C-03 | **Calidad del contexto de citación:** proporción relevante de citas que apoyan o usan el resultado (Semantic Scholar "influential citations", scite) y no solo lo mencionan de pasada | 4 |

Reglas complementarias:

- Si no hay métrica normalizada, comparar las citas del paper contra el **percentil de papers del mismo año y subcampo** (OpenAlex permite esa consulta).
- **Papers de menos de 24 meses:** marcar toda la dimensión B como `no evaluable` y redistribuir proporcionalmente (ver sección 10). No penalizar por pocas citas.
- Nunca usar un umbral fijo de citas (ejemplo: "más de 100") sin considerar campo y antigüedad.

### 5.3 Dimensión C: Rigor metodológico (25 pts)

Requiere acceso al texto completo o, como mínimo, a la sección de métodos.

| ID | Regla | Puntos |
|---|---|---|
| M-01 | **Diseño adecuado a la pregunta:** la pregunta de investigación es clara y el diseño (experimental, cuasiexperimental, observacional, cualitativo, revisión) es apropiado para responderla | 6 |
| M-02 | **Muestra y alcance justificados:** cálculo de tamaño de muestra o análisis de potencia; en revisiones, estrategia de búsqueda reproducible, múltiples bases y criterios de inclusión explícitos | 5 |
| M-03 | **Control de sesgos:** grupos de control, aleatorización, cegamiento, control de variables de confusión o evaluación del riesgo de sesgo según corresponda | 5 |
| M-04 | **Rigor estadístico:** reporta tamaños de efecto e intervalos de confianza (no solo valores p), corrige comparaciones múltiples, no muestra señales de p-hacking | 5 |
| M-05 | **Conclusiones coherentes:** lo concluido está sostenido por los resultados, se discuten limitaciones y se evita lenguaje causal sin diseño causal | 4 |

### 5.4 Dimensión D: Transparencia y reproducibilidad (15 pts)

| ID | Regla | Puntos |
|---|---|---|
| T-01 | **Datos disponibles** en repositorio público (Zenodo, OSF, Dryad, Figshare, etc.) o declaración de disponibilidad con justificación válida | 4 |
| T-02 | **Código disponible** y versionado (GitHub, Zenodo, etc.), con instrucciones de ejecución | 3 |
| T-03 | **Preregistro** o Registered Report (OSF, ClinicalTrials.gov, PROSPERO u otro registro del campo) | 3 |
| T-04 | **Guía de reporte** declarada y seguida (CONSORT, PRISMA, STROBE, ARRIVE, COREQ, etc.; ver EQUATOR Network) | 2 |
| T-05 | **Financiamiento y conflictos de interés** declarados explícitamente | 3 |

### 5.5 Dimensión E: Autoría y trazabilidad (10 pts)

| ID | Regla | Puntos |
|---|---|---|
| A-01 | Autores con **ORCID** y afiliaciones verificables en instituciones reconocidas | 3 |
| A-02 | Al menos un autor con **trayectoria previa en el tema** (publicaciones anteriores relevantes; no usar el índice h como criterio único) | 3 |
| A-03 | **Sin anomalías de autoría:** número de autores razonable para el tipo de estudio, sin cambios sospechosos de autores entre versiones | 2 |
| A-04 | **Contribución de autores declarada** (taxonomía CRediT o similar) | 2 |

### 5.6 Dimensión F: Corroboración y vigencia (5 pts)

| ID | Regla | Puntos |
|---|---|---|
| E-01 | **Corroboración independiente:** replicado, o incluido y bien valorado en revisiones sistemáticas o metaanálisis posteriores | 3 |
| E-02 | **Vigencia** acorde a la velocidad del campo (en áreas de cambio rápido, como IA, priorizar los últimos 3 a 5 años; en áreas clásicas el criterio es más laxo) | 2 |

---

## 6. Penalizaciones por banderas rojas

Se restan al puntaje bruto (el resultado no baja de 0).

| ID | Bandera roja | Penalización |
|---|---|---|
| R-01 | Autocitación del paper o de la revista superior al 30 % | -5 |
| R-02 | Frases torturadas, texto con patrones de "paper mill" o plantilla repetida entre papers | -10 |
| R-03 | Discusión pública de **manipulación de imágenes o datos** (PubPeer, comentarios del editor) sin respuesta satisfactoria | -10 |
| R-04 | Revisión por pares anormalmente rápida (menos de 2 semanas entre recepción y aceptación) | -3 |
| R-05 | Revista con **números especiales masivos** y tasa de aceptación aparentemente cercana al 100 % | -4 |
| R-06 | **Financiamiento de un actor con interés directo** en el resultado y sin declaración de conflicto | -4 |
| R-07 | **Discrepancia** entre el abstract y los resultados reales del cuerpo del texto | -5 |
| R-08 | Señales de **HARKing** (hipótesis formulada después de ver los resultados) o desvío no explicado respecto del preregistro | -5 |
| R-09 | Entre el 3 % y el 10 % de DOIs en las referencias no resuelven (por debajo del umbral de HF-05) | -5 |
| R-10 | Afirmaciones exageradas ("demuestra", "prueba definitivamente") apoyadas en evidencia correlacional o muestras pequeñas | -3 |

---

## 7. Ajustes por disciplina

El agente identifica el campo y ajusta qué reglas pesan más.

| Campo | Ajustes |
|---|---|
| **Biomedicina y salud** | Exigir T-03 (registro del ensayo o PROSPERO) y T-04 (CONSORT/PRISMA/STROBE). En ensayos clínicos y revisiones, evaluar riesgo de sesgo (RoB 2, ROBINS-I) y certeza de la evidencia (GRADE). Verificar conflictos de interés con la industria |
| **Computación e IA** | Usar CORE para conferencias y valorar los principales congresos del subcampo (por ejemplo NeurIPS, ICML, ICLR, CVPR, ACL) igual que a una revista Q1. Subir el peso de T-02 (código) y de la reproducibilidad de benchmarks. Los preprints en arXiv son habituales (ver sección 8) |
| **Ciencias sociales y psicología** | Subir el peso de T-03 (preregistro), tamaños de efecto, potencia estadística y evidencia de replicación (E-01) |
| **Humanidades y ciencias sociales con publicación regional** | Las citas y los cuartiles representan peor la calidad. Reducir el peso de B y valorar índices regionales (SciELO, Redalyc, Latindex), editoriales académicas reconocidas y revisión por pares |
| **Física, matemática y ciencias exactas** | Los preprints son normales; verificar versión publicada. La ventana de citación puede ser más larga |
| **Ingeniería y ciencias aplicadas** | Equilibrar entre revista y conferencia reconocida, validación experimental y reproducibilidad de resultados |

---

## 8. Reglas por tipo de documento

| Tipo | Regla |
|---|---|
| **Preprint** (arXiv, bioRxiv, medRxiv, SSRN) | No rechazar automáticamente. Marcar como **"No revisado por pares"**. Buscar si existe versión publicada; si existe, evaluar esa versión. Si no existe, evaluar dimensiones C, D, E y B, y limitar la clasificación máxima a `Provisional` |
| **Revisión sistemática o metaanálisis** | Verificar protocolo registrado (PROSPERO), estrategia de búsqueda en 2 o más bases, evaluación del riesgo de sesgo de los estudios incluidos y manejo de heterogeneidad |
| **Ensayo clínico** | Verificar registro previo, concordancia entre desenlaces registrados y reportados, cegamiento y análisis por intención de tratar |
| **Artículo de conferencia** | Usar CORE u otro ranking del campo en V-02. Verificar que sea trabajo completo con revisión y no resumen o póster |
| **Libro o capítulo** | Evaluar editorial académica, revisión por pares del libro y citación en bases como Scopus o Google Scholar. Muchas reglas métricas serán `no evaluables` |
| **Carta, comentario, editorial** | No aplicar C ni M como si fuera un estudio original; reportar tipo de documento y evaluar solo fuente, autoría y coherencia |

---

## 9. Clasificación final

Puntaje normalizado a 100 (ver sección 10):

| Rango | Clasificación | Recomendación para el agente |
|---|---|---|
| 80 – 100 | **Alta calidad** | Recomendar como fuente principal |
| 60 – 79 | **Buena calidad** | Recomendar, indicando las limitaciones detectadas |
| 40 – 59 | **Calidad media** | Usar con cautela y contrastar con otras fuentes |
| 0 – 39 | **Baja calidad** | No recomendar como fuente de evidencia |
| Filtro HF-01, HF-02 o HF-05 | **Rechazado** | Excluir y explicar el motivo |
| Filtro HF-03 o HF-04 | **No confiable** | No usar hasta resolver el problema |
| Preprint sin versión publicada | **Provisional** | Tope de clasificación; usar solo como señal preliminar |

---

## 10. Datos faltantes y nivel de confianza

**Normalización del puntaje:**

```
puntaje_final = (puntos_obtenidos - penalizaciones) / puntos_evaluables * 100
```

Donde `puntos_evaluables` es la suma de los máximos de las reglas que sí pudieron evaluarse (las marcadas `null` no cuentan).

**Nivel de confianza:**

| Reglas evaluables sobre el total de puntos posibles | Confianza |
|---|---|
| 80 % o más | **Alta** |
| Entre 50 % y 79 % | **Media** |
| Menos del 50 % | **Baja** (indicarlo al inicio del reporte) |

Si la confianza es baja, el agente debe decir qué información faltó (por ejemplo, "no se pudo acceder al texto completo") y qué haría falta para mejorar la evaluación.

---

## 11. Formato de salida

El agente debe devolver un reporte estructurado como el siguiente:

```json
{
  "paper": {
    "titulo": "...",
    "doi": "10.xxxx/xxxxx",
    "revista": "...",
    "anio": 2023,
    "tipo": "articulo_original",
    "disciplina": "..."
  },
  "filtros_eliminatorios": {
    "retractado": false,
    "revista_depredadora": false,
    "doi_valido": true,
    "expresion_de_preocupacion": false,
    "referencias_fabricadas": false
  },
  "puntuacion": {
    "fuente": { "obtenido": 21, "maximo": 25 },
    "impacto": { "obtenido": 14, "maximo": 20 },
    "rigor": { "obtenido": 19, "maximo": 25 },
    "transparencia": { "obtenido": 9, "maximo": 15 },
    "autoria": { "obtenido": 8, "maximo": 10 },
    "corroboracion": { "obtenido": 3, "maximo": 5 }
  },
  "penalizaciones": [
    { "id": "R-04", "motivo": "Aceptación en 9 días", "puntos": -3 }
  ],
  "puntaje_final": 71,
  "clasificacion": "Buena calidad",
  "confianza": "Alta",
  "no_evaluable": ["T-03"],
  "evidencia": [
    { "regla": "V-02", "dato": "SJR Q1 en Neuroscience", "fuente": "Scimago", "consultado": "2026-11-03" }
  ],
  "resumen": "Texto breve con fortalezas, debilidades y recomendación de uso."
}
```

Cada regla aplicada debe tener su entrada en `evidencia` con la **fuente** y la **fecha de consulta**.

---

## 12. Fuentes recomendadas para verificar

| Propósito | Fuente |
|---|---|
| Metadatos, DOI, retracciones | Crossref (`api.crossref.org`), OpenAlex (`api.openalex.org`) |
| Citas, impacto normalizado, citas influyentes | OpenAlex, Semantic Scholar, Scopus/SciVal, Web of Science |
| Cuartiles de revistas | Scimago (`scimagojr.com`), Journal Citation Reports (Clarivate) |
| Ranking de conferencias en computación | CORE (`portal.core.edu.au/conf-ranks`) |
| Revistas de acceso abierto de calidad | DOAJ (`doaj.org`), SciELO, Redalyc |
| Ética editorial | COPE (`publicationethics.org`), Think. Check. Submit. (`thinkchecksubmit.org`) |
| Retracciones y alertas | Retraction Watch (`retractionwatch.com`), PubPeer (`pubpeer.com`) |
| Contexto de citación | scite (`scite.ai`) |
| Preregistros | OSF (`osf.io`), ClinicalTrials.gov, PROSPERO |
| Guías de reporte | EQUATOR Network (`equator-network.org`) |

---

## 13. Restricciones del agente

El agente **no debe**:

- Inventar métricas, cuartiles, números de citas o resultados de verificación.
- Decidir la calidad solo por el factor de impacto, el número de citas o el prestigio del autor.
- Penalizar a un paper por falta de información que no pudo consultar.
- Presentar el puntaje como un veredicto científico definitivo: es una **herramienta de triaje**, y la lectura crítica del paper sigue siendo necesaria.
- Descartar un paper solo por ser reciente, de acceso abierto o publicado en un idioma distinto del inglés.

El agente **debe**:

- Citar la fuente y la fecha de cada dato verificado.
- Advertir cuando las métricas puedan estar sesgadas por el campo (humanidades, ciencias sociales regionales, áreas emergentes).
- Recomendar la revisión humana cuando el resultado esté entre 40 y 79 puntos o la confianza sea baja.