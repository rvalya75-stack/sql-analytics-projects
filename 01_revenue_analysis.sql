-- јнализ выручки и среднего чека по мес€цам

SELECT 
    DATE_TRUNC('month', m.dtime_pay) AS month,
    SUM(m.cnt_buy * p.price) AS revenue,
    COUNT(DISTINCT m.id_user) AS users_count,
    SUM(m.cnt_buy * p.price) / COUNT(DISTINCT m.id_user) AS avg_revenue
FROM skygame.monetary m
JOIN skygame.log_prices p
    ON m.id_item_buy = p.id_item
    AND m.dtime_pay >= p.valid_from
    AND m.dtime_pay < COALESCE(p.valid_to, DATE '3000-01-01')
GROUP BY month
ORDER BY month;