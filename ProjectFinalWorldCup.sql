-- Crear la tabla Jugadores
CREATE TABLE Jugadores (
    PlayerID INT PRIMARY KEY,
    PlayerName VARCHAR(255), 
	Nationality VARCHAR(255)
);
-- Crear la tabla Temporadas
CREATE TABLE Temporadas (
    SeasonID INT PRIMARY KEY,
    SeasonYear INT
);
-- Crear la tabla StatJugadorTemporada
CREATE TABLE StatJugadorTemporada (
    PlayerSeasonID INT PRIMARY KEY,
    PlayerID INT,
    SeasonID INT,
    Goals_z DECIMAL(10, 2),
    xG_z DECIMAL(10, 2),
    Crosses_z DECIMAL(10, 2),
    BoxTouches_z DECIMAL(10, 2),
    Passes_z DECIMAL(10, 2),
    FOREIGN KEY (PlayerID) REFERENCES Jugadores(PlayerID),
    FOREIGN KEY (SeasonID) REFERENCES Temporadas(SeasonID)
);
-- Crear la tabla StatCreacionJuegoTemporada
CREATE TABLE StatCreacionJuegoTemporada (
    PlayerSeasonID INT PRIMARY KEY,
    ProgPasses_z DECIMAL(10, 2),
    TakeOns_z DECIMAL(10, 2),
    ProgRuns_z DECIMAL(10, 2),
    FOREIGN KEY (PlayerSeasonID) REFERENCES StatJugadorTemporada(PlayerSeasonID)
);
-- Crear la tabla StatDefensaTemporada
CREATE TABLE StatDefensaTemporada (
    PlayerSeasonID INT PRIMARY KEY,
    Tackles_z DECIMAL(10, 2),
    Interceptions_z DECIMAL(10, 2),
    Clearances_z DECIMAL(10, 2),
    Blocks_z DECIMAL(10, 2),
    FOREIGN KEY (PlayerSeasonID) REFERENCES StatJugadorTemporada(PlayerSeasonID)
);
-- Crear la tabla StatFisicasDisciplinaTemporada
CREATE TABLE StatFisicasDisciplinaTemporada (
    PlayerSeasonID INT PRIMARY KEY,
    Aerials_z DECIMAL(10, 2),
    Fouls_z DECIMAL(10, 2),
    Fouled_z DECIMAL(10, 2),
    nSxG_z DECIMAL(10, 2),
    FOREIGN KEY (PlayerSeasonID) REFERENCES StatJugadorTemporada(PlayerSeasonID)
);

-- Creando columna ID para la tabla fuente
ALTER TABLE dbo.world_cup_comparisons
ADD wcID INT;
GO
--Agregendo IDs para la tabla dbo.world_cup_comparisons
WITH NumberedWC AS (
    SELECT wcID,
           ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NewDataID
    FROM dbo.world_cup_comparisons
)
UPDATE NumberedWC
SET wcID = NewDataID;
--Agregano datos de los jugadores
INSERT INTO Jugadores (PlayerID, PlayerName, Nationality)
SELECT dbo.world_cup_comparisons.wcID, dbo.world_cup_comparisons.player, dbo.world_cup_comparisons.team
FROM dbo.world_cup_comparisons;
-- Agregando datos Temporadas
INSERT INTO Temporadas (SeasonID , SeasonYear)
SELECT dbo.world_cup_comparisons.wcID, dbo.world_cup_comparisons.season
FROM dbo.world_cup_comparisons;
-- Agregando datos StatJugadorTemporada
INSERT INTO 
StatJugadorTemporada (PlayerSeasonID , PlayerID, SeasonID, Goals_z, xG_z, Crosses_z, BoxTouches_z, Passes_z)
SELECT 
dbo.world_cup_comparisons.wcID, dbo.world_cup_comparisons.wcID, dbo.world_cup_comparisons.wcID, 
dbo.world_cup_comparisons.goals_z, dbo.world_cup_comparisons.xg_z, dbo.world_cup_comparisons.crosses_z, 
dbo.world_cup_comparisons.boxtouches_z, dbo.world_cup_comparisons.passes_z 
FROM 
dbo.world_cup_comparisons;
-- Agregando datos Temporadas
INSERT INTO StatCreacionJuegoTemporada (PlayerSeasonID , ProgPasses_z, TakeOns_z, ProgRuns_z)
SELECT dbo.world_cup_comparisons.wcID, dbo.world_cup_comparisons.progpasses_z, dbo.world_cup_comparisons.takeons_z, 
dbo.world_cup_comparisons.progruns_z
FROM dbo.world_cup_comparisons;
-- Agregando datos StatDefensaTemporada
INSERT INTO StatDefensaTemporada (PlayerSeasonID , Tackles_z, Interceptions_z, Clearances_z, Blocks_z)
SELECT dbo.world_cup_comparisons.wcID, dbo.world_cup_comparisons.tackles_z, dbo.world_cup_comparisons.interceptions_z, 
dbo.world_cup_comparisons.clearances_z, dbo.world_cup_comparisons.blocks_z
FROM dbo.world_cup_comparisons;
-- Agregando datos StatFisicasDisciplinaTemporada
INSERT INTO StatFisicasDisciplinaTemporada (PlayerSeasonID , Aerials_z, Fouls_z, Fouled_z, nSxG_z)
SELECT dbo.world_cup_comparisons.wcID, dbo.world_cup_comparisons.aerials_z, dbo.world_cup_comparisons.fouls_z, 
dbo.world_cup_comparisons.fouled_z, dbo.world_cup_comparisons.nsxg_z
FROM dbo.world_cup_comparisons;


--PREGUNTAS

