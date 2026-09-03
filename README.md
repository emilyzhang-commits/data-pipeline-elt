# ELT Data Pipeline: Airbyte, Snowflake, and dbt

An end-to-end ELT (Extract-Load-Transform) pipeline that extracts data from a Google Sheets survey and local CSV files with **Airbyte**, loads it into **Snowflake**, and transforms it with **dbt** into staging and mart models. It also pulls in a public stock/FX pricing dataset from the Snowflake Marketplace and joins it against a small trading-books dataset to build a fact table with basic profit analysis.

## Technologies Used

| Category | Tools |
|---|---|
| Extract & Load | Airbyte |
| Data Warehouse | Snowflake |
| Transformation | dbt |
| Analysis | Python, Jupyter Notebook, pandas, matplotlib |

## Repo Structure

```
data-pipeline-elt/
├── data_pipeline_elt_analysis.ipynb   # Main notebook: setup, dbt commands, and analysis
├── dbt/                                # dbt project
│   ├── dbt_project.yml
│   ├── packages.yml / package-lock.yml
│   ├── macros/generate_schema_name.sql
│   └── models/
│       ├── schema.yml                  # source definitions
│       ├── survey/staging/transform_survey.sql
│       └── stock/
│           ├── staging/                # valid ticker + pricing staging views
│           └── marts/fact_tab_trading.sql
├── requirements.txt
└── README.md
```

## Data Sources

- **Survey data**: a short class survey collected via Google Sheets, loaded through Airbyte's Google Sheets connector.
- **Trading books**: a small synthetic CSV dataset of buy/sell trades (`TRADING_BOOKS`, `WEIGHTS_TABLE`), loaded through Airbyte's File connector.
- **Stock & FX pricing**: `Snowflake Public Data (Free)`, a free dataset available directly in the Snowflake Marketplace (`STOCK_PRICE_TIMESERIES_PIT`, `FX_RATES_TIMESERIES_PIT`).

Because the survey and trading-books data were loaded through my own Airbyte connections into my own Snowflake trial account, that exact data isn't included in this repo — but the dbt models and notebook show the full transformation logic and the analysis results (with outputs preserved) end to end.

## Pipeline Sections

1. **Environment setup** — Airbyte and Snowflake trial accounts, dbt installed via Miniconda.
2. **Snowflake configuration** — warehouse, databases, a dedicated role, and schemas.
3. **Loading data with Airbyte** — Google Sheets survey and CSV trading data into Snowflake.
4. **dbt: cleaning the survey data** — a staging model (`transform_survey.sql`) that turns raw Google Form question text into clean column names.
5. **Survey data analysis** — exploratory questions I wrote myself (beverage/pet preferences, class standing, VR headset ownership vs. preferred LLM, major vs. sleep schedule, etc.).
6. **Stock & FX dataset analysis** — pulling in Snowflake Marketplace pricing data and joining it against the trading books via dbt staging models.
7. **Trading fact table & profit analysis** — a mart-layer fact table (`fact_tab_trading.sql`) computing buy/sell money and profit per trade, then aggregated profit and profit rate by desk.

## How to Run

This isn't a one-command-runnable pipeline, since it depends on a personal Airbyte workspace and Snowflake account with data already loaded — but the pieces are:

1. Create free trial accounts on [Airbyte](https://airbyte.com/) and [Snowflake](https://www.snowflake.com/en/).
2. Set up the warehouse/database/role/schema SQL shown in the notebook.
3. Configure Airbyte connections: a Google Sheets source (your own survey) and a CSV/File source, both destined for Snowflake.
4. `pip install -r requirements.txt`
5. Install dbt, point `~/.dbt/profiles.yml` at your Snowflake account, and copy the `dbt/` folder's contents into your dbt project directory.
6. `dbt run` to build the staging and mart models, then open `data_pipeline_elt_analysis.ipynb` to see the analysis — cell outputs are preserved from the original run, so results are visible without rerunning.

## Key Insights & Learnings

- **ELT vs. ETL**: loading raw data first and transforming it inside the warehouse (via dbt) instead of transforming before loading, which keeps raw data available and makes transformations version-controlled and testable.
- **dbt's staging → marts layering**: staging views do light cleanup (types, naming, filtering to valid records) while mart tables hold business-logic aggregates meant for downstream analysis.
- **Joining self-referencing tables**: pairing up `BUY`/`SELL` rows from the same `TRADING_BOOKS` table by trader and date to reconstruct individual trades.
- **Blending private and public data**: joining a private trading dataset against a public Snowflake Marketplace pricing dataset in dbt via `source()` references.

Last Updated: 2026-09-03
