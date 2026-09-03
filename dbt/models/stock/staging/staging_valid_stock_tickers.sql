select distinct
    TICKER,
    TRADE_DATE
from {{ source('airbyte_csv_data', 'TRADING_BOOKS') }}
where DESK = 'Equity Desk'
