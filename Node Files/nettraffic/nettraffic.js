const mariaDB = require('../database.js')
class Nettraffic {
    static async getNettraffic() {
        const query = 'SELECT * FROM nettraffic;';
        let conn;
        try {
            conn = await mariaDB.getConnection();
            const traffic = await conn.query(query);
            return traffic;
        } catch (err) {
            console.error(err);
        } finally {
            if (conn) {conn.end();}
        }
    }

    // This function used for clearing the table in the database
    static async deleteData() {
        const query = 'DELETE FROM nettraffic;';
        let conn;
        try {
            conn = await mariaDB.getConnection();
            await conn.beginTransaction();
            await conn.query(query);
            await conn.commit();
            return 204;
        } catch(err) {
            await conn.rollback();
            console.error(err);
        } finally {
            if (conn) {
                conn.end();
            }
        }
    }
}

module.exports = Nettraffic;
