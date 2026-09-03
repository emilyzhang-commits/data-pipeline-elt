# ELT Data Pipeline: Airbyte, Snowflake, and dbt

An end-to-end ELT (Extract-Load-Transform) pipeline built to show how **Airbyte** can ingest genuinely different kinds of data sources into one **Snowflake** warehouse, with **dbt** handling all the transformation downstream:

- **A self-owned, live source** — a Google Sheets survey I created and can update at any time, ingested via Airbyte's Google Sheets connector.
- **An external, static source** — a CSV trading-books dataset (someone else's file, not something I control or can update), ingested via Airbyte's File connector.
- **A third-party data share** — a public pricing dataset pulled directly from the Snowflake Marketplace, no ingestion pipeline needed at all, just a data share mounted into the account.

Three different ingestion patterns, three different trust/update models, one unified warehouse — that's the actual point of the pipeline. dbt then builds staging and mart models on top, joining the trading data against the Marketplace pricing data into a fact table with basic profit analysis, and cleaning up the survey data into an analysis-ready view.

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

- **Survey data**: a short class survey collected via Google Sheets, loaded through Airbyte's Google Sheets connector. **Not included in this repo** — the raw responses include real email addresses submitted by classmates, so the underlying data isn't republished here regardless of format; only aggregated results (counts, charts) appear in the notebook.
- **Trading books**: a small synthetic buy/sell trading dataset (`TRADING_BOOKS`, `WEIGHTS_TABLE`) with fictional traders and prices. This is Snowflake's own public sample data from their [dbt + Snowflake pipelines guide](https://github.com/Snowflake-Labs/sfguide-deploying-pipelines-with-snowflake-and-dbt-labs/tree/main/dbt_project/seeds) — included here as `dbt/seeds/`.
- **Stock & FX pricing**: `Snowflake Public Data (Free)`, a free dataset available directly in the Snowflake Marketplace (`STOCK_PRICE_TIMESERIES_PIT`, `FX_RATES_TIMESERIES_PIT`).

The trading/stock/FX side of this pipeline is genuinely reproducible with the seed data included here. The survey side isn't, and shouldn't be — the dbt model and notebook still show the full transformation logic and preserved analysis results even without the raw responses.

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
3. Configure Airbyte connections: a CSV/File source pointed at `dbt/seeds/trading_books.csv` and `weights_table.csv` (included here), destined for Snowflake. (The survey side needs your own Google Sheet — see note above.)
4. `pip install -r requirements.txt`
5. Install dbt, point `~/.dbt/profiles.yml` at your Snowflake account, and copy the `dbt/` folder's contents into your dbt project directory.
6. `dbt run` to build the staging and mart models, then open `data_pipeline_elt_analysis.ipynb` to see the analysis — cell outputs are preserved from the original run, so results are visible without rerunning.

Either way: the code and SQL genuinely ran and the outputs shown are real results, not fabricated — but this notebook isn't meant to be re-executed top-to-bottom in one click today, since that needs the Airbyte/Snowflake setup redone from scratch.

## Key Insights & Learnings

- **Heterogeneous ingestion, one architecture**: a live self-owned source (Google Sheets), a static external file (CSV), and a zero-ingestion data share (Snowflake Marketplace) all land in the same warehouse through the same Airbyte → Snowflake → dbt pattern — the pipeline doesn't care where the data came from once it's loaded.
- **ELT vs. ETL**: loading raw data first and transforming it inside the warehouse (via dbt) instead of transforming before loading, which keeps raw data available and makes transformations version-controlled and testable.
- **dbt's staging → marts layering**: staging views do light cleanup (types, naming, filtering to valid records) while mart tables hold business-logic aggregates meant for downstream analysis.
- **Joining self-referencing tables**: pairing up `BUY`/`SELL` rows from the same `TRADING_BOOKS` table by trader and date to reconstruct individual trades.
- **Blending owned, external, and shared data**: joining a private (well, self-generated) trading dataset against a Snowflake Marketplace data share in dbt via `source()` references, with no custom ingestion code needed for the marketplace side.

Last Updated: 2026-09-03
