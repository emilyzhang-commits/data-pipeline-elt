# ELT Data Pipeline: Airbyte, Snowflake, and dbt

This project builds an end-to-end ELT pipeline with Airbyte, Snowflake, and dbt.

The real point of it is ingesting three genuinely different kinds of data sources into one warehouse:

1. A Google Sheets survey I created myself and can update anytime.
2. A static CSV file I don't control.
3. A Snowflake Marketplace data share that needs no ingestion pipeline at all, since it's just mounted directly into the account.

Airbyte handles the first two, the Marketplace handles the third. dbt does the transformation once everything lands in the warehouse: joining trading data against marketplace pricing into a fact table with profit analysis, and cleaning up the survey responses into something analysis-ready.

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
│   ├── seeds/                          # public sample trading data (see below)
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

Survey data comes from a short class survey collected through Google Sheets. It's not included in this repo. The raw responses have real email addresses submitted by classmates, so that data doesn't get republished here no matter the format. Only aggregated results like counts and charts show up in the notebook.

The trading books dataset (`TRADING_BOOKS`, `WEIGHTS_TABLE`) is small and synthetic, fictional traders and prices. It's actually Snowflake's own public sample data from their [dbt + Snowflake pipelines guide](https://github.com/Snowflake-Labs/sfguide-deploying-pipelines-with-snowflake-and-dbt-labs/tree/main/dbt_project/seeds), so it's included here under `dbt/seeds/`.

Stock and FX pricing comes from `Snowflake Public Data (Free)`, a free dataset available directly in the Snowflake Marketplace (`STOCK_PRICE_TIMESERIES_PIT`, `FX_RATES_TIMESERIES_PIT`).

Because of this, the trading/stock/FX side of the pipeline is genuinely reproducible with the seed data included here. The survey side isn't, and shouldn't be, but the dbt model and notebook still show the full transformation logic and preserved results even without the raw responses.

## Pipeline Sections

1. **Environment setup** — Airbyte and Snowflake trial accounts, dbt installed via Miniconda.
2. **Snowflake configuration** — warehouse, databases, a dedicated role, and schemas.
3. **Loading data with Airbyte** — Google Sheets survey and CSV trading data into Snowflake.
4. **dbt: cleaning the survey data** — a staging model (`transform_survey.sql`) that turns raw Google Form question text into clean column names.
5. **Survey data analysis** — exploratory questions I wrote myself (beverage/pet preferences, class standing, VR headset ownership vs. preferred LLM, major vs. sleep schedule, etc.).
6. **Stock & FX dataset analysis** — pulling in Snowflake Marketplace pricing data and joining it against the trading books via dbt staging models.
7. **Trading fact table & profit analysis** — a mart-layer fact table (`fact_tab_trading.sql`) computing buy/sell money and profit per trade, then aggregated profit and profit rate by desk.

## How to Run

This isn't a one-command pipeline. It depends on a personal Airbyte workspace and Snowflake account with data already loaded. Here's what's involved:

1. Create free trial accounts on [Airbyte](https://airbyte.com/) and [Snowflake](https://www.snowflake.com/en/).
2. Set up the warehouse/database/role/schema SQL shown in the notebook.
3. Configure an Airbyte CSV/File connection pointed at `dbt/seeds/trading_books.csv` and `weights_table.csv` (included here), destined for Snowflake. The survey side needs your own Google Sheet (see note above).
4. `pip install -r requirements.txt`
5. Install dbt, point `~/.dbt/profiles.yml` at your Snowflake account, and copy the `dbt/` folder's contents into your dbt project directory.
6. `dbt run` to build the staging and mart models, then open `data_pipeline_elt_analysis.ipynb` to see the analysis. Cell outputs are preserved from the original run, so results are visible without rerunning.

The code and SQL genuinely ran, and the outputs shown are real results, not fabricated. But this notebook isn't meant to be re-executed top to bottom in one click today, since that needs the Airbyte/Snowflake setup redone from scratch.

## Key Insights & Learnings

The main one: a live self-owned source, a static external file, and a zero-ingestion data share all land in the same warehouse through the same Airbyte-to-Snowflake-to-dbt pattern. Once the data is loaded, the pipeline doesn't care where it came from.

A few other things this project drove home:

- **ELT vs. ETL.** Loading raw data first and transforming it inside the warehouse with dbt, instead of transforming before loading. Keeps raw data available and makes transformations version-controlled and testable.
- **dbt's staging-to-marts layering.** Staging views do light cleanup (types, naming, filtering to valid records), while mart tables hold the business-logic aggregates meant for downstream analysis.
- **Joining self-referencing tables.** Pairing up `BUY`/`SELL` rows from the same `TRADING_BOOKS` table by trader and date to reconstruct individual trades.

Last Updated: 2026-09-03
