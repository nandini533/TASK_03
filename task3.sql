SELECT product_name, rating
FROM amazon_products
WHERE category LIKE '%Computers&Accessories%'
ORDER BY CAST(rating AS FLOAT) DESC
LIMIT 10;

-- Count of products grouped by category
SELECT category, COUNT(*) AS product_count
FROM amazon_products
GROUP BY category
ORDER BY product_count DESC;

-- INNER JOIN to show product with review and user
SELECT p.product_name, r.review_title, u.user_name
FROM products p
INNER JOIN reviews r ON p.product_id = r.product_id
INNER JOIN users u ON r.user_id = u.user_id;

-- LEFT JOIN to show products even if they have no reviews
SELECT p.product_name, r.review_title
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id;

-- RIGHT JOIN (less common, but valid for showing reviews even if product record is missing)
SELECT r.review_title, p.product_name
FROM reviews r
RIGHT JOIN products p ON p.product_id = r.product_id;


-- Products that have higher-than-average rating
SELECT product_name, rating
FROM amazon_products
WHERE CAST(rating AS FLOAT) > (
    SELECT AVG(CAST(rating AS FLOAT)) FROM amazon_products
);


-- Average discount percentage
SELECT AVG(CAST(REPLACE(discount_percentage, '%', '') AS FLOAT)) AS avg_discount
FROM amazon_products;


-- Total number of ratings
SELECT SUM(CAST(REPLACE(rating_count, ',', '') AS INT)) AS total_ratings
FROM amazon_products;


-- View for discounted products and savings
CREATE VIEW discounted_product_summary AS
SELECT product_name,
       CAST(REPLACE(actual_price, '₹', '') AS FLOAT) AS actual_price,
       CAST(REPLACE(discounted_price, '₹', '') AS FLOAT) AS discounted_price,
       (CAST(REPLACE(actual_price, '₹', '') AS FLOAT) - 
        CAST(REPLACE(discounted_price, '₹', '') AS FLOAT)) AS savings
FROM amazon_products;

-- Create index on rating for faster filtering/sorting
CREATE INDEX idx_rating ON amazon_products(CAST(rating AS FLOAT));

-- Create index on category for grouping
CREATE INDEX idx_category ON amazon_products(category);

-- Create index on product_id for joins
CREATE INDEX idx_product_id ON amazon_products(product_id);