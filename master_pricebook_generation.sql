-- Fullprice Pricebooks
DROP TABLE IF EXISTS store_mngmnt.pricebook_file_support_sku;
CREATE TABLE store_mngmnt.pricebook_file_support_sku AS (
SELECT po.venda_sku,
	ROUND(ROUND(2* default_retail_price_eur::int, -1)/2) AS row,
	ROUND(ROUND(2*(CASE WHEN default_retail_price_au::real IS NOT NULL
                        THEN default_retail_price_au::real/(Select "Ex Rate Euro" from store_mngmnt."Exchange_rates" where "Currency" = 'AU')
                        ELSE (CASE  WHEN default_retail_price_eur < 550
                                    THEN (CASE  WHEN (((((default_retail_price_eur
                                                            /COALESCE((SELECT net_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 1))
                                                            *COALESCE((SELECT local_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 1))
                                                            /(1-COALESCE((SELECT variable_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 0)))
                                                            +COALESCE((SELECT fixed_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 0))
                                                            *COALESCE((SELECT markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 1)) < 350
                                                THEN ((((((default_retail_price_eur
                                                            /COALESCE((SELECT net_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_below' LIMIT 1), 1))
                                                            *COALESCE((SELECT local_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_below' LIMIT 1), 1))
                                                            /(1-COALESCE((SELECT variable_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_below' LIMIT 1), 0)))
                                                            +COALESCE((SELECT fixed_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_below' LIMIT 1), 0))
                                                            *COALESCE((SELECT markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_below' LIMIT 1), 1))
                                                            +COALESCE((SELECT extra_ship_costs FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_below' LIMIT 1), 0)) 
                                                ELSE ((((((default_retail_price_eur
                                                            /COALESCE((SELECT net_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 1))
                                                            *COALESCE((SELECT local_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 1))
                                                            /(1-COALESCE((SELECT variable_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 0)))
                                                            +COALESCE((SELECT fixed_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 0))
                                                            *COALESCE((SELECT markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 1))
                                                            +COALESCE((SELECT extra_ship_costs FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_350' LIMIT 1), 0)) 
                                                END)      
                                    ELSE ((((((default_retail_price_eur
                                                    /COALESCE((SELECT net_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_550' LIMIT 1), 1))
                                                    *COALESCE((SELECT local_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_550' LIMIT 1), 1))
                                                    /(1-COALESCE((SELECT variable_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_550' LIMIT 1), 0)))
                                                    +COALESCE((SELECT fixed_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_550' LIMIT 1), 0))
                                                    *COALESCE((SELECT markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_550' LIMIT 1), 1))
                                                    +COALESCE((SELECT extra_ship_costs FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_550' LIMIT 1), 0)) 
                                    END)
                        END)::numeric, -1)/2) AS au,
	--
    ROUND(ROUND(2*(CASE WHEN default_retail_price_kr::real IS NOT NULL
                        THEN default_retail_price_kr::real/(Select "Ex Rate Euro" from store_mngmnt."Exchange_rates" where "Currency" = 'KR')
                        ELSE CASE WHEN (select c1.made_in from store_mngmnt.country_eu_noneu c1 where lower(c1.country) = lower(madein) limit 1) = 'EU'
                                  THEN (((default_retail_price_eur
                                                /COALESCE((SELECT net_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'KR_fta' LIMIT 1), 1))
                                                *COALESCE((SELECT markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'KR_fta' LIMIT 1), 1))
                                                +COALESCE((SELECT extra_ship_costs FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'KR_fta' LIMIT 1), 0)) 
                                  ELSE (((default_retail_price_eur
                                                /COALESCE((SELECT net_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'KR_nonfta' LIMIT 1), 1))
                                                *COALESCE((SELECT markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'KR_nonfta' LIMIT 1), 1))
                                                +COALESCE((SELECT extra_ship_costs FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'KR_nonfta' LIMIT 1), 0)) 
                                  END
                        END)::numeric, -1)/2) AS kr, --DDU
	--
    ROUND(ROUND(2*(CASE WHEN default_retail_price_cny::real IS NOT NULL
                        THEN default_retail_price_cny::real/(Select "Ex Rate Euro" from store_mngmnt."Exchange_rates" where "Currency" = 'CNY')
                        ELSE ((((((default_retail_price_eur
                                        /COALESCE((SELECT net_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'CN' LIMIT 1), 1))
                                        *COALESCE((SELECT local_vat FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'CN' LIMIT 1), 1))
                                        /(1-COALESCE((SELECT variable_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'CN' LIMIT 1), 0)))
                                        +COALESCE((SELECT fixed_duties FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'CN' LIMIT 1), 0))
                                        *COALESCE((SELECT markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'CN' LIMIT 1), 1))
                                        +COALESCE((SELECT extra_ship_costs FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'CN' LIMIT 1), 0)) 
                        END)::numeric, -1)/2) AS cn,
	--
    -- ***,
    --
    0 AS row_ab,
    0 AS au_ab,
    0 AS kr_ab,
    0 AS cn_ab
FROM store_mngmnt.master_support po
ORDER BY venda_sku);

-- Markup Support File
DROP TABLE IF EXISTS store_mngmnt.markup_support;
CREATE TABLE store_mngmnt.markup_support AS (
SELECT po.venda_sku,
    row/eur_cost_price AS mu_row,
    au/eur_cost_price AS mu_au,
    kr/eur_cost_price AS mu_kr,
	cn/eur_cost_price AS mu_cn
    --,
	-- ***
    --
FROM store_mngmnt.master_support po
LEFT JOIN store_mngmnt.pricebook_file_support_sku USING(venda_sku));

-- Discounted Pricebooks
UPDATE store_mngmnt.pricebook_file_support_sku pbs
SET 
    row1_ab =ROUND(CASE WHEN (SELECT chameleon_flag FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1) = 'NO'
                        THEN row1
                        ELSE GREATEST(
                                LEAST(
                                    CASE WHEN EXISTS(SELECT SKU FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1)
                                         THEN (row1 * (1-COALESCE((SELECT cast(max_disc_private as numeric) from store_mngmnt.stock_management where SKU = pbs.venda_sku LIMIT 1), 1)))
                                         ELSE ((eur_cost_price
                                                /(1 - (0.15 - (SELECT variable_cost FROM store_mngmnt.variable_costs WHERE price_column = 'ROW1' LIMIT 1))))
                                                *GREATEST(mu_row1 / mu_row1, COALESCE((SELECT ab_markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'ROW1' LIMIT 1), 1)))         
                                         END, 
                                    row1 * (1 - (SELECT min_discount FROM store_mngmnt.reseller_checks)),
                                    row1),
                                row1 * (1 - (SELECT max_discount FROM store_mngmnt.reseller_checks)))
                        END::numeric),
    --
    row_ab = ROUND(CASE WHEN (SELECT chameleon_flag FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1) = 'NO'
                        THEN row
                        ELSE GREATEST(
                                LEAST(
                                    CASE WHEN EXISTS(SELECT SKU FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1)
                                         THEN (row * (1-COALESCE((SELECT cast(max_disc_private as numeric) from store_mngmnt.stock_management where SKU = pbs.venda_sku LIMIT 1), 1)))
                                         ELSE ((eur_cost_price
                                                /(1 - (0.15 - (SELECT variable_cost FROM store_mngmnt.variable_costs WHERE price_column = 'ROW' LIMIT 1))))
                                                *GREATEST(mu_row / mu_row1, COALESCE((SELECT ab_markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'ROW' LIMIT 1), 1)))         
                                         END, 
                                    row * (1 - (SELECT min_discount FROM store_mngmnt.reseller_checks)),
                                    row1),
                                row * (1 - (SELECT max_discount FROM store_mngmnt.reseller_checks)))
                        END::numeric),
    --
    au_ab =  ROUND(CASE WHEN (SELECT chameleon_flag FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1) = 'NO'
                        THEN au
                        ELSE GREATEST(
                                LEAST(
                                    CASE WHEN EXISTS(SELECT SKU FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1)
                                         THEN (au * (1-COALESCE((SELECT cast(max_disc_private as numeric) from store_mngmnt.stock_management where SKU = pbs.venda_sku LIMIT 1), 1)))
                                         ELSE ((eur_cost_price
                                                /(1 - (0.15 - (SELECT variable_cost FROM store_mngmnt.variable_costs WHERE price_column = 'AU' LIMIT 1))))
                                                *GREATEST(po.mu_au / po.mu_row, COALESCE((SELECT ab_markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'AU_550' LIMIT 1), 1)))
                                         END, 
                                    au * (1 - (SELECT min_discount FROM store_mngmnt.reseller_checks)),
                                    row1),
                                au * (1 - (SELECT max_discount FROM store_mngmnt.reseller_checks)))
                        END::numeric),
    --
    kr_ab =  ROUND(CASE WHEN (SELECT chameleon_flag FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1) = 'NO'
                        THEN kr
                        ELSE GREATEST(
                                LEAST(
                                    CASE WHEN EXISTS(SELECT SKU FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1)
                                         THEN kr 
                                         ELSE ((eur_cost_price
                                                /(1 - (0.15 - (SELECT variable_cost FROM store_mngmnt.variable_costs WHERE price_column = 'KR' LIMIT 1))))
                                                *GREATEST(po.mu_kr / po.mu_row, COALESCE((SELECT ab_markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'KR_nonfta' LIMIT 1), 1)))
                                         END, 
                                    kr * (1 - (SELECT min_discount FROM store_mngmnt.reseller_checks)),
                                    row1 / 1.22), net vat
                                kr * (1 - (SELECT max_discount FROM store_mngmnt.reseller_checks)))
                        END::numeric),
    --
    cn_ab =  ROUND(CASE WHEN (SELECT chameleon_flag FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1) = 'NO'
                        THEN cn
                        ELSE GREATEST(
                                LEAST(
                                    CASE WHEN EXISTS(SELECT SKU FROM store_mngmnt.stock_management WHERE SKU = pbs.venda_sku LIMIT 1)
                                         THEN (cn * (1-COALESCE((SELECT cast(max_disc_private as numeric) from store_mngmnt.stock_management where SKU = pbs.venda_sku LIMIT 1), 1)))
                                         ELSE ((eur_cost_price
                                                /(1 - (0.15 - (SELECT variable_cost FROM store_mngmnt.variable_costs WHERE price_column = 'CN' LIMIT 1))))
                                                *GREATEST(po.mu_cn / po.mu_row, COALESCE((SELECT ab_markup FROM store_mngmnt.pricebook_calculation_parameters WHERE price_column = 'CN' LIMIT 1), 1)))
                                         END, 
                                    cn * (1 - (SELECT min_discount FROM store_mngmnt.reseller_checks)),
                                    row1),
                                cn * (1 - (SELECT max_discount FROM store_mngmnt.reseller_checks)))
                        END::numeric)
    --,
    -- ***
    --
FROM (SELECT * FROM store_mngmnt.master_support po
      LEFT JOIN store_mngmnt.markup_support ms USING (venda_sku)) po
WHERE po.venda_sku = pbs.venda_sku;

-- Pricebook Export File
TRUNCATE TABLE store_mngmnt.pricebook_file;
--
INSERT INTO store_mngmnt.pricebook_file VALUES 
    ('', 'EUR', 'EUR', 'EUR', 'EUR', 'EUR'); --, ***);
--
WITH po AS (
	SELECT productid, venda_sku,
		ROW_NUMBER () OVER (PARTITION BY productid ORDER BY del_window_open DESC) AS r
	FROM store_mngmnt.po_export lpe 
	WHERE venda_sku IN (SELECT venda_sku FROM store_mngmnt.pricebook_file_support_sku)
	ORDER BY productid)
INSERT INTO store_mngmnt.pricebook_file
SELECT po.productid, row, au, kr, cn --, *** 
FROM store_mngmnt.pricebook_file_support_sku pbs
LEFT JOIN po ON po.venda_sku = pbs.venda_sku
WHERE r = 1;  