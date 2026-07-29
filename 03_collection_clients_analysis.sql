-- Анализ клиентов взыскания
-- Сегментация займов по городам и типам кредита

SELECT
    lcc.id_client,
    rd.name_city,

    CASE 
        WHEN lcc.gender = 'M' THEN 1
        WHEN lcc.gender = 'F' THEN 0
        ELSE NULL
    END AS flag_gender,

    lcc.age,

    CASE
        WHEN lcc.cellphone IS NOT NULL THEN 1
        ELSE 0
    END AS flag_cellphone,

    lcc.is_active,
    lcc.cl_segm,
    lcc.amt_loan,
    lcc.date_loan,
    lcc.credit_type,

    -- общая сумма займов по городу
    SUM(lcc.amt_loan) OVER(PARTITION BY rd.name_city) AS sum_loan_city,

    -- доля займа клиента в городе
    lcc.amt_loan::float /
    NULLIF(SUM(lcc.amt_loan) OVER(PARTITION BY rd.name_city),0)
    AS share_loan_city,

    -- общая сумма займов по типу кредита
    SUM(lcc.amt_loan) OVER(PARTITION BY lcc.credit_type) AS sum_loan_type,


    -- доля займа клиента внутри типа кредита
    lcc.amt_loan::float /
    NULLIF(SUM(lcc.amt_loan) OVER(PARTITION BY lcc.credit_type),0)
    AS share_loan_type,

    -- количество клиентов
    COUNT(*) OVER(PARTITION BY rd.name_city) AS cnt_clients_city,

    COUNT(*) OVER(PARTITION BY lcc.credit_type) AS cnt_clients_type

FROM skybank.late_collection_clients lcc

LEFT JOIN skybank.region_dict rd
ON lcc.id_city = rd.id_city;