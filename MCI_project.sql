/*
  SQL BUSINESS ANALYTICS PORTFOLIO 
  Tác giả  : NGUYEN HUNG THANH
==================================================================
*/

/*
   MODULE 1 — RETAIL ORDERS ANALYSIS
   Database : hocsql  |  Table: Orders
   Kỹ thuật : SELECT, Derived columns, WHERE (IN / NOT IN / LIKE / AND)
*/

USE hocsql
GO

-- ── BQ1: Cột cơ bản cần báo cáo:

SELECT order_id, order_date, order_quantity, value, profit
FROM Orders;

-- ── BQ2: Total Cost / Revenue / Net Profit theo Region:
--   Total Cost    = product_base_margin × unit_price + shipping_cost
--   Total Revenue = order_quantity × unit_price × (1 − discount)
--   Net Profit    = Total Revenue − Total Cost

SELECT
    Region,
    Province,
    Product_subcategory,
    (product_base_margin * unit_price + shipping_cost) AS Total_Cost,
    (order_quantity * unit_price * (1 - discount))        AS Total_Revenue,
    (order_quantity * unit_price * (1 - discount))
        - (product_base_margin * unit_price + shipping_cost)   AS Net_Profit
FROM Orders
WHERE Region IN ('West', 'Ontario', 'Nunavut');

-- ── BQ3: Lọc theo vùng / ưu tiên / tỉnh / phương thức vận chuyển:

SELECT * FROM Orders WHERE Region = 'West';
SELECT * FROM Orders WHERE order_priority NOT IN ('Critical');
SELECT * FROM Orders WHERE order_priority IN ('High', 'Low', 'Medium');
SELECT * FROM Orders WHERE Province LIKE '%New%';
SELECT * FROM Orders WHERE shipping_mode NOT LIKE '%Air%' AND value < 500;
SELECT * FROM Orders WHERE product_subcategory LIKE 'Co%';
SELECT * FROM Orders WHERE customer_segment LIKE '%e' AND order_quantity > 10;

/* 
   MODULE 2 — ADVENTUREWORKS SALES ANALYTICS
   Database : LEARNSQL
   Kỹ thuật : UNION ALL, Multi-table JOIN, CREATE VIEW,
              Nested Subquery, Returns analysis
 */

USE LEARNSQL
GO

-- FOUNDATION: Hợp nhất tất cả năm bán hàng

IF OBJECT_ID('ALLSALES','V') IS NOT NULL DROP VIEW ALLSALES;
GO
CREATE VIEW ALLSALES AS
    SELECT * FROM AdventureWorks_Sales_2015
    UNION ALL
    SELECT * FROM AdventureWorks_Sales_2016
    UNION ALL
    SELECT * FROM AdventureWorks_Sales_2017
    UNION ALL
    SELECT * FROM AdventureWorks_Sales_2018
    UNION ALL
    SELECT * FROM AdventureWorks_Sales_2023;
GO

-- BQ1: Doanh thu theo tháng (VIEW):

IF OBJECT_ID('MonthlySaleReport','V') IS NOT NULL DROP VIEW MonthlySaleReport;
GO
CREATE VIEW MonthlySaleReport AS
SELECT
    FORMAT(s.OrderDate, 'MM/yyyy')        AS MonthYear,
    SUM(s.OrderQuantity * p.ProductPrice) AS TotalRevenue
FROM ALLSALES AS s
JOIN AdventureWorks_Products AS p ON s.ProductKey = p.ProductKey
GROUP BY FORMAT(s.OrderDate, 'MM/yyyy');
GO

-- BQ2: Số lượng bán theo Màu sản phẩm × Giới tính khách hàng:
SELECT
    p.ProductColor,
    c.Gender,
    SUM(s.OrderQuantity)                  AS TotalQuantity
FROM ALLSALES AS s
JOIN AdventureWorks_Products AS p   ON s.ProductKey  = p.ProductKey
JOIN AdventureWorks_Customers AS c  ON s.CustomerKey = c.CustomerKey
GROUP BY p.ProductColor, c.Gender
ORDER BY TotalQuantity DESC;

-- BQ3: Doanh thu tháng theo Category × ProductColor:

SELECT
    FORMAT(s.OrderDate, 'MM/yyyy')        AS MonthYear,
    cat.CategoryName,
    p.ProductColor,
    SUM(s.OrderQuantity * p.ProductPrice) AS TotalRevenue
FROM ALLSALES AS s
JOIN AdventureWorks_Products AS p              ON s.ProductKey          = p.ProductKey
JOIN AdventureWorks_Product_Subcategories AS sc ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
JOIN AdventureWorks_Product_Categories AS cat   ON sc.ProductCategoryKey   = cat.ProductCategoryKey
GROUP BY FORMAT(s.OrderDate, 'MM/yyyy'), cat.CategoryName, p.ProductColor
ORDER BY MonthYear;

-- BQ4: VIEW tổng hợp doanh thu theo Năm + Category:
IF OBJECT_ID('Summary_Product_Category','V') IS NOT NULL DROP VIEW Summary_Product_Category;
GO
CREATE VIEW Summary_Product_Category AS
SELECT
    YEAR(s.OrderDate)                     AS SaleYear,
    cat.CategoryName,
    SUM(s.OrderQuantity * p.ProductPrice) AS TotalRevenue
FROM ALLSALES AS s
JOIN AdventureWorks_Products AS p              ON s.ProductKey          = p.ProductKey
JOIN AdventureWorks_Product_Subcategories AS sc ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
JOIN AdventureWorks_Product_Categories AS cat   ON sc.ProductCategoryKey   = cat.ProductCategoryKey
GROUP BY YEAR(s.OrderDate), cat.CategoryName;
GO

