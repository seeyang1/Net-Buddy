const nettrafficModel = require('./nettraffic');

class NettrafficController {

    /* eslint-disable no param-reassign */
    /** 
     * 
     * @param {ctx} Koa Context
     */
    async get(ctx) {
        let nettraffic = await nettrafficModel.getNettraffic();
        if (nettraffic === undefined) {
            ctx.throw(500);
        } else {
            ctx.status = 200;
            ctx.body = nettraffic;
        }
    }

    /** 
     * 
     * @param {ctx} Koa Context
     */
    // this function for clearing the database (if needed)
    async deleteData(ctx) {
        let nettraffic = await nettrafficModel.deleteData();
        if (nettraffic && nettraffic < 400) {
            ctx.status = nettraffic;
        } else if (nettraffic && nettraffic >= 400) {
            ctx.throw(nettraffic);
        }
    }

    /* at some point will need getById(ctx) ///////
    async getById(ctx) {
        let nettraffic = await nettrafficModel.getNettraffic(ctx.params.id);
        if (nettraffic) {
            ctx.status = 200;
            ctx.body = nettraffic;
        } else {
            ctx.throw(400);
        }
    }
    */
}

module.exports = new NettrafficController();