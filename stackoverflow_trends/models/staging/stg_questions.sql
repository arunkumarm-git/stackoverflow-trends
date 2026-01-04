{{
    config(
        materialized="ephemeral"
    )
}}

WITH source_data AS (
    SELECT 
        tags, 
        creation_date, 
        score, 
        view_count, 
        favorite_count, 
        comment_count, 
        answer_count,
        CASE 
            WHEN answer_count > 0 THEN 'answered'
            ELSE 'unanswered'
        END AS answer_status
    FROM {{ source("stackoverflow_public", "posts_questions") }}
    WHERE creation_date >= TIMESTAMP('2019-01-01 00:00:00')
      AND creation_date < TIMESTAMP('2022-01-01 00:00:00')
      AND tags IS NOT NULL AND tags != '' AND tags != ' '
)

SELECT * FROM source_data
WHERE MOD(ABS(FARM_FINGERPRINT(CONCAT(CAST(creation_date AS STRING), tags, CAST(Score AS STRING)))), 10) < 3