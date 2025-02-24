{{ config(materialized = 'incremental', unique_key = ['orderid','lineno']) }}
 
select ord_dtl.*,ord.orderdate from
{{source('raw_qwt','RAW_ORDER_DETAILS')}} as ord_dtl join
{{source('raw_qwt','RAW_ORDERS')}} as ord
on ord_dtl.OrderID=ord.OrderID
 
 
{% if is_incremental() %}
 
where orderdate > (select max(orderdate) from {{this}} )
 
{% endif %} 