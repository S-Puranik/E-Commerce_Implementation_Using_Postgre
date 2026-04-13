const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'ecommerce_db',
    password: 'pass1234@',
    port: 5432,
});

app.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT NOW()');
        res.send(result.rows);
    } catch (err) {
        console.error(err);
        res.send("Error connecting to DB");
    }
});

app.delete('/cart/:product_id', async (req, res) => {
    const { product_id } = req.params;

    await pool.query(
        'DELETE FROM cart_items WHERE product_id = $1',
        [product_id]
    );

    res.send("Deleted");
});

app.get('/products', async (req, res) => {
    try {
        const result = await pool.query(
            `SELECT p.product_id, p.product_name, p.price, c.category_name
             FROM products p
             JOIN categories c ON p.category_id = c.category_id`
        );

        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching products');
    }
});

app.get('/cart/:customer_id', async (req, res) => {
    try {
        const { customer_id } = req.params;

        const result = await pool.query(
            `SELECT p.product_name, p.price, c.quantity
             FROM cart_items c
             JOIN products p ON c.product_id = p.product_id
             WHERE c.customer_id = $1`,
            [customer_id]
        );

        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching cart items');
    }
});

app.get('/cart/:customer_id', async (req, res) => {
    try {
        const { customer_id } = req.params;

        const result = await pool.query(
            `SELECT p.product_id, p.product_name, p.price, c.quantity
             FROM cart_items c
             JOIN products p ON c.product_id = p.product_id
             WHERE c.customer_id = $1`,
            [customer_id]
        );

        res.json(result.rows);

    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching cart');
    }
});

app.get('/orders/:customer_id', async (req, res) => {
    try {
        const { customer_id } = req.params;

        const result = await pool.query(
            `SELECT o.order_id, o.order_date, o.total_amount,
                    p.product_name, oi.quantity, oi.price
             FROM orders o
             JOIN ordered_items oi ON o.order_id = oi.order_id
             JOIN products p ON oi.product_id = p.product_id
             WHERE o.customer_id = $1
             ORDER BY o.order_id`,
            [customer_id]
        );

        res.json(result.rows);

    } catch (err) {
        console.error(err);
        res.status(500).send('Error fetching orders');
    }
});

app.post('/order', async (req, res) => {
    const client = await pool.connect();

    try {
        const { customer_id, items } = req.body;

        // Start transaction
        await client.query('BEGIN');

        // 1. Create order
        const orderResult = await client.query(
            `INSERT INTO orders (customer_id, order_status, total_amount)
             VALUES ($1, $2, $3)
             RETURNING *`,
            [customer_id, 'Placed', 0]
        );

        const order_id = orderResult.rows[0].order_id;

        let total_amount = 0;

        // 2. Insert ordered items
        for (let item of items) {
            const product = await client.query(
                'SELECT price FROM products WHERE product_id = $1',
                [item.product_id]
            );

            const price = product.rows[0].price;
            total_amount += price * item.quantity;

            await client.query(
                `INSERT INTO ordered_items (order_id, product_id, quantity, price)
                 VALUES ($1, $2, $3, $4)`,
                [order_id, item.product_id, item.quantity, price]
            );
        }

        // 3. Update total amount
        await client.query(
            `UPDATE orders SET total_amount = $1 WHERE order_id = $2`,
            [total_amount, order_id]
        );

        // Commit transaction
        await client.query('COMMIT');

        res.json({
            message: 'Order placed successfully',
            order_id,
            total_amount
        });

    } catch (err) {
        await client.query('ROLLBACK');
        console.error(err);
        res.status(500).send('Error placing order');
    } finally {
        client.release();
    }
});

app.post('/cart', async (req, res) => {
    try {
        const { customer_id, product_id, quantity } = req.body;

        console.log("Incoming cart request:", req.body); // 👈 DEBUG

        const result = await pool.query(
            `INSERT INTO cart_items (customer_id, product_id, quantity)
             VALUES ($1, $2, $3)
             RETURNING *`,
            [customer_id, product_id, quantity]
        );

        res.json({
            message: 'Item added to cart',
            data: result.rows[0]
        });

    } catch (err) {
        console.error(err);
        res.status(500).send('Error adding to cart');
    }
});

app.post('/wishlist', async (req, res) => {
    try {
        const { customer_id, product_id } = req.body;

        const result = await pool.query(
            `INSERT INTO wishlist (customer_id, product_id)
             VALUES ($1, $2)
             RETURNING *`,
            [customer_id, product_id]
        );

        res.json({
            message: "Added to wishlist",
            data: result.rows[0]
        });

    } catch (err) {
        console.error(err);
        res.status(500).send("Error adding to wishlist");
    }
});

app.post('/order', async (req, res) => {
    try {
        const { customer_id, items, total_amount } = req.body;

        // 1. Create order
        const orderResult = await pool.query(
            `INSERT INTO orders (customer_id, order_date, order_status, total_amount)
             VALUES ($1, CURRENT_DATE, 'Placed', $2)
             RETURNING order_id`,
            [customer_id, total_amount]
        );

        const order_id = orderResult.rows[0].order_id;

        // 2. Insert ordered items
        for (let item of items) {
            await pool.query(
                `INSERT INTO ordered_items (order_id, product_id, quantity, price)
                 VALUES ($1, $2, $3, $4)`,
                [order_id, item.product_id, item.quantity, item.price]
            );
        }

        res.json({
            message: "Order placed successfully",
            order_id
        });

    } catch (err) {
        console.error(err);
        res.status(500).send("Error placing order");
    }
});



app.listen(3000, () => {
    console.log('Server running on port 3000');
});