const express = require('express');
const app = express();
const con = require('./db');

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// login
app.post('/login', (req, res) => {
    const {username, password} = req.body;
    const sql = "SELECT id, password FROM user WHERE username = ?";
    con.query(sql, [username], function(err, results) {
        if(err) {
            return res.status(500).send("Database server error");
        }
        if(results.length != 1) {
            return res.status(401).send("Wrong username");
        }
        // compare passwords
        bcrypt.compare(password, results[0].password, function(err, same) {
            if(err) {
                return res.status(500).send("Hashing error");
            }
            if(same) {
                return res.json({ message: "Login OK", userId: results[0].id });
            }
            return res.status(401).send("Wrong password");
        });
    })
});

// 1. Show all expenses
app.get('/expenses', (_req, res) => {
    const sql = "SELECT * FROM expense";
    con.query(sql, function (err, results) {
        if (err) {
            return res.status(500).send("Database server error");
        }
        res.json(results);
    })
});

// 2. Show all users
app.get('/users', (_req, res) => {
    const sql = "SELECT * FROM users";
    con.query(sql, function (err, results) {
        if (err) {
            return res.status(500).send("Database server error");
        }
        res.json(results);
    })
});

// 3. Show today’s expenses
app.get('/expenses/today', (_req, res) => {
    const sql = "SELECT * FROM expense WHERE DATE(date) = CURDATE()";
    con.query(sql, (err, results) => {
        if (err) return res.status(500).send("Database server error");
        res.json(results);
    });
});

// 4. Search expenses by keyword
app.get('/expenses/search/:keyword', (req, res) => {
    const keyword = `%${req.params.keyword}%`;
    const sql = "SELECT * FROM expense WHERE description LIKE ?";
    con.query(sql, [keyword], (err, results) => {
        if (err) return res.status(500).send("Database server error");
        if (results.length === 0) return res.send("No items found with that keyword");
        res.json(results);
    });
});

// 5. Add new expense
app.post('/expenses', (req, res) => {
    const { user_id, description, amount } = req.body;
    const sql = "INSERT INTO expense (user_id, description, amount, date) VALUES (?, ?, ?, NOW())";
    con.query(sql, [user_id, description, amount], (err, result) => {
        if (err) return res.status(500).send("Database server error");
        res.json({ message: "Expense added", id: result.insertId });
    });
});

// 6. Delete expense by ID
app.delete('/expenses/:id', (req, res) => {
    const id = req.params.id;
    const sql = "DELETE FROM expense WHERE id = ?";
    con.query(sql, [id], (err, result) => {
        if (err) return res.status(500).send("Database server error");
        if (result.affectedRows === 0) return res.status(404).send("Expense not found");
        res.json({ message: "Expense deleted", id });
    });
});


// ---------- Server starts here ---------
const PORT = 3000;
app.listen(PORT, () => {
    console.log('Server is running at ' + PORT);
});

