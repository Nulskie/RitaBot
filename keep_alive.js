const express = require('express');
const app = express();
app.get('/', (req, res) => res.send('RitaBot is Alive!'));
app.listen(process.env.PORT || 3000, () => console.log('Keep-alive server is running.'));
