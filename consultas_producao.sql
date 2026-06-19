-- ============================================================
-- ANÁLISE DE PRODUÇÃO INDUSTRIAL
-- Autor: Jhonathan Panisson
-- Descrição: Consultas SQL para análise de OEE, perdas e
--            eficiência produtiva em ambiente industrial
-- ============================================================


-- ------------------------------------------------------------
-- 1. OEE GERAL POR INJETORA
-- ------------------------------------------------------------
SELECT
    injetora,
    ROUND(AVG(disponibilidade) * 100, 2)  AS disponibilidade_pct,
    ROUND(AVG(performance) * 100, 2)      AS performance_pct,
    ROUND(AVG(aproveitamento) * 100, 2)   AS aproveitamento_pct,
    ROUND(AVG(disponibilidade) * AVG(performance) * AVG(aproveitamento) * 100, 2) AS oee_pct
FROM producao
GROUP BY injetora
ORDER BY oee_pct DESC;


-- ------------------------------------------------------------
-- 2. TOP 10 PEÇAS COM MAIOR PERDA FINANCEIRA
-- ------------------------------------------------------------
SELECT
    p.codigo_peca,
    p.descricao,
    SUM(pe.quantidade_perdida)                        AS total_pecas_perdidas,
    ROUND(SUM(pe.quantidade_perdida * p.custo), 2)    AS custo_total_perda
FROM perdas pe
JOIN pecas p ON pe.codigo_peca = p.codigo_peca
GROUP BY p.codigo_peca, p.descricao
ORDER BY custo_total_perda DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 3. ANÁLISE DE PARADAS POR MOTIVO
-- ------------------------------------------------------------
SELECT
    cp.descricao                              AS motivo_parada,
    COUNT(*)                                  AS total_ocorrencias,
    ROUND(SUM(pa.duracao_minutos) / 60, 2)   AS total_horas,
    ROUND(AVG(pa.duracao_minutos), 2)         AS media_minutos_por_parada
FROM paradas pa
JOIN cad_paradas cp ON pa.codigo_parada = cp.codigo_parada
GROUP BY cp.descricao
ORDER BY total_horas DESC;


-- ------------------------------------------------------------
-- 4. PRODUÇÃO REAL X TEÓRICA POR TURNO
-- ------------------------------------------------------------
SELECT
    t.descricao                                           AS turno,
    SUM(d.ciclos * p.cavidades)                           AS producao_teorica,
    SUM(d.producao_real)                                  AS producao_real,
    ROUND(SUM(d.producao_real) /
          NULLIF(SUM(d.ciclos * p.cavidades), 0) * 100, 2) AS aproveitamento_pct
FROM dados d
JOIN dim_turno t   ON d.id_turno   = t.id_turno
JOIN cad_pecas p   ON d.codigo_peca = p.codigo
GROUP BY t.descricao
ORDER BY aproveitamento_pct DESC;


-- ------------------------------------------------------------
-- 5. EVOLUÇÃO SEMANAL DO % DE PERDA
-- ------------------------------------------------------------
SELECT
    YEAR(data)                                        AS ano,
    WEEK(data)                                        AS semana,
    SUM(quantidade_perdida)                           AS total_perdas,
    SUM(producao_real)                                AS total_produzido,
    ROUND(SUM(quantidade_perdida) /
          NULLIF(SUM(producao_real), 0) * 100, 2)    AS pct_perda
FROM dados
GROUP BY YEAR(data), WEEK(data)
ORDER BY ano, semana;


-- ------------------------------------------------------------
-- 6. RANKING DE OPERADORES POR OEE
-- ------------------------------------------------------------
SELECT
    o.nome                                                           AS operador,
    ROUND(AVG(d.disponibilidade) * 100, 2)                          AS disponibilidade_pct,
    ROUND(AVG(d.performance) * 100, 2)                              AS performance_pct,
    ROUND(AVG(d.aproveitamento) * 100, 2)                           AS aproveitamento_pct,
    ROUND(AVG(d.disponibilidade * d.performance * d.aproveitamento)
          * 100, 2)                                                  AS oee_pct,
    COUNT(*)                                                         AS total_registros
FROM dados d
JOIN dim_operador o ON d.id_operador = o.id_operador
GROUP BY o.nome
ORDER BY oee_pct DESC;


-- ------------------------------------------------------------
-- 7. INJETORAS COM OEE ABAIXO DA META (65%)
-- ------------------------------------------------------------
SELECT
    injetora,
    ROUND(AVG(disponibilidade * performance * aproveitamento) * 100, 2) AS oee_pct,
    COUNT(*) AS total_registros
FROM dados
GROUP BY injetora
HAVING oee_pct < 65
ORDER BY oee_pct ASC;


-- ------------------------------------------------------------
-- 8. CUSTO ACUMULADO DE PERDAS POR MÊS
-- ------------------------------------------------------------
SELECT
    YEAR(d.data)                                          AS ano,
    MONTH(d.data)                                         AS mes,
    MONTHNAME(d.data)                                     AS nome_mes,
    SUM(pe.quantidade_perdida * p.custo)                  AS custo_perda_mes,
    SUM(SUM(pe.quantidade_perdida * p.custo))
        OVER (PARTITION BY YEAR(d.data)
              ORDER BY MONTH(d.data))                     AS custo_acumulado
FROM dados d
JOIN perdas pe  ON d.id_dados   = pe.id_dados
JOIN pecas p    ON pe.codigo_peca = p.codigo_peca
GROUP BY YEAR(d.data), MONTH(d.data), MONTHNAME(d.data)
ORDER BY ano, mes;
