{% macro standardize_status(lead_status) %}

case
    when {{ lead_status }} is null then 'UNKNOWN'

    when upper(trim({{ lead_status }})) in ('NEW','CREATED') then 'NEW'

    when upper(trim({{ lead_status }})) in ('CONTACTED','CONTACTEDD') then 'CONTACTED'

    when upper(trim({{ lead_status }})) in ('QUALIFED','QUALIFIED') then 'QUALIFIED'

    when upper(trim({{ lead_status }})) in ('DISQUALIFIED') then 'REJECTED'

    else 'UNKNOWN'

end

{% endmacro %}