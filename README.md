## **Candidate Submission**

### **1. How to Run This Project**

Nothing specific here! Just as long as dependancies and setup is the same as described above, just run ``uv run dbt run``

### **2. Data Modeling Decisions**

- **Architectural Pattern:** I chose to do a dimensional model (star schema) built in layers. Staging models (`stg_*`) are simple views where I standardize types, clean obvious nulls/zeros, and add simple row-level flags. Intermediate models (`int_*`) assemble business-ready rows, apply row filtering (e.g., exclude `canceled`/`unavailable` and require valid timestamps), and add joins across orders, items, sellers, products, payments, and customers. Mart models (`dim_*` and `fct_*`) are materialized as tables and provide the primary analytics interface for analysts.

- **Grain and Keys:**
  - `fct_orders_stats` (grain: one row per `order_id`): derives counts, revenue, freight, and convenience ratios for order-level analysis.
  - `fct_product_performance` (grain: `product_id` by `performance_month`): monthly sales, revenue, freight, customer reach, and physical averages; supports trend and cohort-style analysis.
  - `fct_customers_products` (grain: `customer_unique_id`): customer lifetime metrics (orders, revenue, freight, payment behavior) and product/seller diversity.
  - `fct_fulfillment_metrics` (grain: `seller_id`): throughput, revenue, freight, and delivery-time statistics to assess fulfillment performance.
  - `dim_customers` (grain: `customer_unique_id`): first/last order dates and the customer’s most popular category.
  - `dim_products` (grain: `product_id`): cleaned product attributes and English category mapping.
  - `dim_customers_geography` (grain: `customer_id`/`customer_unique_id`): standardized city/state/ZIP joined to geolocation with a missing-geo flag.
  - `dim_sellers_geography` (grain: `seller_id`): standardized city/state/ZIP joined to geolocation with a missing-geo flag.

- **Key Modeling Choices:**
  - Orders with status in (`canceled`, `unavailable`) and rows missing critical timestamps are excluded in some cases.
  - Product attributes are validated; invalid physical dimensions are either flagged in staging or filtered out.
  - Text standardization for better joinability and grouping (e.g., lowercased cities, uppercased states, lowercased categories) and English category translation in `dim_products`.
  - Materialization: staging as views for agility; intermediate/marts as tables for performance and stability.

- **Answering Business Questions:**
  - Customer Behavior (most valuable, purchasing patterns): aggregate `fct_customers_products.lifetime_total_value` and `total_orders_count` by `customer_unique_id`, enrich with `dim_customers.first_order_date`/`last_order_date` and `most_popular_category` to segment by category preference.
  - Product Performance (best-selling products/categories): rank within `fct_product_performance` by `total_revenue` or `total_items_sold` per `performance_month`, join to `dim_products.product_category_name_english` to roll up by category.
  - Geographic Performance (key markets by city/state): join `fct_orders_stats` to `dim_customers_geography` on `customer_id`, then aggregate `total_price` and count orders by `state`/`city`. Use the missing-geo flag for data quality-aware reporting.
  - Order Fulfillment (time from order to delivery, variability): use `fct_fulfillment_metrics` KPIs (`avg_delivery_days`, `min/max`, `stddev`) by `seller_id`, and join to `dim_sellers_geography` to slice results by seller location.

### **3. Assumptions & Trade-offs**

_(Briefly describe any assumptions you made and any trade-offs you considered.)_

- **Assumptions:**
  - Delivery timestamps: when `order_delivered_carrier_date` > `order_delivered_customer_date`, the row is retained and flagged (see `stg_orders.has_invalid_delivery_dates`); not corrected or dropped.
  - Product dimensions: missing/zero physical dimensions are flagged in staging (`stg_products.has_invalid_dimensions`). Rows with invalid dimensions are excluded only where physical metrics are computed (`int_orders_products`).
  - Product categories: missing categories are filled as `Other`; Portuguese-to-English mapping is applied where available in `dim_products`.
  - Order filtering: fulfillment and order metrics consider only rows with `order_status = 'delivered'` and valid purchase/delivery timestamps; `canceled`/`unavailable` are excluded upstream in `int_orders_*` models.
  - Customer identity: `customer_unique_id` is treated as the stable customer key for lifetime metrics.

- **Trade-offs:**
  - Excluding canceled/unavailable orders simplifies SLA and revenue KPIs but removes cancellation-rate analysis from the same marts (would require separate marts or views).
  - Filling categories as `Other` improves grouping consistency but hides nuance about data quality; downstream category analyses should optionally filter this bucket.
  - No SCDs: dimensions are current-state snapshots; historical changes to geography or product attributes are not tracked over time.
  - Materialization choice: views in staging reduce storage but compute shifts to downstream tables; tables in marts increase storage but speed up analyst queries.
  - Filtering invalid dimensions may bias physical averages toward complete records; a data quality dashboard is recommended for monitoring coverage over time.
  - Monthly grain in product performance reduces storage and speeds trend queries, at the cost of losing day-level metrics.

### **4. Suggestions for Improvement**

_(If you had more time, what would you add or change? e.g., CI/CD setup, performance optimizations, more advanced testing.)_

- Introduce daily-grain product performance for seasonality; keep monthly as an aggregate rollup.
- Create separate marts for cancellations/returns to analyze rates and reasons without polluting fulfillment KPIs.
- Add more dbt tests (unique, not_null, accepted_values) and enable freshness checks on seeds/sources.
- Set up CI (dbt build + tests) on pull requests and deploy docs with artifacts.
- Convert heavy marts to incremental where appropriate and add partitioning by date for performance.
- Expand documentation: model READMEs, column-level descriptions, lineage diagrams, and quickstart analysis guides for analysts.