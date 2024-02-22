SELECT * FROM ML.PREDICT(MODEL `sandbox-cortex-cip20.CORTEX_SAP_ML_MODELS.clustering_nmodel`, (
SELECT
    LanguageKey_SPRAS,
    CountryKey_LAND1,
    avg(avg_item) AS avg_item_price,
    avg(item_count) AS avg_item_count,
    sum(order_counter) AS order_count
FROM (
    SELECT
      SoldtoParty_KUNNR AS vbap_kunnr,
      SalesDocument_VBELN,
      LanguageKey_SPRAS,
      CountryKey_LAND1,
      1 AS order_counter,
      avg(NetPrice_NETWR) AS avg_item,
      sum(counter) AS item_count
    FROM (
      SELECT
        SO.SoldtoParty_KUNNR,
        SO.NetPrice_NETWR,
        SO.SalesDocument_VBELN,
        CM.CountryKey_LAND1,
        CM.LanguageKey_SPRAS,
        1 AS counter
      FROM
        `sandbox-cortex-cip20.CORTEX_SAP_REPORTING.SalesOrders` AS SO
      INNER JOIN `sandbox-cortex-cip20.CORTEX_SAP_REPORTING.CustomersMD` AS CM
        ON
          SO.Client_MANDT = CM.Client_MANDT
          AND SO.SoldtoParty_KUNNR = CM.CustomerNumber_KUNNR
    )
    GROUP BY vbap_kunnr, SalesDocument_VBELN, LanguageKey_SPRAS, CountryKey_LAND1
    ORDER BY SalesDocument_VBELN
)
GROUP BY vbap_kunnr, LanguageKey_SPRAS, CountryKey_LAND1
))
