CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    registration_date DATE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    brand VARCHAR(50),
    price NUMERIC(10,2)
);

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE sellers (
    seller_id SERIAL PRIMARY KEY,
    seller_name VARCHAR(100),
    seller_rating NUMERIC(2,1)
);

CREATE TABLE product_sellers (
    product_id INT,
    seller_id INT,
    PRIMARY KEY (product_id, seller_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id)
);

CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INT,
    street VARCHAR(150),
    pincode VARCHAR(10),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(50),
    total_amount NUMERIC(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE ordered_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price NUMERIC(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE shipment (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT,
    address_id INT,
    shipment_status VARCHAR(50),
    delivery_date DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);

CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE support (
    ticket_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_id INT,
    issue_statement TEXT,
    status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE responses (
    response_id SERIAL PRIMARY KEY,
    ticket_id INT,
    response_text TEXT,
    response_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES support(ticket_id)
);

CREATE TABLE discounts (
    discount_id SERIAL PRIMARY KEY,
    product_id INT,
    discount_percent NUMERIC(5,2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE wishlist (
    wishlist_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE cart_items (
    cart_item_id SERIAL PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE returns (
    return_id SERIAL PRIMARY KEY,
    order_item_id INT,
    return_reason TEXT,
    return_status VARCHAR(50),
    request_date DATE DEFAULT CURRENT_DATE,
    refund_amount NUMERIC(10,2),
    FOREIGN KEY (order_item_id) REFERENCES ordered_items(order_item_id)
);

CREATE TABLE coupons (
    coupon_id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE,
    discount_percent NUMERIC(5,2),
    expiry_date DATE,
    usage_limit INT
);

-- dummy data:

INSERT INTO customers (name, email, phone, registration_date)
VALUES 
('Siddhant', 'sid@gmail.com', '9876543210', CURRENT_DATE),
('Rahul', 'rahul@gmail.com', '9123456780', CURRENT_DATE),
('Amit', 'amit@gmail.com', '9988776655', CURRENT_DATE),
('Neha', 'neha@gmail.com', '9012345678', CURRENT_DATE),
('Priya', 'priya@gmail.com', '9090909090', CURRENT_DATE),
('Karan', 'karan@gmail.com', '9876501234', CURRENT_DATE);

INSERT INTO categories (category_name)
VALUES 
('Clothing'),
('Electronics'),
('Accessories');

INSERT INTO products (product_name, brand, price, category_id)
VALUES
('Shoes', 'Nike', 2999, 4),
('T-Shirt', 'Adidas', 1499, 1),
('Watch', 'Fossil', 5999, 3),
('Laptop Bag', 'Wildcraft', 1999, 5),
('Headphones', 'Sony', 3499, 2),
('Smartphone', 'Samsung', 15999, 2),

('Jeans', 'Levis', 2499, 1),
('Jacket', 'Zara', 3999, 1),

('Running Shoes', 'Puma', 3499, 4),
('Sneakers', 'Nike', 2999, 4),

('Bluetooth Speaker', 'JBL', 4999, 2),
('Power Bank', 'Mi', 1999, 2),

('Sunglasses', 'RayBan', 5999, 3),
('Wallet', 'Fastrack', 1499, 3),

('Backpack', 'American Tourister', 2999, 5),
('Duffel Bag', 'Wildcraft', 2499, 5),

('Smartwatch', 'Noise', 2999, 6),
('Tablet', 'Lenovo', 12999, 6);

INSERT INTO sellers (seller_name, seller_rating)
VALUES 
('SellerOne', 4.5),
('SellerTwo', 4.2),
('SellerThree', 4.7),
('SellerFour', 3.9),
('SellerFive', 4.3),
('SellerSix', 4.0);

INSERT INTO product_sellers VALUES
(1,1),(1,2),(2,2),(3,3),(4,4),(5,5),(6,6);

INSERT INTO addresses (customer_id, street, pincode)
VALUES 
(1, 'Street A', '400001'),
(2, 'Street B', '400002'),
(3, 'Street C', '400003'),
(4, 'Street D', '400004'),
(5, 'Street E', '400005'),
(6, 'Street F', '400006');

INSERT INTO orders (customer_id, order_status, total_amount)
VALUES
(1, 'Placed', 4498),
(2, 'Delivered', 1499),
(3, 'Shipped', 5999),
(4, 'Cancelled', 1999),
(5, 'Placed', 3499),
(6, 'Delivered', 15999);

INSERT INTO ordered_items (order_id, product_id, quantity, price)
VALUES
(1, 1, 1, 2999),
(1, 2, 1, 1499),
(2, 2, 1, 1499),
(3, 3, 1, 5999),
(4, 4, 1, 1999),
(5, 5, 1, 3499);

INSERT INTO payments (order_id, payment_method, payment_status)
VALUES
(1, 'UPI', 'Success'),
(2, 'Card', 'Success'),
(3, 'Net Banking', 'Success'),
(4, 'UPI', 'Failed'),
(5, 'Cash on Delivery', 'Pending'),
(6, 'Card', 'Success');

INSERT INTO shipment (order_id, address_id, shipment_status, delivery_date)
VALUES
(1, 1, 'Shipped', CURRENT_DATE),
(2, 2, 'Delivered', CURRENT_DATE),
(3, 3, 'In Transit', CURRENT_DATE),
(4, 4, 'Cancelled', CURRENT_DATE),
(5, 5, 'Shipped', CURRENT_DATE),
(6, 6, 'Delivered', CURRENT_DATE);

INSERT INTO reviews (customer_id, product_id, rating, review_text)
VALUES
(1, 1, 5, 'Excellent product'),
(2, 2, 4, 'Good quality'),
(3, 3, 5, 'Worth the price'),
(4, 4, 3, 'Average product'),
(5, 5, 4, 'Nice and comfortable'),
(6, 6, 5, 'Highly recommended');

INSERT INTO support (customer_id, order_id, issue_statement, status)
VALUES
(1, 1, 'Late delivery', 'Open'),
(2, 2, 'Wrong item received', 'Resolved'),
(3, 3, 'Payment issue', 'Open'),
(4, 4, 'Order cancelled automatically', 'Closed'),
(5, 5, 'Product damaged', 'Open'),
(6, 6, 'Need invoice copy', 'Resolved');

INSERT INTO responses (ticket_id, response_text)
VALUES
(1, 'We are checking your issue'),
(2, 'Replacement has been initiated'),
(3, 'Please retry payment'),
(4, 'Order cancelled due to stock issue'),
(5, 'Return has been approved'),
(6, 'Invoice sent to your email');

INSERT INTO discounts (product_id, discount_percent, start_date, end_date)
VALUES
(1, 10, CURRENT_DATE, CURRENT_DATE + INTERVAL '10 days'),
(2, 15, CURRENT_DATE, CURRENT_DATE + INTERVAL '5 days'),
(3, 20, CURRENT_DATE, CURRENT_DATE + INTERVAL '7 days'),
(4, 5, CURRENT_DATE, CURRENT_DATE + INTERVAL '3 days'),
(5, 25, CURRENT_DATE, CURRENT_DATE + INTERVAL '8 days'),
(6, 12, CURRENT_DATE, CURRENT_DATE + INTERVAL '6 days');

INSERT INTO wishlist (customer_id, product_id)
VALUES
(1, 3),
(2, 1),
(3, 5),
(4, 2),
(5, 6),
(6, 4);

INSERT INTO cart_items (customer_id, product_id, quantity)
VALUES
(1, 6, 1),
(2, 3, 2),
(3, 1, 1),
(4, 5, 1),
(5, 2, 3),
(6, 4, 1);

INSERT INTO returns (order_item_id, return_reason, return_status, refund_amount)
VALUES
(1, 'Size issue', 'Approved', 2999),
(2, 'Not needed', 'Pending', 1499),
(3, 'Defective product', 'Approved', 1499),
(4, 'Wrong item', 'Rejected', 5999),
(5, 'Damaged', 'Approved', 1999),
(6, 'Late delivery', 'Pending', 3499);

INSERT INTO coupons (code, discount_percent, expiry_date, usage_limit)
VALUES
('NEW10', 10, CURRENT_DATE + INTERVAL '30 days', 100),
('SALE20', 20, CURRENT_DATE + INTERVAL '20 days', 50),
('FEST15', 15, CURRENT_DATE + INTERVAL '25 days', 75),
('WELCOME5', 5, CURRENT_DATE + INTERVAL '40 days', 200),
('BIG30', 30, CURRENT_DATE + INTERVAL '10 days', 20),
('SAVE12', 12, CURRENT_DATE + INTERVAL '15 days', 60);

ALTER TABLE orders ADD coupon_id INT;
ALTER TABLE orders ADD FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id);

INSERT INTO categories (category_name)
VALUES
('Clothing'),
('Electronics'),
('Accessories'),
('Footwear'),
('Bags'),
('Gadgets');
