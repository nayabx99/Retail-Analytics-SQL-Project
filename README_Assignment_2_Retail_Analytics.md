# Assignment 2: Retail Business SQL Analysis

**Database:** PostgreSQL  
**Tool:** pgAdmin 4

## Project overview
This project uses SQL to answer 15 business questions about a retail dataset containing customers, products, employees, orders, order items, and returns.

## Files
- `Assignment_2_Retail_Analytics_Queries.sql` — SQL answers for Q1–Q15.
- `Retail_Analytics_PostgreSQL_Setup.sql` — PostgreSQL-compatible setup script used to create and load the provided sample tables (only run once in a new `retail_analytics` database).

## Business rules
- Gross line-item value = quantity × `unit_price_at_sale`.
- Net line-item value = quantity × `unit_price_at_sale` × (1 − `discount_rate`).
- Revenue questions include only orders with `order_status = 'Delivered'`, unless the question asks for a different status.
- Returned and cancelled orders are not counted as delivered revenue.

## Assumption for Q14
The average customer net revenue is calculated across all customers, including customers with zero delivered revenue.

## How to run
1. Use the separate `retail_analytics` PostgreSQL database.
2. If the database has not been set up yet, run `Retail_Analytics_PostgreSQL_Setup.sql` once in that database.
3. Open `Assignment_2_Retail_Analytics_Queries.sql` in pgAdmin Query Tool.
4. Run one question at a time by selecting that query and pressing F5.
5. Do not run the setup script again after the tables and data have already been created.

## Submission
Upload the SQL query file and this documentation to the GitHub repository, then submit the repository link as required by the assignment.
