# Proyecto World Cup Database

Este proyecto consiste en la creación y gestión de una base de datos denominada "worldcup" a partir del conjunto de datos "FIFA World Cups" disponible en Kaggle. El conjunto de datos original contiene información sobre 5886 estadísticas de jugadores de la Copa del Mundo de la FIFA. A continuación, se detalla la estructura de las tablas creadas a partir de estos datos:

## Tablas de la Base de Datos

### 1. Jugadores

- **Descripción**: Esta tabla contiene información detallada sobre los jugadores que participaron en la Copa del Mundo. Incluye datos como el nombre del jugador, su nacionalidad y otra información relevante.

### 2. Temporadas

- **Descripción**: En esta tabla se registran las temporadas de la Copa del Mundo a lo largo de los años. Cada registro representa un año específico en el que se llevó a cabo el torneo.

### 3. StatJugadorTemporada

- **Descripción**: Esta tabla almacena estadísticas individuales de los jugadores en cada temporada de la Copa del Mundo. Incluye métricas relacionadas con el rendimiento de los jugadores en el torneo, como goles, pases, regates y más.

### 4. StatCreacionJuegoTemporada

- **Descripción**: En esta tabla se registran estadísticas específicas relacionadas con la creación de juego de los jugadores en cada temporada de la Copa del Mundo. Esto puede incluir métricas como pases progresivos y regates.

### 5. StatDefensaTemporada

- **Descripción**: Contiene estadísticas relacionadas con la defensa de los jugadores en cada temporada de la Copa del Mundo. Esto podría incluir métricas como tackles, bloqueos e intercepciones.

### 6. StatFisicasDisciplinaTemporada

- **Descripción**: Esta tabla almacena estadísticas físicas y disciplinarias de los jugadores en cada temporada del torneo. Puede incluir métricas como duelos ganados, faltas cometidas y tarjetas recibidas.

## Fuente de Datos

El conjunto de datos original se obtuvo de la siguiente fuente:
- [FIFA World Cups Dataset](https://www.kaggle.com/datasets/joebeachcapital/fifa-world-cups)

## Anexo

Para obtener más detalles sobre cómo se generaron estas tablas a partir de la fuente de datos original, se puede consultar el anexo adjunto a este README.

Este proyecto de base de datos proporciona una estructura organizada y eficiente para el almacenamiento y consulta de datos relacionados con la Copa del Mundo de la FIFA. Se puede utilizar como recurso valioso para análisis y consultas relacionadas con el rendimiento de los jugadores y las temporadas de la Copa del Mundo.
