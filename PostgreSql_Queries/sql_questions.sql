-- Questions:

-- 1. Find all customers from a specific pincode.
SELECT c.*
FROM customers c
JOIN addresses a ON c.customer_id = a.customer_id
WHERE a.pincode = '400001';

-- 2. Display all products with price greater than ₹1000.
SELECT * 
FROM products
WHERE price > 1000;

-- 3. List all orders placed by a particular customer.
SELECT *
FROM orders
WHERE customer_id = 1;

-- 4. Show all sellers with rating above 4.
SELECT *
FROM sellers
WHERE seller_rating > 4;

-- 5. Retrieve all products belonging to a specific category.
SELECT p.*
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics';

-- 6. Find all reviews given by a specific customer.
SELECT *
FROM reviews
WHERE customer_id = 1;

-- 7. Display all orders placed on a particular date.
SELECT *
FROM orders
WHERE DATE(order_date) = CURRENT_DATE;

-- 8. List all products currently in a customer’s cart.
SELECT p.product_name, c.quantity
FROM cart_items c
JOIN products p ON c.product_id = p.product_id
WHERE c.customer_id = 1;

-- 9. Show all coupons that are not expired.
SELECT *
FROM coupons
WHERE expiry_date > CURRENT_DATE;

-- 10. Display all shipments with status “Delivered”.
SELECT *
FROM shipment
WHERE shipment_status = 'Delivered';

-- 11. Find total number of orders placed by each customer.
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;

-- 12. Display the total amount spent by each customer.
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- 13. Find the average rating of each product.
SELECT product_id, AVG(rating) AS avg_rating
FROM reviews
GROUP BY product_id;

-- 14. List all products with no reviews.
SELECT p.*
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
WHERE r.product_id IS NULL;

-- 15. Find customers who have never placed any order.
SELECT c.*
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- 16. Display the most expensive product in each category.
SELECT p.*
FROM products p
JOIN (
    SELECT category_id, MAX(price) AS max_price
    FROM products
    GROUP BY category_id
) sub
ON p.category_id = sub.category_id AND p.price = sub.max_price;

-- 17. Find all orders with more than 1 items.
SELECT order_id, COUNT(*) AS total_items
FROM ordered_items
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 18. List all sellers who sell a specific product.
SELECT s.*
FROM sellers s
JOIN product_sellers ps ON s.seller_id = ps.seller_id
WHERE ps.product_id = 1;

-- 19. Find the total number of products sold by each seller.
SELECT s.seller_name, COUNT(oi.product_id) AS total_sold
FROM sellers s
JOIN product_sellers ps ON s.seller_id = ps.seller_id
JOIN ordered_items oi ON ps.product_id = oi.product_id
GROUP BY s.seller_name;

-- 20. Display customers who have items in their cart but haven’t placed an order.
SELECT DISTINCT c.*
FROM customers c
JOIN cart_items ci ON c.customer_id = ci.customer_id
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- 21. Find all orders where a coupon was applied.
SELECT *
FROM orders
WHERE coupon_id IS NOT NULL;

-- 22. Show products that are in wishlist but not purchased.
SELECT DISTINCT p.*
FROM products p
JOIN wishlist w ON p.product_id = w.product_id
LEFT JOIN ordered_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 23. Find top 5 most ordered products.
SELECT p.product_name, COUNT(oi.product_id) AS total_orders
FROM ordered_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC
LIMIT 5;

-- 24. Display total revenue generated per category.
SELECT c.category_name, SUM(oi.quantity * oi.price) AS revenue
FROM ordered_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- 25. Find all returned items with reason “Damaged”.
SELECT *
FROM returns
WHERE LOWER(return_reason) = 'damaged';

-- 26. Find the customer who has spent the highest total amount.
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

-- 27. Display the product with highest average rating.
SELECT p.product_name, AVG(r.rating) AS avg_rating
FROM products p
JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_name
ORDER BY avg_rating DESC
LIMIT 1;

-- 28. Find the seller with maximum sales.
SELECT s.seller_name, COUNT(oi.product_id) AS total_sales
FROM sellers s
JOIN product_sellers ps ON s.seller_id = ps.seller_id
JOIN ordered_items oi ON ps.product_id = oi.product_id
GROUP BY s.seller_name
ORDER BY total_sales DESC
LIMIT 1;

-- 29. List customers who have placed orders from multiple sellers.
SELECT c.name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN ordered_items oi ON o.order_id = oi.order_id
JOIN product_sellers ps ON oi.product_id = ps.product_id
GROUP BY c.name
HAVING COUNT(DISTINCT ps.seller_id) > 1;

-- 30. Find the day with highest total sales.
SELECT DATE(order_date) AS day, SUM(total_amount) AS total_sales
FROM orders
GROUP BY day
ORDER BY total_sales DESC
LIMIT 1;

-- 31. Display customers who have both returned and reviewed products.
SELECT DISTINCT c.*
FROM customers c
JOIN reviews r ON c.customer_id = r.customer_id
JOIN orders o ON c.customer_id = o.customer_id
JOIN ordered_items oi ON o.order_id = oi.order_id
JOIN returns ret ON oi.order_item_id = ret.order_item_id;

-- 32. Find products that have never been ordered.
SELECT p.*
FROM products p
LEFT JOIN ordered_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- 33. List top 3 customers based on number of orders.
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_orders DESC
LIMIT 3;

-- 34. Find orders that contain products from multiple categories.
SELECT o.order_id
FROM orders o
JOIN ordered_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_id
HAVING COUNT(DISTINCT p.category_id) > 1;

-- 35. Display average order value per customer.
SELECT c.name, AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name;

-- 36. Find customers whose total spending is above average spending of all customers.
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING SUM(o.total_amount) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(total_amount) AS total_spent
        FROM orders
        GROUP BY customer_id
    ) sub
);

-- 37. Display products whose price is higher than average price of their category.
SELECT p.product_name, p.price
FROM products p
JOIN (
    SELECT category_id, AVG(price) AS avg_price
    FROM products
    GROUP BY category_id
) sub
ON p.category_id = sub.category_id
WHERE p.price > sub.avg_price;

-- 38. Find sellers who have sold all products in a given category.
SELECT s.seller_name
FROM sellers s
WHERE NOT EXISTS (
    SELECT p.product_id
    FROM products p
    WHERE p.category_id = 1  -- change category here
    AND NOT EXISTS (
        SELECT 1
        FROM product_sellers ps
        JOIN ordered_items oi ON ps.product_id = oi.product_id
        WHERE ps.seller_id = s.seller_id
        AND ps.product_id = p.product_id
    )
);

-- 39. List customers who ordered the same product more than once.
SELECT c.name, oi.product_id, COUNT(*) AS times_ordered
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN ordered_items oi ON o.order_id = oi.order_id
GROUP BY c.name, oi.product_id
HAVING COUNT(*) > 1;

-- 40. Find the most frequently used coupon.
SELECT coupon_id, COUNT(*) AS usage_count
FROM orders
WHERE coupon_id IS NOT NULL
GROUP BY coupon_id
ORDER BY usage_count DESC
LIMIT 1;

