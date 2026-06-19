# 🗄️ Consultas SQL — Análise de Produção Industrial

## Sobre o Projeto

Coleção de consultas SQL desenvolvidas para análise de eficiência produtiva,
OEE e perdas em ambiente industrial. As consultas refletem casos de uso reais
de um setor de injeção plástica, com dados extraídos do ERP Protheus.

---

## 🏭 Contexto

Os dados analisados são provenientes de um setor industrial com:
- **19 injetoras** monitoradas
- **Múltiplos operadores** por turno
- **Milhares de moldes** cadastrados
- **R$5,6M** em perdas monitoradas anualmente

---

## 📋 Consultas Disponíveis

| # | Consulta | Descrição |
|---|----------|-----------|
| 1 | OEE por Injetora | Calcula Disponibilidade, Performance e Aproveitamento por máquina |
| 2 | Top 10 Perdas Financeiras | Ranking de peças com maior custo de refugo |
| 3 | Paradas por Motivo | Total de horas paradas por categoria de parada |
| 4 | Produção Real x Teórica | Comparativo de eficiência por turno |
| 5 | Evolução Semanal de Perdas | % de perda semana a semana |
| 6 | Ranking de Operadores | OEE individual por operador |
| 7 | Injetoras Abaixo da Meta | Identifica máquinas com OEE < 65% |
| 8 | Custo Acumulado de Perdas | Perdas financeiras mensais com acumulado anual |

---

## 🔍 Conceitos Utilizados

- `JOIN` entre múltiplas tabelas (fato e dimensão)
- `GROUP BY` com agregações (`SUM`, `AVG`, `COUNT`)
- `HAVING` para filtros pós-agregação
- `Window Functions` — `SUM() OVER (PARTITION BY ... ORDER BY ...)`
- `NULLIF` para evitar divisão por zero
- `ROUND` para formatação de percentuais
- Subconsultas e filtros condicionais

---

## 🗂️ Modelo de Dados

As consultas foram desenvolvidas com base no seguinte modelo:
dados (fato)

├── dim_turno

├── dim_operador

├── dim_injetora

├── cad_pecas

└── perdas

└── pecas

---

## 🛠️ Tecnologias

- SQL (MySQL / PostgreSQL compatível)
- Modelo dimensional baseado no projeto Power BI
- Dados originados do ERP Protheus

---

## 👤 Autor

**Jhonathan Panisson**
Analista de Dados em Transição | Power BI · SQL · Python
[GitHub](https://github.com/rjpanisson) | [LinkedIn](https://linkedin.com/in/jhonathan-panisson)
