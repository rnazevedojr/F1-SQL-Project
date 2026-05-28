-- TOP 10 Pilotos com mais Vitorias

SELECT 
      full_name AS nomePiloto,
      count(*) AS corridasGanhas

FROM driver AS t1 

LEFT JOIN race_data AS t2 
ON t1.id = t2.driver_id 

WHERE t2.type = 'RACE_RESULT'
AND t2.position_number = 1

GROUP BY t1.full_name
ORDER BY corridasGanhas DESC 

LIMIT 10


