-- Dominância por Era: Quem foram os "Donos" das décadas?
-- Pergunta: Quais construtores dominaram cada período da história? EX 2010-2020


WITH vitorias_equipe AS (

     SELECT 
          (t2.year/10 ) * 10 AS decada,
          t3.name AS equipe,
          count(*) AS totalVitorias

     FROM race_data AS t1 

     LEFT JOIN race AS t2 
     ON t1.race_id = t2.id  

     LEFT JOIN constructor AS t3
     ON t1.constructor_id = t3.id 

     WHERE t1.type = 'RACE_RESULT'
     AND t1.position_number = 1

     GROUP BY decada, t3.name

),

maior_vitorias AS (

     SELECT 
          decada,
          max(totalVitorias) AS maximoVitorias

     FROM vitorias_equipe
     GROUP BY decada

)

SELECT 
     A.decada,
     A.equipe,
     A.totalVitorias
     
FROM vitorias_equipe AS A 
JOIN maior_vitorias AS B
ON A.decada = B.decada AND A.totalVitorias = B.maximoVitorias

ORDER BY A.decada ASC 

