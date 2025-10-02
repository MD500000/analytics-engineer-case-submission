# Analytics Engineer - Take-Home Case Study

### **Introduction**

Welcome! This case study is designed to simulate a typical project for an Analytics Engineer on our Data & Integration team. Our goal is to see how you approach a real-world dataset and transform it into a valuable, trusted analytical asset.

This exercise focuses on your data modeling philosophy, technical skills with modern tools, and your ability to create a foundation for business insights, all while adhering to software engineering best practices.

**Fictional Company Context:** You are a new Analytics Engineer at **"Nordic Trail Outfitters,"** an e-commerce company specializing in outdoor and hiking gear. We've just acquired a new company that operates in Brazil, and we need you to analyze their historical sales data to understand their business.

### **The Project Environment**

This repository is a self-contained, ready-to-use `dbt` project. We have already handled the initial setup to allow you to focus on the core analytics engineering tasks.

Included in this repository:

- A standard `dbt` project structure.
- `uv` for simple and fast Python environment and dependency management (see `pyproject.toml`).
- The raw **Brazilian E-Commerce Public Dataset by Olist** located in the `seeds` directory.
- A pre-configured `profiles.yml` that configures `dbt` to use a local `duckdb` database file (`olist.duckdb`), which will be created in the project directory.

### **Getting Started**

To begin, clone this repository and ensure you have `uv` installed (`pip install uv`). Then, follow these steps in your terminal:

1. **Install Dependencies:** Create the virtual environment and install all dependencies from `pyproject.toml`.

   ```
   uv sync
   ```

2. **Load Raw Data:** Use the `dbt seed` command to load all the raw CSV files from the `seeds` directory into your local `duckdb` database.

   ```
   uv run dbt seed
   ```

3. **Verify Setup:** You can verify that the data has been loaded correcly running the test model

   ```
   uv run dbt run
   ```

this should output test.parquet file into the data folder

You are now ready to begin development!

PRO TIP: if you want a nice ui to work with your data, after you have run the seed cmd you run `duckdb -ui` and inside the ui attach dev.duckdb. See: https://duckdb.org/2025/03/12/duckdb-ui.html

### **Your Mission**

The leadership team needs to understand the performance of our newly acquired Brazilian operation. Your mission is to create a well-modeled data warehouse foundation using `dbt` that will empower our business analysts to answer critical questions and power their future BI dashboards.

Your final data models should be designed to easily answer high-level business questions like:

- **Customer Behavior:** Who are our most valuable customers? What are their purchasing patterns?
- **Product Performance:** What are our best-selling products and product categories?
- **Geographic Performance:** Where are our key markets geographically (by city/state)?
- **Order Fulfillment:** What is the average time between an order being placed and delivered? How does this vary?

### **Core Tasks**

1. **Model the Data:**

   - Following `dbt` best practices, transform the raw data into a logical, multi-layered architecture (e.g., staging, intermediate, marts).
   - You have the freedom to decide on the final data models. Your choices should be driven by the goal of answering the business questions listed above. Consider creating models like a `fct_orders` (fact table) and `dim_customers` (dimension table), or other structures you feel are appropriate.

2. **Ensure Data Trust:**

   - Implement comprehensive `dbt` tests (both generic and custom) to ensure the accuracy, integrity, and validity of your data models. Quality is more important than quantity.

3. **Document Your Work:**

   - Use `dbt`'s documentation features (`dbt docs generate`) by adding descriptions for your models and columns in `.yml` files.
   - **Crucially, you must update the second half of this `README.md` file** in your submission to explain your work to the hiring team.

### **Final Deliverable**

Your final deliverable is a link to your forked repository containing all your completed work.

Please complete the sections below in this `README.md` file. Your written explanations are as important as your code.

## **Candidate Submission**

### **1. How to Run This Project**

_(Please add any specific instructions for running your final models and tests here. For example: `uv run dbt build`)_

### **2. Data Modeling Decisions**

_(This is the most important section. Please justify your architectural choices.)_

- **Architectural Pattern:** _(e.g., "I chose a dimensional model with fact and dimension tables because...")_
- **Key Models:** _(Describe the purpose of your main Silver/Gold layer models. For example:)_
  - `dim_customers`: _This model provides a single, clean view of every customer..._
  - `fct_orders`: _This model captures every order event and includes key metrics like..._
- **Answering Business Questions:** _(Explain how your models would be used to answer one of the business questions from the challenge. For example: "To find our most valuable customers, an analyst could join `dim_customers` with `fct_orders` and sum the `total_amount` per customer...")_

### **3. Assumptions & Trade-offs**

_(Briefly describe any assumptions you made and any trade-offs you considered.)_

- **Assumptions:** _(e.g., "I assumed that any order without a `delivered_at` timestamp is still in-flight and excluded it from delivery time calculations.")_
- **Trade-offs:** _(e.g., "For performance, I chose to denormalize the product category directly into the `fct_orders` table. This increases data redundancy but simplifies queries for analysts, avoiding an extra join.")_

### **4. Suggestions for Improvement**

_(If you had more time, what would you add or change? e.g., CI/CD setup, performance optimizations, more advanced testing.)_
