-- Top 10 Circuitos com mais Corridas Realizadas

SELECT
     
      t2.circuit_id AS circuitos,
      count(DISTINCT t1.race_id) AS qtdCorridas

FROM race_data AS t1

LEFT JOIN race AS t2 
ON t1.race_id = t2.id

WHERE t1.type LIKE  'RACE%'
GROUP BY t2.circuit_id
ORDER BY qtdCorridas DESC

LIMIT 10 