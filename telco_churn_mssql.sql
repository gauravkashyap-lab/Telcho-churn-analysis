--                                                             Telco churn analysis 
--=======================================================================================================================================================================================
--=======================================================================================================================================================================================
CREATE TABLE [TelcoCustomerChurn] (
    [customerID] NVARCHAR(MAX),
    [gender] NVARCHAR(MAX),
    [SeniorCitizen] NVARCHAR(MAX),
    [Partner] NVARCHAR(MAX),
    [Dependents] NVARCHAR(MAX),
    [tenure] NVARCHAR(MAX),
    [PhoneService] NVARCHAR(MAX),
    [MultipleLines] NVARCHAR(MAX),
    [InternetService] NVARCHAR(MAX),
    [OnlineSecurity] NVARCHAR(MAX),
    [OnlineBackup] NVARCHAR(MAX),
    [DeviceProtection] NVARCHAR(MAX),
    [TechSupport] NVARCHAR(MAX),
    [StreamingTV] NVARCHAR(MAX),
    [StreamingMovies] NVARCHAR(MAX),
    [Contract] NVARCHAR(MAX),
    [PaperlessBilling] NVARCHAR(MAX),
    [PaymentMethod] NVARCHAR(MAX),
    [MonthlyCharges] NVARCHAR(MAX),
    [TotalCharges] NVARCHAR(MAX),
    [Churn] NVARCHAR(MAX)
);

--=======================================================================================================================================================================================
--=======================================================================================================================================================================================
-- Basic Level
--#Checking table structure.
select
    top 5 *
from
    TelcoCustomerChurn;

--#Checking total records
select
    COUNT(*) as total_records
from
    TelcoCustomerChurn;

-- 7043 is the total records.
--#How many customers are male and female.
select
    gender,
    COUNT(*) as total_records
from
    TelcoCustomerChurn
group by
    gender;

-- Male : 3555  and Female : 3488
--#What is the overall churn rate.
SELECT
    COUNT(
        CASE
            WHEN Churn = 'Yes' THEN 1
        END
    ) * 100.0 / COUNT(*) AS ChurnRate
FROM
    TelcoCustomerChurn;

--#Contract type distribution
SELECT
    Contract,
    COUNT(*) AS Total
FROM
    TelcoCustomerChurn
GROUP BY
    Contract;

--#Average monthly charges
SELECT
    AVG(CAST(MonthlyCharges AS FLOAT)) AS AvgMonthlyCharges
FROM
    TelcoCustomerChurn;

--#Payment method usage.
SELECT
    PaymentMethod,
    COUNT(*) AS Total
FROM
    TelcoCustomerChurn
GROUP BY
    PaymentMethod;

--#Dependents percentage
SELECT
    COUNT(
        CASE
            WHEN Dependents = 'Yes' THEN 1
        END
    ) * 100.0 / COUNT(*) AS DependentsPercent
FROM
    TelcoCustomerChurn;

--=======================================================================================================================================================================================
--=======================================================================================================================================================================================
--Intermediate Level
--#Churn rate by gender
SELECT
    Gender,
    COUNT(
        CASE
            WHEN Churn = 'Yes' THEN 1
        END
    ) * 100.0 / COUNT(*) AS ChurnRate
FROM
    TelcoCustomerChurn
GROUP BY
    Gender;

--#Highest churn by contract type
SELECT
    Contract,
    COUNT(
        CASE
            WHEN Churn = 'Yes' THEN 1
        END
    ) * 100.0 / COUNT(*) AS ChurnRate
FROM
    TelcoCustomerChurn
GROUP BY
    Contract
ORDER BY
    ChurnRate DESC;

--#Churn by internet services
SELECT
    InternetService,
    COUNT(
        CASE
            WHEN Churn = 'Yes' THEN 1
        END
    ) * 100.0 / COUNT(*) AS ChurnRate
FROM
    TelcoCustomerChurn
GROUP BY
    InternetService;

--#Tenure comparison
SELECT
    Churn,
    AVG(CAST(Tenure AS INT)) AS AvgTenure
FROM
    TelcoCustomerChurn
GROUP BY
    Churn;

--#Tech support vs churn
SELECT
    TechSupport,
    COUNT(
        CASE
            WHEN Churn = 'Yes' THEN 1
        END
    ) * 100.0 / COUNT(*) AS ChurnRate
FROM
    TelcoCustomerChurn
GROUP BY
    TechSupport;

--#Monthly charges vs churn
SELECT
    Churn,
    AVG(CAST(MonthlyCharges AS FLOAT)) AS AvgCharges
FROM
    TelcoCustomerChurn
GROUP BY
    Churn;

--#Payment method with highest churn
SELECT
    PaymentMethod,
    COUNT(
        CASE
            WHEN Churn = 'Yes' THEN 1
        END
    ) * 100.0 / COUNT(*) AS ChurnRate
FROM
    TelcoCustomerChurn
GROUP BY
    PaymentMethod
ORDER BY
    ChurnRate DESC;

--=======================================================================================================================================================================================
--=======================================================================================================================================================================================
--Advanced Level
--#Contract+Internet combination
SELECT
    Contract,
    InternetService,
    COUNT(
        CASE
            WHEN Churn = 'Yes' THEN 1
        END
    ) * 100.0 / COUNT(*) AS ChurnRate
FROM
    TelcoCustomerChurn
GROUP BY
    Contract,
    InternetService
ORDER BY
    ChurnRate DESC;

--#Long tenure churn(>24 months)
SELECT
    CASE
        WHEN CAST(Tenure AS INT) > 24 THEN 'Long Tenure'
        ELSE 'Short Tenure'
    END AS TenureGroup,
    COUNT(
        CASE
            WHEN Churn = 'Yes' THEN 1
        END
    ) * 100.0 / COUNT(*) AS ChurnRate
FROM
    TelcoCustomerChurn
GROUP BY
    CASE
        WHEN CAST(Tenure AS INT) > 24 THEN 'Long Tenure'
        ELSE 'Short Tenure'
    END;

--#Revenue loss due to churn
SELECT
    SUM(CAST(MonthlyCharges AS FLOAT)) AS RevenueLoss
FROM
    TelcoCustomerChurn
WHERE
    Churn = 'Yes';

--Lifetime value(approx)
SELECT
    Churn,
    AVG(
        CAST(Tenure AS INT) * CAST(MonthlyCharges AS FLOAT)
    ) AS AvgLTV
FROM
    TelcoCustomerChurn
GROUP BY
    Churn;

--#High risk customer segment
SELECT
    *
FROM
    TelcoCustomerChurn
WHERE
    Contract = 'Month-to-month'
    AND CAST(MonthlyCharges AS FLOAT) > 70
    AND TechSupport = 'No';

--#Feature importance prep(data extraction).
SELECT
    Gender,
    SeniorCitizen,
    Partner,
    Dependents,
    Tenure,
    PhoneService,
    InternetService,
    Contract,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges,
    Churn
FROM
    TelcoCustomerChurn;

--                                                  Thank You
--=======================================================================================================================================================================================
--=======================================================================================================================================================================================