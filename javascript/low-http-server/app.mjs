import low from 'low-http-server';
import cero from '0http';

const { router, server } = cero({
  server: low(),
});

router.on('GET', '/', (req, res) => {
  res.end();
});

router.on('GET', '/user/:id', (req, res) => {
  res.end(req.params.id);
});

router.on('POST', '/user', (req, res) => {
  res.end();
});

server.listen(3000);
