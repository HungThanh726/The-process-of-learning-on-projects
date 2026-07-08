# 📊 SQL Business Analytics Portfolio

Dự án tổng hợp **SQL Business Analytics** gồm 2 domain thực tế, sử dụng T-SQL trên SQL Server. Module 2 có **real CSV dataset** kèm theo. Lộ trình kỹ năng từ SELECT cơ bản → JOIN đa bảng → Window Function → Nested Subquery.

---

## 🗂️ Cấu trúc Repository

```
sql-analytics-portfolio/
├── README.md
├── Portfolio_Master_TSQL.sql      ← Tất cả query — 2 module, annotated
├── data/
│   ├── AdventureWorks_Sales_2015.csv   (2,630 rows)
│   ├── AdventureWorks_Sales_2016.csv   (23,935 rows)
│   ├── AdventureWorks_Sales_2017.csv   (29,481 rows)
│   ├── AdventureWorks_Sales_2018.csv   (29,481 rows)
│   ├── AdventureWorks_Sales_2023.csv   (29,541 rows)
│   ├── AdventureWorks_Customers.csv    (18,148 rows)
│   ├── AdventureWorks_Returns.csv      (1,809 rows)
│   ├── AdventureWorks_Territories.csv  (10 rows)

```

---

## 🧰 Tech Stack

| Layer | Công cụ |
|-------|---------|
| Database Engine | SQL Server 2019+ (T-SQL) |
| Query IDE | SSMS (SQL Server Management Studio) |
| BI / Visualization | Power BI Desktop |
| Version Control | Git / GitHub |

---

## 📦 Module 1 — Retail Orders Analysis

**Database:** `hocsql` | **Table:** `Orders`

Phân tích đơn hàng bán lẻ Canada theo vùng địa lý, phân khúc khách hàng, và phương thức vận chuyển. Trọng tâm là tính toán chỉ số lợi nhuận và lọc dữ liệu nhiều điều kiện.

| # | Business Question | Kỹ thuật |
|---|-------------------|----------|
| BQ1 | Chọn cột báo cáo cơ bản | `SELECT` |
| BQ2 | Total Cost / Revenue / Net Profit theo Region | Derived columns |
| BQ3–BQ7 | Filter theo Region / Priority / Province / Shipmode / Subcategory | `WHERE IN / NOT IN / LIKE / AND` |

**Công thức:**
```sql
Total Cost    = product_base_margin × unit_price + shipping_cost
Total Revenue = order_quantity × unit_price × (1 − discount)
Net Profit    = Total Revenue − Total Cost
```

---

## 📦 Module 2 — AdventureWorks Sales Analytics

**Database:** `LEARNSQL` | **Dataset:** Sales 2015–2023 · 115K+ rows

Phân tích doanh thu đa năm, phân tích theo chiều sản phẩm × khách hàng × khu vực. Bổ sung phân tích Returns và Customer demographics từ file CSV thực tế.

### Dữ liệu

| File | Rows | Mô tả |
|------|------|-------|
| Sales 2015–2023 | 115,068 tổng | Fact table giao dịch bán hàng |
| Customers | 18,148 | Income, Education, Occupation, Gender |
| Returns | 1,809 | Giao dịch hoàn trả theo Territory × Product |
| Territories | 10 | Region, Country, Continent |

### Business Questions

| # | Câu hỏi | Kỹ thuật |
|---|---------|----------|
| BQ1 | Doanh thu theo tháng | `CREATE VIEW` + `FORMAT()` |
| BQ2 | Số lượng bán theo Màu × Giới tính KH | JOIN 3 bảng |
| BQ3 | Doanh thu tháng theo Category × Color | JOIN 4 bảng |
| BQ4 | Doanh thu năm theo Category (VIEW) | `CREATE VIEW` |
| BQ5 | Doanh thu theo Màu × Size × Category × Demographics | JOIN 5 bảng |
| BQ6 | Doanh thu theo Khu vực × Kích cỡ sản phẩm | JOIN Territories |
| BQ7 | Khách hàng có doanh thu > trung bình năm | Nested Subquery (2 lớp) |
| BQ8 | Tỷ lệ hoàn trả theo Product × Territory | Returns analysis + `NULLIF` |
| BQ9 | Phân tích KH theo Thu nhập × Học vấn | Customer demographics |

---

## 🔑 Ma trận kỹ thuật SQL

| Kỹ thuật | Mod 1 | Mod 2 |
|----------|:-----:|:-----:|:-----:|
| SELECT + WHERE (IN / NOT IN / LIKE / AND) | ✅ | | |
| Derived columns (phép tính) | ✅ | ✅ | |
| UNION ALL (gộp nhiều bảng) | | ✅ | |
| Multi-table JOIN (3–5 bảng) | | ✅ | ✅ |
| CREATE VIEW | | ✅ | ✅ |
| FORMAT() / YEAR() phân nhóm thời gian | | ✅ | ✅ |
| Excel serial date conversion | | | ✅ |
| Nested Subquery | | ✅ | ✅ |
| ROW_NUMBER() OVER (PARTITION BY) | | | ✅ |
| CTE — WITH ... AS | | | ✅ |
| Multi-CTE + FULL OUTER JOIN | | | ✅ |
| Returns / NULLIF analysis | | ✅ | |

---

## 🚀 Cách chạy

- SSMS (SQL Server Management Studio)

### Import CSV vào SQL Server

**Module 2 — AdventureWorks:**
Dùng SSMS → Right-click database → Tasks → Import Flat File → chọn từng file CSV trong thư mục `data/`.

### Chạy Query
1. Mở `Portfolio_Master_TSQL.sql` trong SSMS
2. Chạy từng Module — mỗi Module bắt đầu bằng `USE <database>`
3. Kết nối Power BI → xem `PowerBI_Guide.md`

---

## 📈 Insight (tổng quan)

- **Module 1**: West và Ontario dẫn đầu Net Profit sau khi trừ shipping cost và discount
- **Module 2**: 2015→2016 tăng trưởng +1,278% order qty; Australia và Southwest là top 2 territory
- **Module 2 Returns**: Return rate tăng song hành với growth — cần dashboard monitoring theo tháng


## 📈 Key Findings (từ dữ liệu thực tế)

> Các insight bên dưới tính trực tiếp từ CSV dataset — có thể dùng làm bullet point trong CV hoặc khi trình bày portfolio.

**AdventureWorks Sales (2015–2017, 84,174 orders):**
- 🔺 Tăng trưởng đột biến: 2015→2016 tăng **+1,278% order quantity** (2,630 → 36,230 đơn) — phản ánh mở rộng thị trường quy mô lớn
- 📦 2016→2017 tăng ổn định **+25% YoY** (36,230 → 45,314 đơn) — giai đoạn tăng trưởng bền vững
- 🌏 **Australia và Southwest** là 2 territory dẫn đầu (17,951 và 17,191 đơn) — cách xa Canada ở vị trí thứ 3 (10,894 đơn)
- ⚖️ Phân bổ giới tính gần như cân bằng: **M 50.7% / F 49.3%** — chiến dịch marketing không cần phân hóa theo giới
- 🔄 Return rate tăng từ **3.3% (2015)** lên **7.7% (2016)** theo tốc độ tăng trưởng — cần điều tra chất lượng sản phẩm ở các territory có return rate cao

---

## 👤 Tác giả

**[NGUYEN HUNG THANH]** — Business Data Analyst

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=flat&logo=linkedin)](https://linkedin.com/in/YOUR_PROFILE)

📧 hungthsnhnguyen37@gmail.com

--
