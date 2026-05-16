/*
================================================================================
Quality Checks
================================================================================
Script Purpose:
	This script performs various quality checks for data consistency, accuracy,
	and standardization across the 'silver' schema. It includes checks for:
	-Null and duplicate primary keys.
	-Unwanted Spaces in String fields.
	-Data Standardization and consistency.
	-Invalid date ranges and orders.
	-Data consistency between related fields.

Usage Notes:
	-Run this check after data loading silver layer.
	-Ivestigate and resolve any discrepancies found during the checks.
================================================================================
*/

--====================================================
--Checking silver.crm_cst_info
--====================================================

--Checking Nulls and Duplicates in primary key
--Expectation: No Results
SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cst_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

--Checking unwanted spaces in firstname and lastname column
--Expected Outcome: No Result
SELECT 
	cst_firstname 
FROM silver.crm_cst_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT 
	cst_lastname
FROM silver.crm_cst_info
WHERE cst_lastname != TRIM(cst_lastname);

---Data Standardization & Consistency

SELECT DISTINCT
	cst_marital_status
FROM silver.crm_cst_info;

SELECT DISTINCT
	cst_gndr
FROM silver.crm_cst_info;


--====================================================
--Checking silver.crm_prd_info
--====================================================

--Checking nulls and duplicates 
--Expectation: No Results
SELECT 
	prd_id,
	COUNT(*)
FROM
silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1;

--Checking prd_cost not be negative and handling its null
SELECT
	prd_cost
FROM
silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

--Data Standardization
SELECT DISTINCT 
	prd_line
FROM
silver.crm_prd_info;

--Checking the start date and end date
SELECT 
prd_start_dt,
prd_end_dt
FROM
silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


--====================================================
--Checking silver.crm_sales_details
--====================================================

--Cheking nulls
--Expectation: No Results
SELECT 
	sls_prd_key,
	sls_cst_id
FROM silver.crm_sales_details
WHERE sls_prd_key IS NULL OR sls_cst_id IS NULL;

--Check invalid dates
SELECT 
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_due_dt OR sls_order_dt > sls_ship_dt;

--Checking invalid price, sales and Nulls
SELECT 
	sls_sales,
	sls_price,
	sls_quantity
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL 
OR sls_sales <=0 OR sls_price <= 0 OR sls_quantity <= 0  
ORDER BY sls_sales,sls_quantity,sls_price;


--====================================================
--Checking silver.erp_cust_az12
--====================================================

--Checking nulls and duplicates
--Expectation: No Results
SELECT 
	cid
FROM silver.erp_cust_az12
WHERE cid IS NULL;

SELECT 
	cid,
	COUNT(*) AS duplicate_cid
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;

---Check bdate of customer, not be greater than today's date
SELECT 
 bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

--Data Standardization and Consistency
SELECT DISTINCT 
	gen
FROM silver.erp_cust_az12;

--====================================================
--Checking silver.erp_loc_a101
--====================================================

--Check nulls and dulplicates
--Expectation: No Results
SELECT 
	cid
FROM silver.erp_loc_a101
WHERE cid IS NULL;

SELECT 
	cid,
	COUNT(*) AS duplicate_cid
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1;

--Data Standardization and consistency
SELECT DISTINCT 
	cntry
FROM silver.erp_loc_a101;

--====================================================
--Checking silver.erp_px_cat_g1v2
--====================================================

--Checking nulls in id
--Expectation: No Results
SELECT 
* 
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL;

--Checking duplicates in id
SELECT 
	id,
	COUNT(*) AS duplicate_id
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;
