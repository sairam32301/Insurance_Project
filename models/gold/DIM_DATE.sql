with date_generator as (

    select 
        dateadd(day, seq4(), '2020-01-01') as date
    from table(generator(rowcount => 3650))  --10 years

)

select
    date,
    year(date) as year,
    month(date) as month,
    day(date) as day,
    quarter(date) as quarter,
    to_char(date, 'Mon') as month_name,
    to_char(date, 'Day') as day_name,
    weekofyear(date) as week_of_year
from date_generator