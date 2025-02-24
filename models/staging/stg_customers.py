def model(dbt,session):
 
    customers_df = dbt.source("raw_qwt","RAW_CUSTOMERS")
    return customers_df