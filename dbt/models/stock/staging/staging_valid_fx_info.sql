select
    f.TICKER,
    f.TRADE_DATE,
    r.VARIABLE_NAME,
    r.VALUE as EXCHANGE_RATE
from {{ ref('staging_valid_fx_tickers') }} f
join {{ source('snowflake_public_data', 'FX_RATES_TIMESERIES_PIT') }} r
    on f.TRADE_DATE = r.DATE
where (r.BASE_CURRENCY_ID = 'EUR' and r.QUOTE_CURRENCY_ID = 'USD')
   or (r.BASE_CURRENCY_ID = 'GBP' and r.QUOTE_CURRENCY_ID = 'USD')
