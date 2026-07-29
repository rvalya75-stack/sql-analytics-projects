-- Анализ пользователей с платежами и активностью
-- Использование вложенных запросов (Subqueries)

SELECT
    u.id_user,
    u.reg_date,

    COUNT(gs.id_user) AS session_count,
    AVG(
        EXTRACT(
            EPOCH FROM (gs.end_session - gs.start_session)
        ) / 60
    ) AS avg_session_duration_min

FROM skygame.users u
JOIN skygame.game_sessions gs
ON u.id_user = gs.id_user

WHERE u.id_user IN (

    SELECT
        m.id_user

    FROM skygame.monetary m
    GROUP BY m.id_user
    HAVING COUNT(m.id_user) >= 1

)

GROUP BY
    u.id_user,
    u.reg_date

HAVING COUNT(gs.id_user) > 2

ORDER BY session_count DESC;