{{ config(materialized = 'incremental', unique_key= ['OrderID']) }}
 
select * from
{{source('raw_qwt','RAW_ORDERS')}}
 
{% if is_incremental() %}
 
where orderdate > (select max(orderdate) from {{this}} )
 
{% endif %}

