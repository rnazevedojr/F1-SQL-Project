F1 Insights: Uma Análise Histórica de Performance e Estratégia (1950-2026)
Visão Geral do Projeto

Este projeto de portfólio demonstra proficiência em SQL através de uma análise aprofundada dos dados históricos da Fórmula 1. Utilizando um banco de dados relacional abrangente, o objetivo é extrair insights sobre a dominância de pilotos e construtores, a importância da estratégia de largada, a consistência de performance e a influência da nacionalidade no esporte. O projeto é ideal para profissionais em transição de carreira para a área de dados, destacando habilidades em modelagem, consulta e interpretação de dados.

Dataset

O projeto utiliza o F1DB, um banco de dados open-source que consolida informações da Ergast Developer API e documentos oficiais da FIA. Este dataset oferece uma visão detalhada da Fórmula 1 desde 1950 até os dias atuais, incluindo dados sobre pilotos, construtores, circuitos, corridas e resultados detalhados de cada sessão.

Estrutura do Repositório

O repositório está organizado para facilitar a navegação e compreensão:

f1-sql-project/
├── f1_data/
│   ├── f1db.db           # Banco de dados SQLite (F1DB)
│   ├── analise1.sql      # Top 10 pilotos com mais vitórias
│   ├── analise2.sql      # Top 10 construtores com mais vitórias
│   ├── analise3.sql      # Top 10 circuitos com mais corridas
│   ├── analise4.sql      # Fator pole position: conversão em vitória
│   ├── analise5.sql      # Dominância por década
│   ├── analise6.sql      # Consistência dos pilotos (média de pontos por GP)
│   ├── analise7.sql      # Ranking de nações vitoriosas
│   └── analise8.sql      # Domínio caseiro: vitórias no próprio país
├── images/               # Visualizações geradas a partir das análises
│   ├── top_drivers.png
│   ├── top_constructors.png
│   └── top_countries.png
└── README.md             # Este arquivo
Ferramentas Utilizadas
Banco de Dados: SQLite
Linguagem: SQL (padrão ANSI SQL)
Ambiente: VS Code com extensão SQLite
Visualização: Python (Matplotlib/Pandas) para geração de gráficos
Análises e Insights Chave

As queries SQL foram desenvolvidas para responder a perguntas analíticas específicas, com foco em extrair insights valiosos:

1. Top 10 Pilotos com Mais Vitórias

📄 Arquivo: f1_data/analise1.sql

Esta análise identifica os pilotos mais vitoriosos na história da Fórmula 1, considerando apenas os resultados oficiais das corridas (Grand Prix).

Query SQL:

sql
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
LIMIT 10;

Insight: A análise revela a dominância de pilotos como Lewis Hamilton e Michael Schumacher, que acumularam um número impressionante de vitórias ao longo de suas carreiras, estabelecendo-se como lendas do esporte.

Visualização:

Top 10 Pilotos com Mais Vitórias

2. Top 10 Construtores (Equipes) com Mais Vitórias

📄 Arquivo: f1_data/analise2.sql

Esta query ranqueia as equipes com base no número total de vitórias em Grandes Prêmios, destacando as dinastias da F1.

Query SQL:

sql
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
LIMIT 10;

Insight: Equipes como Ferrari, McLaren e Mercedes demonstram uma consistência histórica notável, com a Ferrari liderando com o maior número de vitórias, refletindo sua longa e rica trajetória na categoria. A precisão do filtro type LIKE 'RACE_RESULT' garante que apenas vitórias em corridas principais sejam consideradas, evitando a contagem de sessões de treino ou qualificação.

Visualização:

Top 10 Construtores com Mais Vitórias

3. Top 10 Circuitos com Mais Corridas Realizadas

📄 Arquivo: f1_data/analise3.sql

Esta análise identifica os circuitos mais tradicionais e frequentemente utilizados na história da Fórmula 1.

Query SQL:

sql
SELECT
      t2.circuit_id AS circuitos,
      count(DISTINCT t1.race_id) AS qtdCorridas
FROM race_data AS t1
LEFT JOIN race AS t2 
ON t1.race_id = t2.id
WHERE t1.type LIKE  'RACE%'
GROUP BY t2.circuit_id
ORDER BY qtdCorridas DESC
LIMIT 10;

Insight: Circuitos como Monza e Silverstone frequentemente aparecem no topo, destacando a longevidade e a importância histórica de certas pistas no calendário da F1. O uso de COUNT(DISTINCT t1.race_id) garante que cada Grande Prêmio seja contado apenas uma vez, independentemente do número de pilotos ou registros na race_data.

4. O "Fator Pole Position": Taxa de Conversão em Vitória

📄 Arquivo: f1_data/analise4.sql

Esta análise calcula a porcentagem de vezes que um piloto que largou na pole position conseguiu vencer a corrida, fornecendo um insight sobre a importância da posição de largada.

Query SQL:

