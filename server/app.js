const express = require('express');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const con = require('./db');

app.get('/expense', (_req, res) => {
    const sql = "SELECT * FROM expense";
    con.query(sql, function(err, results) {
        if(err) {
            return res.status(500).send("Database server error");
        }
        res.json(results);
    })
});

app.get('/users', (_req, res) => {
    const sql = "SELECT * FROM users";
    con.query(sql, function(err, results) {
        if(err) {
            return res.status(500).send("Database server error");
        }
        res.json(results);
    })
});

// ---------- Server starts here ---------
const PORT = 3000;
app.listen(PORT, () => {
    console.log('Server is running at ' + PORT);
});