-- BQ5: Doanh thu theo Màu × Kích cỡ × Category × Giới tính × Nghề nghiệp:
SELECT
    p.ProductColor,
    p.ProductSize,
    cat.CategoryName,
    cus.Gender,
    cus.Occupation,
    SUM(s.OrderQuantity * p.ProductPrice) AS TotalRevenue,
    AVG(s.OrderQuantity * p.ProductPrice) AS AvgRevenue
FROM ALLSALES AS s
JOIN AdventureWorks_Products AS p              ON s.ProductKey          = p.ProductKey
JOIN AdventureWorks_Customers AS cus           ON s.CustomerKey         = cus.CustomerKey
JOIN AdventureWorks_Product_Subcategories AS sc ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
JOIN AdventureWorks_Product_Categories AS cat   ON sc.ProductCategoryKey   = cat.ProductCategoryKey
GROUP BY p.ProductColor, p.ProductSize, cat.CategoryName, cus.Gender, cus.Occupation
ORDER BY TotalRevenue DESC;

-- BQ6: Doanh thu theo Khu vực × Kích cỡ sản phẩm:

SELECT
    t.Region,
    p.ProductSize,
    SUM(s.OrderQuantity * p.ProductPrice) AS TotalRevenue
FROM ALLSALES AS s
JOIN AdventureWorks_Products AS p    ON s.ProductKey    = p.ProductKey
JOIN AdventureWorks_Territories AS t ON s.TerritoryKey  = t.SalesTerritoryKey
WHERE p.ProductSize IN ('S', 'M', 'L', 'XL')
GROUP BY t.Region, p.ProductSize
ORDER BY TotalRevenue DESC;

-- BQ7: Khách hàng có doanh thu > trung bình năm (Nested Subquery):

SELECT
    ts.CustomerKey,
    ts.YearSale,
    ts.Revenue,
    ts.Frequency,
    ab.AvgRevenueByYear
FROM (
    SELECT
        s.CustomerKey,
        YEAR(s.OrderDate)                       AS YearSale,
        SUM(s.OrderQuantity * p.ProductPrice)   AS Revenue,
        COUNT(DISTINCT s.OrderNumber)           AS Frequency
    FROM ALLSALES AS s
    JOIN AdventureWorks_Products AS p ON s.ProductKey = p.ProductKey
    GROUP BY s.CustomerKey, YEAR(s.OrderDate)
) AS ts
JOIN (
    SELECT YearSale, AVG(Revenue) AS AvgRevenueByYear
    FROM (
        SELECT
            s.CustomerKey,
            YEAR(s.OrderDate)                     AS YearSale,
            SUM(s.OrderQuantity * p.ProductPrice) AS Revenue
        FROM ALLSALES AS s
        JOIN AdventureWorks_Products AS p ON s.ProductKey = p.ProductKey
        GROUP BY s.CustomerKey, YEAR(s.OrderDate)
    ) AS sub
    GROUP BY YearSale
) AS ab ON ts.YearSale = ab.YearSale
WHERE ts.Revenue > ab.AvgRevenueByYear
ORDER BY ts.YearSale, ts.Revenue DESC;

-- BQ8: Phân tích Returns — tỷ lệ hoàn trả theo Product × Territory:

SELECT
    t.Region,
    t.Country,
    p.ProductName,
    cat.CategoryName,
    SUM(r.ReturnQuantity)                          AS TotalReturned,
    SUM(s_agg.TotalSold)                           AS TotalSold,
    ROUND(
        100.0 * SUM(r.ReturnQuantity)
              / NULLIF(SUM(s_agg.TotalSold), 0),
        2)                                         AS ReturnRate_Pct
FROM AdventureWorks_Returns AS r
JOIN AdventureWorks_Territories AS t
    ON r.TerritoryKey = t.SalesTerritoryKey
JOIN AdventureWorks_Products AS p
    ON r.ProductKey = p.ProductKey
JOIN AdventureWorks_Product_Subcategories AS sc
    ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
JOIN AdventureWorks_Product_Categories AS cat
    ON sc.ProductCategoryKey = cat.ProductCategoryKey
LEFT JOIN (
    SELECT ProductKey, TerritoryKey, SUM(OrderQuantity) AS TotalSold
    FROM ALLSALES
    GROUP BY ProductKey, TerritoryKey
) AS s_agg
    ON r.ProductKey = s_agg.ProductKey
    AND r.TerritoryKey = s_agg.TerritoryKey
GROUP BY t.Region, t.Country, p.ProductName, cat.CategoryName
HAVING SUM(r.ReturnQuantity) > 0
ORDER BY ReturnRate_Pct DESC;

-- BQ9: Phân tích khách hàng theo thu nhập × trình độ học vấn:

SELECT
    cus.EducationLevel,
    cus.Occupation,
    cus.AnnualIncome,
    COUNT(DISTINCT s.CustomerKey)                 AS CustomerCount,
    SUM(s.OrderQuantity * p.ProductPrice)         AS TotalRevenue,
    AVG(s.OrderQuantity * p.ProductPrice)         AS AvgOrderValue
FROM ALLSALES AS s
JOIN AdventureWorks_Customers AS cus ON s.CustomerKey = cus.CustomerKey
JOIN AdventureWorks_Products AS p    ON s.ProductKey  = p.ProductKey
GROUP BY cus.EducationLevel, cus.Occupation, cus.AnnualIncome
ORDER BY TotalRevenue DESC;
