-- macros/drop_pr_schema.sql
{% macro drop_pr_schema(schema) %}

    {% set drop_sql %}
        drop schema if exists {{ target.database }}.{{ schema }}
    {% endset %}

    {% do log("Dropping schema: " ~ schema, info=True) %}
    {% do run_query(drop_sql) %}

{% endmacro %}