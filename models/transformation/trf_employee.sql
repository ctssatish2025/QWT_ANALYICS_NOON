{{ config(materialized = 'table', schema = env_var('DBT_TRANSFORMSCHEMA','transforming_dev'))}}
 
with recursive managers
      (indent, office_id, employee_id, employee_name, employee_title, manager_id, manager_name, manager_title)
    as
    (
 
        select '*' as indent,
                    office as office_id,
                    empid as employee_id,
                    first_name as employee_name,
                    title as employee_title,
                    empid as manager_id,
                    first_name as manager_name,
                    title as manager_title
          from {{ref("stg_employee")}} where title = 'President'
 
        union all
 
        select mgr.indent || '*',
            emp.office as office_id,
            emp.empid as employee_id ,
            emp.first_name as employee_name,
            emp.title as employee_title,
            mgr.employee_id as manager_id,
            mgr.employee_name as manager_name,
            mgr.employee_title as manager_title
          from {{ref("stg_employee")}} as emp inner join managers as mgr
            on emp.reports_to = mgr.employee_id
      ),
 
      offices(office_id, office_city, office_country)
      as
      (
      select officeid as office_id, city, country from {{ref("stg_offices")}}
      )
 
  select indent, employee_id, employee_name, employee_title , manager_id, manager_name, manager_title, ofc.office_city, ofc.office_country
    from managers as mgr inner join offices as ofc on ofc.office_id = mgr.office_id
