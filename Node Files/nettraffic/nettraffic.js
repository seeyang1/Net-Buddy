const mariaDB = require('../database.js')
class Nettraffic {
    static async getNettraffic() {
        const query = 'SELECT * FROM nettraffic';
        let conn;
        try {
            conn = await mariaDB.getConnection();
            const traffic = await conn.query(query);
            console.log(traffic)
            return traffic;
        } catch (err) {
            console.error(err);
        } finally {
            if (conn) {conn.end();}
        }
    }
}

module.exports = Nettraffic;