-- Rank de los mejores promedios goleadores en cada temporada de la Copa del Mundo
WITH MaxGoleadoresPorTemporada AS (
    SELECT
        T.SeasonYear AS Temporada,
        J.PlayerName AS Jugador,
        SUM(E.Goals_z) AS Goles
    FROM StatJugadorTemporada E
    INNER JOIN Jugadores J ON E.PlayerID = J.PlayerID
    INNER JOIN Temporadas T ON E.SeasonID = T.SeasonID
    GROUP BY T.SeasonYear, J.PlayerName
),
MaxGoleadorPorTemporada AS (
    SELECT
        Temporada,
        Jugador,
        Goles,
        RANK() OVER (PARTITION BY Temporada ORDER BY Goles DESC) AS Ranking
    FROM MaxGoleadoresPorTemporada
)
SELECT
    Temporada,
    Jugador,
    Goles
FROM MaxGoleadorPorTemporada
WHERE Ranking = 1
ORDER BY Goles DESC;


-- Top 5 selecciones con el mayor promedio de gol en todas las ediciones del mundial
SELECT TOP 5 J.Nationality AS Equipo, SUM(E.Goals_z) AS TotalGoles
FROM StatJugadorTemporada E
INNER JOIN Jugadores J ON E.PlayerID = J.PlayerID
GROUP BY J.Nationality
ORDER BY TotalGoles DESC


--  �Cu�les son los 10 jugadores con el mejor promedio de bloqueos en la historia de la Copa del Mundo?
SELECT TOP 10 J.PlayerName AS Jugador, SUM(E.Blocks_z) AS TotalBloqueos
FROM StatDefensaTemporada E
INNER JOIN Jugadores J ON E.PlayerSeasonID = J.PlayerID
GROUP BY J.PlayerName
ORDER BY TotalBloqueos DESC;

-- �Cu�l es la nacionalidad cuyos jugadores han recibido la mayor cantidad de faltas en todas las ediciones de la Copa del Mundo?
SELECT TOP 10 J.Nationality AS Nacionalidad, SUM(E.Fouled_z) AS TotalFaltasRecibidas
FROM StatFisicasDisciplinaTemporada E
INNER JOIN Jugadores J ON E.PlayerSeasonID = J.PlayerID
GROUP BY J.Nationality
ORDER BY TotalFaltasRecibidas DESC;



-- �Cu�l es el jugador que ha tenido el mejor desempe�o en t�rminos de regates y pases progresivos combinados en la historia de la Copa del Mundo, considerando solo a los jugadores de equipos que llegaron a la final del torneo?
WITH EquiposFinalistas AS (
    SELECT DISTINCT T.SeasonYear, J.Nationality
    FROM StatJugadorTemporada E
    INNER JOIN Jugadores J ON E.PlayerID = J.PlayerID
    INNER JOIN Temporadas T ON E.SeasonID = T.SeasonID
    WHERE T.SeasonYear >= 1990
),
DesempenoJugadores AS (
    SELECT
        J.PlayerName,
        T.SeasonYear,
        SUM(E.Takeons_z + E.ProgPasses_z) AS TotalRegatesYProgresivos
    FROM StatCreacionJuegoTemporada E
    INNER JOIN Jugadores J ON E.PlayerSeasonID = J.PlayerID
    INNER JOIN Temporadas T ON E.PlayerSeasonID = T.SeasonID
    WHERE T.SeasonYear >= 1990
    GROUP BY J.PlayerName, T.SeasonYear
),
RankingDesempeno AS (
    SELECT
        DJ.PlayerName,
        DJ.SeasonYear,
        DJ.TotalRegatesYProgresivos,
        RANK() OVER (PARTITION BY DJ.SeasonYear ORDER BY DJ.TotalRegatesYProgresivos DESC) AS Ranking
    FROM DesempenoJugadores DJ
    INNER JOIN EquiposFinalistas EF ON DJ.SeasonYear = EF.SeasonYear AND DJ.PlayerName 
	IN (SELECT J.PlayerName FROM Jugadores J WHERE J.Nationality = EF.Nationality)
)
SELECT
    RD.PlayerName AS MejorJugador,
    RD.SeasonYear AS Temporada,
    RD.TotalRegatesYProgresivos AS RegatesYProgresivos
FROM RankingDesempeno RD
WHERE RD.Ranking = 1
ORDER BY RD.TotalRegatesYProgresivos DESC;

-- Vista1

CREATE VIEW RendimientoPromedioJugadoresPorTemporada AS
SELECT
    T.SeasonYear,
    AVG(SJT.Goals_z) AS PromedioGoles,
    AVG(SJT.Passes_z) AS PromedioPases,
    AVG(SCT.TakeOns_z) AS PromedioRegates
FROM Temporadas T
INNER JOIN StatJugadorTemporada SJT ON T.SeasonID = SJT.SeasonID
INNER JOIN StatCreacionJuegoTemporada SCT ON SJT.PlayerSeasonID = SCT.PlayerSeasonID
GROUP BY T.SeasonYear;

SELECT * FROM RendimientoPromedioJugadoresPorTemporada;

-- Vista2
CREATE VIEW EstadisticasDefensaPorNacionalidad AS
SELECT
    J.Nationality,
    AVG(SDT.Tackles_z) AS PromedioTackles,
    AVG(SDT.Interceptions_z) AS PromedioIntercepciones,
    AVG(SDT.Clearances_z) AS PromedioClearances,
    AVG(SDT.Blocks_z) AS PromedioBlocks
FROM Jugadores J
INNER JOIN StatDefensaTemporada SDT ON J.PlayerID = SDT.PlayerSeasonID
GROUP BY J.Nationality;
SELECT * FROM EstadisticasDefensaPorNacionalidad;