sql
SELECT 
     COUNT(*) AS total_corridas,
     SUM(CASE WHEN race_grid_position_number = 1 AND position_number = 1 THEN 1 ELSE 0 END) AS vitorias_do_pole,
     ROUND(
        CAST(SUM(CASE WHEN race_grid_position_number = 1 AND position_number = 1 THEN 1 ELSE 0 END) AS FLOAT) 
        / COUNT(*) * 100, 2
     ) AS taxa_conversao     
FROM race_data
WHERE type = 'RACE_RESULT'
AND race_grid_position_number = 1;

Insight: A taxa de conversão de pole position em vitória geralmente varia entre 40-45%, indicando que, embora largar na frente seja uma vantagem significativa, a vitória não é garantida e outros fatores como estratégia de corrida e performance do carro são cruciais. A utilização de CAST(... AS FLOAT) garante a precisão decimal no cálculo.

5. Dominância por Era: Os Maiores Construtores de Cada Década

📄 Arquivo: f1_data/analise5.sql

Esta análise identifica os construtores mais dominantes em cada década da história da Fórmula 1, revelando os ciclos de superioridade técnica.

Query SQL:

sql
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
ORDER BY A.decada ASC;

Insight: A história da F1 é marcada por eras de dominância, onde equipes como Ferrari, McLaren e Mercedes estabeleceram longos períodos de superioridade, refletindo a evolução tecnológica e estratégica. O uso de CTEs (WITH) organiza a lógica complexa em etapas claras e legíveis.

6. Média de Pontos por GP: Top 10 Pilotos Mais Consistentes

📄 Arquivo: f1_data/analise6.sql

Esta análise avalia a consistência dos pilotos ao longo de suas carreiras, calculando a média de pontos por Grande Prêmio, considerando apenas pilotos com um número mínimo de participações para garantir relevância estatística.

Query SQL:

sql
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
LIMIT 10;

Insight: Pilotos da era moderna tendem a ter médias de pontos mais altas devido ao sistema de pontuação atual, mas a análise ainda destaca a consistência de lendas que conseguiram pontuar regularmente em suas épocas. O filtro t2.year > '2010' foca na era moderna de pontuação, e cc.qtdCorridas >= 3 garante a relevância estatística.

7. Ranking de Nações Vitoriosas: Top 10 Países com Mais Vitórias Acumuladas

📄 Arquivo: f1_data/analise7.sql

Esta análise explora quais países produziram os pilotos mais vencedores, conectando a nacionalidade do piloto com suas vitórias.

Query SQL:

sql
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
LIMIT 10;

Visualização:

Top 10 Países com Mais Vitórias

Insight: O Reino Unido se destaca como a nação com o maior número de vitórias, evidenciando sua profunda tradição no automobilismo. Países como Alemanha e Brasil também figuram no topo, graças a pilotos icônicos. A análise direta do country_of_birth_country_id fornece um ranking claro das nações.

8. Domínio Caseiro: Top 10 Pilotos que Mais Venceram em seu Próprio País

📄 Arquivo: f1_data/analise8.sql

Esta análise destaca os pilotos que tiveram mais sucesso em Grandes Prêmios realizados em seu país de origem, celebrando os heróis locais.

Query SQL:

sql
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

Insight: Pilotos como Lewis Hamilton e Alain Prost demonstram um forte desempenho em seus GPs de casa, muitas vezes impulsionados pelo apoio da torcida e familiaridade com o circuito. A comparação direta entre o país de nascimento do piloto e o país do circuito é a chave para esta análise.

Como Rodar o Projeto
Clone o repositório:
bash
    git clone https://github.com/rnazevedojr/f1-sql-project.git
    cd f1-sql-project
Banco de dados: O banco SQLite já está no repositório, em f1_data/f1db.db. Para usar uma versão mais recente, baixe o arquivo f1db-sqlite.zip da última release do F1DB, extraia o .db e substitua o arquivo em f1_data/.
Configure o VS Code (opcional, mas recomendado):
Instale a extensão "SQLite" (de alexcvzz).
Clique com o botão direito em f1_data/f1db.db e selecione "Open Database".
Explore as tabelas no painel "SQLITE EXPLORER".
Execute as queries: Os arquivos analise1.sql a analise8.sql, na pasta f1_data/, contêm as análises. Execute-os no VS Code com a extensão SQLite ou pelo terminal:
bash
    sqlite3 f1_data/f1db.db < f1_data/analise1.sql
Conclusão

Este projeto demonstra a capacidade de utilizar SQL para extrair insights significativos de um conjunto de dados complexo e real. As análises apresentadas cobrem desde a dominância histórica até a performance pontual de pilotos e equipes, utilizando técnicas como JOINs múltiplos, CTEs, funções de agregação e manipulação de strings. A organização do repositório e a clareza da documentação visam facilitar a compreensão e a replicação, tornando-o um ativo valioso para um portfólio na área de dados.

Autor

Railson Nogueira: GitHub · LinkedIn
