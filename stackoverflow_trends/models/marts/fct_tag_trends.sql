{{
    config(
        materialized='table',
        sort=['date_key', 'tag'],
        dist='tag'
    )
}}

WITH stg_questions AS (
    SELECT *
    FROM {{ ref('stg_questions') }}
),

unnested_tags AS (
    SELECT
        creation_date,
        score,
        view_count,
        favorite_count,
        comment_count,
        answer_count,
        answer_status,
        TRIM(tag) AS tag
    FROM
        stg_questions,
        UNNEST(SPLIT(tags, '|')) AS tag
),

final AS (
    SELECT
        FARM_FINGERPRINT(CONCAT(FORMAT_DATE('%Y%m%d', DATE(creation_date)), tag)) AS surrogate_key,
        DATE(creation_date) AS creation_full_date,
        EXTRACT(YEAR FROM creation_date) AS year,
        EXTRACT(MONTH FROM creation_date) AS month,
        EXTRACT(QUARTER FROM creation_date) AS quarter,
        EXTRACT(DAYOFWEEK FROM creation_date) AS day_of_week,
        FORMAT_DATE('%B', DATE(creation_date)) AS month_name,
        FORMAT_DATE('%A', DATE(creation_date)) AS day_name,
        FORMAT_DATE('%Y%m%d', DATE(creation_date)) AS date_key,
        tag,
        score,
        view_count,
        favorite_count,
        comment_count,
        answer_count,
        answer_status
    FROM unnested_tags
)

SELECT * FROM final