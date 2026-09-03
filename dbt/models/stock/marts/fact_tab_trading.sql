{{ config(materialized='table') }}

select
    trade_id,
    price_buy * quantity_buy as buy_money,
    price_sell * quantity_sell as sell_money,
    (price_sell * quantity_sell) - (price_buy * quantity_buy) as profit
from {{ ref('staging_buy_sell_joint') }}
order by trade_id
