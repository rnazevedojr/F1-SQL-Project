-- Domínio Caseiro: Top 10 pilotos que mais venceram em seu próprio país (Ex: Hamilton em Silverstone).

SELECT 
    t2.full_name AS piloto,
    t4.country_id AS pais,
    COUNT(*) AS vitorias_em_casa
FROM race_data AS t1
JOIN driver t2 ON t1.driver_id = t2.id
JOIN race t3 ON t1.race_id = t3.id
JOIN circuit t4 ON t3.circuit_id = t4.id
WHERE t1.type = 'RACE_RESULT' 
  AND t1.position_number = 1
  AND t2.country_of_birth_country_id = t4.country_id
GROUP BY t2.full_name, t4.country_id
ORDER BY vitorias_em_casa DESC
LIMIT 10;






