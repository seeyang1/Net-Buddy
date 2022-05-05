const mariadb = require('mariadb');
const Connection = require('mysql/lib/Connection');
require('dotenv/config')
var db = mariadb.createPool({
    multipleStatements: true,
    host: process.env.db_host,
    user: process.env.db_user,
    password: process.env.db_password,
    database: process.env.db_database,
});
var dbConn = db.getConnection();
dbConn.then((con) => {
    console.log("Database Connected");
    con.end();
})
.catch(err => {
    console.log(err);
});
module.exports = db;