-- O "Fator Pole Position": Qual a importância de largar na frente?
-- Pergunta: Largar em primeiro garante a vitória? Como isso mudou ao longo do tempo?

SELECT 
     COUNT(*) AS total_corridas,
     SUM(CASE WHEN race_grid_position_number = 1 AND position_number = 1 THEN 1 ELSE 0 END) AS vitorias_do_pole,
     ROUND(
        CAST(SUM(CASE WHEN race_grid_position_number = 1 AND position_number = 1 THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 2
     ) AS taxa_conversao     

FROM race_data

WHERE type = 'RACE_RESULT'
AND race_grid_position_number = 1 
