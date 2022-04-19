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

module.exports = config; 
