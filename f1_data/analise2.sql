-- Top 10 Construtores mais Vitoriosos

SELECT
      t2.name AS equipe,
      count(*) AS corridasGanhas

FROM race_data AS t1 

LEFT JOIN constructor AS t2
ON t1.constructor_id = t2.id

WHERE t1.type LIKE 'RACE_RESULT'
AND t1.position_number = 1 

GROUP BY t2.name
ORDER BY corridasGanhas DESC

LIMIT 10 


