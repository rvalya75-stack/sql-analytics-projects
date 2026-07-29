-- Когортный анализ пользователей
-- Расчет удержания пользователей (Retention)

WITH cohorts AS (

    -- определяем когорту по месяцу регистрации
    SELECT
        id_user,
        DATE_TRUNC('month', reg_date) AS cohort_month
    FROM skygame.users

),

activity AS (

    -- определяем месяцы активности пользователей
    SELECT
        c.id_user,
        c.cohort_month,
        DATE_TRUNC('month', gs.start_session) AS activity_month

    FROM cohorts c

    JOIN skygame.game_sessions gs
    ON c.id_user = gs.id_user

),

cohort_size AS (

    -- размер каждой когорты
    SELECT
        cohort_month,
        COUNT(DISTINCT id_user) AS cohort_users

    FROM cohorts

    GROUP BY cohort_month

)

SELECT

    a.cohort_month,
    a.activity_month,

    COUNT(DISTINCT a.id_user) AS active_users,

    cs.cohort_users,

    ROUND(
        COUNT(DISTINCT a.id_user)::numeric /
        cs.cohort_users * 100,
        2
    ) AS retention_percent


FROM activity a

JOIN cohort_size cs
ON a.cohort_month = cs.cohort_month


GROUP BY
    a.cohort_month,
    a.activity_month,
    cs.cohort_users


ORDER BY
    a.cohort_month,
    a.activity_month;