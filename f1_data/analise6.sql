-- Média de Pontos por GP: Top 10 pilotos mais consistentes nas corridas

WITH pontos_piloto AS (

    SELECT 
        t1.driver_id AS piloto,
        SUM(race_points) AS pontosTotais,
        t2.circuit_id AS GP

    FROM race_data AS t1 

    LEFT JOIN race AS t2 
    ON t1.race_id = t2.id

    WHERE type LIKE  'RACE%'
    AND t2.year > '2010' 

    GROUP BY t1.driver_id, t2.circuit_id
    ORDER BY pontosTotais DESC 

),

corridas_circuito AS (

    SELECT
        t1.driver_id AS piloto, 
        t2.circuit_id AS circuito,
        count(DISTINCT t1.race_id) AS qtdCorridas

    FROM race_data AS t1

    LEFT JOIN race AS t2 
    ON t1.race_id = t2.id

    WHERE type LIKE 'RACE_RESULT'
    GROUP BY piloto, circuito 
    ORDER BY qtdCorridas DESC 

)

SELECT 
    pp.piloto,
    pp.GP,
    cc.qtdCorridas,
    pp.pontosTotais, 
    ROUND(CAST(pp.pontosTotais AS FLOAT) / cc.qtdCorridas, 2 ) AS mediaPontos


FROM pontos_piloto AS pp 

LEFT JOIN corridas_circuito AS cc 
ON pp.piloto = cc.piloto AND pp.GP = cc.circuito

WHERE cc.qtdCorridas >= 3

GROUP BY pp.piloto, pp.GP  
ORDER BY mediaPontos DESC

LIMIT 10

