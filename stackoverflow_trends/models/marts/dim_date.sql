{{
    config(
        materialized='table'
    )
}}

WITH stg_dates AS (
    -- Get every unique date from your staging table
    SELECT DISTINCT 
        DATE(creation_date) as date_day
    FROM {{ ref('stg_questions') }}
)

SELECT
    -- Create a smart integer key (e.g., 20210101)
    CAST(FORMAT_DATE('%Y%m%d', date_day) AS INT64) AS date_key,
    
    date_day AS full_date,
    
    -- Extract standard date parts
    EXTRACT(YEAR FROM date_day) AS year,
    EXTRACT(MONTH FROM date_day) AS month,
    EXTRACT(QUARTER FROM date_day) AS quarter,
    EXTRACT(DAYOFWEEK FROM date_day) AS day_of_week_num,
    
    -- Formatted names (Replacing your Python lookup dictionaries)
    FORMAT_DATE('%B', date_day) AS month_name,
    FORMAT_DATE('%A', date_day) AS day_name

FROM stg_dates