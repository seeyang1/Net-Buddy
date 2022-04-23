const Router = require('@koa/router');
const router = new Router();
const nettrafficController = require('./controller');

router.get('/', nettrafficController.get);

module.exports = router;