select
    s.TICKER,
    s.TRADE_DATE,
    p.VARIABLE,
    p.VALUE
from {{ ref('staging_valid_stock_tickers') }} s
join {{ source('snowflake_public_data', 'STOCK_PRICE_TIMESERIES_PIT') }} p
    on s.TICKER = p.TICKER
   and TO_DATE(s.TRADE_DATE) = TO_DATE(p.DATE)
where p.VARIABLE in ('all_day_high', 'all_day_low')
