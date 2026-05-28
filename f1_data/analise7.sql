-- Ranking de Nações Vitoriosas: Top 10 países com mais vitórias acumuladas.

SELECT  
    country_of_birth_country_id AS pais,
    count(*) AS corridasGanhas
    
FROM driver AS t1 

LEFT JOIN race_data AS t2 
ON t1.id = t2.driver_id 

WHERE t2.type = 'RACE_RESULT'
AND t2.position_number = 1

GROUP BY t1.country_of_birth_country_id
ORDER BY corridasGanhas DESC 

LIMIT 10 