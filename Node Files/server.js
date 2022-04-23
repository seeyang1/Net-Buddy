var Koa = require('koa');  
var app = new Koa(); 

var port = 1337;

const Router = require('@koa/router');
const publicRouter = new Router();
const protectedRouter = new Router();

//nettraffic router then have the public Router use that router
const nettrafficRouter = require('./nettraffic/router.js')
const bodyParser = require('koa-body');


publicRouter.use('/nettraffic', nettrafficRouter.routes(), nettrafficRouter.allowedMethods());

app.use(bodyParser())
    .use(publicRouter.routes())
    .use(publicRouter.allowedMethods());

app.listen(port);
console.log(`Listening on port: ${port}`);

