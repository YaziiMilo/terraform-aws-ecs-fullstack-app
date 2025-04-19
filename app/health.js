// Adding a health check endpoint to the Express app
// This will be called in app.js

module.exports = function setupHealthCheck(app) {
  app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok' });
  });
}; 