# Data Pipeline ELT Project

## Project Overview

This project demonstrates a complete **Extract-Load-Transform (ELT)** data pipeline architecture using industry-standard tools. The pipeline extracts data from various sources using **Airbyte**, loads it into **Snowflake** data warehouse, and transforms it using **dbt** (Data Build Tool).

### Key Features
- **Data Extraction**: Automated data extraction using Airbyte connectors
- **Data Warehouse**: Cloud-based data warehouse setup in Snowflake with optimized schemas
- **Transformation Layer**: dbt models for creating staging, intermediate, and mart tables
- **Data Analysis**: Custom analysis on music trading platform data with stock/FX market integration

## Technologies Used

| Category | Tools |
|----------|-------|
| **Data Integration** | Airbyte |
| **Data Warehouse** | Snowflake |
| **Transformation** | dbt (Data Build Tool) |
| **Data Modeling** | SQL |
| **Analysis** | Python, Jupyter Notebook, Pandas |
| **Version Control** | Git, GitHub |

## Project Structure

```
data-pipeline-elt/
├── data_pipeline_elt_analysis.ipynb    # Main project notebook with all analysis
├── README.md                           # Project documentation
```

## Key Sections

### 1. Airbyte Setup & Configuration
- Configuring source connectors (data sources)
- Setting up Snowflake destination connector
- Managing connection settings and incremental sync strategies

### 2. Snowflake Data Warehouse
- Creating databases and schemas for different data layers
- Optimizing table structure for analytics
- Setting up roles and permissions

### 3. dbt Model Development
- Creating staging models (STG) for data cleaning and standardization
- Building intermediate models for business logic
- Developing mart models for specific analytical use cases
- Testing and documentation within dbt

### 4. Custom Dataset Analysis
- Analyzing music trading platform data
- Generating business insights and metrics
- Creating analytical queries on transformed data

### 5. Advanced Analysis
- Stock market data integration and analysis
- Foreign exchange (FX) analysis
- Time series forecasting on market data

## Skills Demonstrated

✓ **Data Pipeline Architecture**: Understanding ELT vs ETL patterns and when to use each
✓ **Airbyte Proficiency**: Configuring extractors and loaders for production pipelines
✓ **Snowflake**: Database design, schema optimization, and query performance
✓ **dbt Expertise**: Data modeling, layered architecture (staging → intermediate → marts)
✓ **SQL Advanced Patterns**: Window functions, CTEs, recursive queries for complex transformations
✓ **Data Quality**: Implementing tests and validations in dbt
✓ **Python Data Analysis**: Post-pipeline analysis and visualization
✓ **Cloud Data Warehouse**: Working with cloud-native analytics infrastructure

## How to Use

### Prerequisites
- Python 3.8+
- Snowflake account (trial available)
- Airbyte instance (local or cloud)
- dbt CLI installed
- Jupyter Notebook

### Setup Steps

1. **Install dependencies**
```bash
   pip install -r requirements.txt
```

2. **Configure Snowflake Connection**
   - Update configuration with your Snowflake credentials
   - Or use environment variables for security

3. **Run Analysis Notebook**
   - Open `data_pipeline_elt_analysis.ipynb` in Jupyter
   - Execute cells sequentially to see the full analysis

## Key Insights

The project reveals insights into:
- Customer behavior patterns in music trading
- Market correlations between music trading and financial markets
- Optimal data warehouse design for analytics
- Best practices for production data pipelines

## Learning Outcomes

By completing this project, you will understand:
- How to architect scalable data pipelines
- When to use ELT vs ETL approaches
- Best practices for data warehouse design
- dbt's role in modern data stack
- Automating data transformations at scale

## Project Status

✅ **Complete** - All requirements implemented and analyzed

**Last Updated**: 2026-08-29

---
