{{ config(materialized='view') }}

select
    b.trade_id as trade_id,
    b.trade_date as trade_date,
    b.trader_name as trader_name,
    b.desk as desk,
    b.ticker as ticker,
    b.quantity as quantity_buy,
    b.price as price_buy,
    s.quantity as quantity_sell,
    s.price as price_sell
from {{ source('airbyte_csv_data', 'TRADING_BOOKS') }} b
join {{ source('airbyte_csv_data', 'TRADING_BOOKS') }} s
    on b.trader_name = s.trader_name
   and b.trade_date = s.trade_date
where b.trade_type = 'BUY'
  and s.trade_type = 'SELL'
order by b.trade_id
