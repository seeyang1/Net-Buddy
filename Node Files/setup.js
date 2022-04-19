const mysql = require('mysql');
const fs = require('fs');

var config =
{
    host: 'net-buddy.mysql.database.azure.com',
    user: 'nbseniordesign',
    password: 'j7Zp4wohzfR9n3',
    database: 'packet_sniffing',
    port: 3306,
    ssl: {ca: fs.readFileSync("/Users/nickdimitrakas/Developer/Github/SeniorDesign/nodejsmysql/DigiCertGlobalRootCA.crt.pem")}
};

const conn = new mysql.createConnection(config);

conn.connect(
    function (err) { 
        if (err) { 
            console.log("!!! Cannot connect !!! Error:");
            throw err;
        }
        else {
            console.log("Connection established.");
            readData();
	
        }
    });

function readData(){
    conn.query('SELECT * FROM nettraffic', 
        function (err, results, fields) {
            if (err) throw err;
            else console.log('Selected ' + results.length + ' row(s).');
            for (i = 0; i < results.length; i++) {
                console.log('Row: ' + JSON.stringify(results[i]));
            }
            console.log('Done.');
        })
    conn.end(
        function (err) { 
            if (err) throw err;
            else  console.log('Closing connection.') 
    });
};
