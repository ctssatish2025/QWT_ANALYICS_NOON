{{ config(materialized = 'incremental', unique_key= ['OrderID']) }}
 
select ord_dtl.*,ord.orderdate from
{{source('raw_qwt','raw_order_details')}} as ord_dtl join
{{source('raw_qwt','raw_orders')}} as ord
on ord_dtl.OrderID=ord.OrderID
 
 
{% if is_incremental() %}
 
where orderdate > (select max(orderdate) from {{this}} )
 
{% endif %}