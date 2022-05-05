const Router = require('@koa/router');
const router = new Router();
const nettrafficController = require('./controller');

router.get('/', nettrafficController.get);
router.delete('/all', nettrafficController.deleteData);

module.exports = router;