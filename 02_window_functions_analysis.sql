-- Анализ динамики платежей и скользящего среднего
-- Использование оконных функций для анализа трендов


SELECT
    month_dt,
    sum_amt,

    AVG(sum_amt) OVER(
        ORDER BY month_dt
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3_month,

    AVG(sum_amt) OVER(
        ORDER BY month_dt
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7_month

FROM
(
    SELECT
        DATE_TRUNC('month', m.dtime_pay)::date AS month_dt,
        SUM(m.cnt_buy * p.price) AS sum_amt
    FROM skygame.monetary m
    JOIN skygame.log_prices p
        ON m.id_item_buy = p.id_item
        AND m.dtime_pay >= p.valid_from
        AND m.dtime_pay < COALESCE(p.valid_to, DATE '3000-01-01')
    GROUP BY 1
) t

ORDER BY month_dt;