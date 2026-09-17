# 📊 Retail & AdventureWorks Sales Analytics

Phân tích bán lẻ 2 domain: **Superstore Canada** (Orders) và **AdventureWorks** (Sales 2015–2023). Tổng hợp từ BTVN1→BTVN6 và 8 file CSV thực tế.

---

## 🗂️ Cấu trúc Repository

```
retail-aw-analytics/
├── README.md
├── Portfolio_Master_TSQL.sql     
└── data/
    ├── AdventureWorks_Sales_2015.csv      (2,630 rows)
    ├── AdventureWorks_Sales_2016.csv     (23,935 rows)
    ├── AdventureWorks_Sales_2017.csv     (29,481 rows)
    ├── AdventureWorks_Sales_2018.csv     (29,481 rows)
    ├── AdventureWorks_Sales_2023.csv     (29,541 rows)
    ├── AdventureWorks_Customers.csv      (18,148 rows)
    ├── AdventureWorks_Returns.csv         (1,809 rows)
    └── AdventureWorks_Territories.csv        (10 rows)
```

---

## 🧰 Tech Stack

| Layer | Công cụ |
|-------|---------|
| Database | SQL Server (T-SQL) |
| Visualization | Power BI Desktop |
| Version Control | Git / GitHub |

---

## 📦 Module 1 — Retail Orders Analysis

**Database:** `hocsql` | **Table:** `Orders` 

| BQ | Câu hỏi | Kỹ thuật |
|----|---------|----------|
| BQ1 | Chọn cột báo cáo cơ bản | `SELECT` |
| BQ2 | Total Cost / Revenue / Net Profit theo Region | Derived columns |
| BQ3–9 | Filter theo Region / Priority / Province / Shipmode / Subcategory / Segment | `WHERE IN / NOT IN / LIKE / AND` |

```
Total Cost    = product_base_margin × unit_price + shipping_cost
Total Revenue = order_quantity × unit_price × (1 − discount)
Net Profit    = Total Revenue − Total Cost
```

---

## 📦 Module 2 — AdventureWorks Sales Analytics

**Database:** `LEARNSQL` 

### Dataset

| File | Rows | Unique Customers |
|------|------|-----------------|
| Sales 2015 | 2,630 | 2,630 |
| Sales 2016 | 23,935 | 9,133 |
| Sales 2017 | 29,481 | 10,502 |
| Sales 2018 | 29,481 | 14,186 |
| Sales 2023 | 29,541 | 14,203 |
| **ALLSALES** | **115,068** | — |
| Customers | 18,148 | 9 chiều demographics |
| Returns | 1,809 | 2015–2017 only |
| Territories | 10 | 3 Continent, 10 Region |

### 11 Business Questions

| BQ | Câu hỏi | Kỹ thuật | 
|----|---------|----------|
| BQ1 | Doanh thu theo tháng (VIEW) | `CREATE VIEW` + `FORMAT()` | 
| BQ2 | Số lượng bán theo Màu × Giới tính | JOIN 3 bảng | 
| BQ3 | Doanh thu tháng × Category × Color | JOIN 4 bảng |
| BQ4 | Doanh thu Năm × Category (VIEW) | `CREATE VIEW` | 
| BQ5 | Revenue × Màu × Size × Category × Demographics | JOIN 5 bảng |
| BQ6 | Revenue × Territory × Size | JOIN Territories | 
| BQ7 | Khách hàng vượt doanh thu trung bình năm | Nested Subquery 2 lớp | 
| BQ8 | Tăng trưởng YoY | `LAG()` Window Function | 
| BQ9 | Return Rate theo Territory × năm | Subquery LEFT JOIN + `NULLIF()` | 
| BQ10 | Phân khúc KH Champion/Loyal/Promising | `CTE` + `CASE WHEN` | 
| BQ11 | Sales vs Returns theo Territory | Multi-CTE + `FULL OUTER JOIN` | 

---

## 🔑 Kỹ thuật SQL

| Kỹ thuật | Mod 1 | Mod 2 |
|----------|:-----:|:-----:|
| SELECT + WHERE (IN / NOT IN / LIKE / AND) | ✅ | |
| Derived columns | ✅ | ✅ |
| UNION ALL (gộp 5 bảng) | | ✅ |
| Multi-table JOIN (3–5 bảng) | | ✅ |
| CREATE VIEW | | ✅ |
| FORMAT() / YEAR() | | ✅ |
| Nested Subquery (2 lớp) | | ✅ |
| LAG() Window Function | | ✅ |
| CTE — WITH ... AS | | ✅ |
| CASE WHEN phân nhóm | | ✅ |
| Multi-CTE + FULL OUTER JOIN | | ✅ |
| NULLIF() / COALESCE() / ISNULL() | | ✅ |

---

## 📈 Key Findings

- **2015→2016:** Đơn hàng tăng **+810%** (2,630→23,935)
- **2016→2018:** Khách hàng từ 9,133 → 14,186 (+55%)
- **Australia** dẫn đầu Pacific; **Southwest** mạnh nhất US
- **Returns:** 86 (2015) → 972 (2017) — tăng theo growth
---

## 🚀 Cách chạy

1. SSMS → import 8 CSV vào `LEARNSQL`
2. Mở `Portfolio_Master_TSQL.sql`
3. Chạy **FOUNDATION** trước (tạo view `ALLSALES`)
4. Chạy từng BQ theo thứ tự
---

## 👤 Tác giả

**NGUYEN HUNG THANH** —  Data Analyst 

🔵 [LinkedIn](https://www.linkedin.com/in/thant2706/)

📧 hungthsnhnguyen37@gmail.com
