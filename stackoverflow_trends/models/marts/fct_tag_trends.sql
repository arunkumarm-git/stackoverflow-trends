{{
    config(
        materialized='table',
        cluster_by=["date_key", "tag", "answer_status"]
    )
}}

WITH stg_questions AS (
    SELECT *
    FROM {{ ref('stg_questions') }}
),

unnested_tags AS (
    SELECT
        q.creation_date,
        CAST(FORMAT_DATE('%Y%m%d', DATE(q.creation_date)) AS INT64) AS date_key,
        TRIM(tag_element) AS tag,
        q.score,
        q.view_count,
        q.favorite_count,
        q.comment_count,
        q.answer_count,
        q.answer_status
    FROM stg_questions AS q
    CROSS JOIN UNNEST(SPLIT(q.tags, '|')) AS tag_element
)

SELECT 
    FARM_FINGERPRINT(CONCAT(CAST(creation_date AS STRING), tag, CAST(score AS STRING))) AS surrogate_key,
    creation_date, 
    date_key,
    tag,
    score,
    view_count,
    favorite_count,
    comment_count,
    answer_count,
    answer_status
FROM unnested_tags
WHERE tag != '' AND tag IS NOT NULL