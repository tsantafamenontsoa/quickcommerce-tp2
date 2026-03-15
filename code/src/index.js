const express = require('express');
const cors = require('cors');
const database = require('./config/database');
const redis = require('./config/redis');
const errorHandler = require('./middleware/errorHandler');

const app = express();
const PORT = process.env.PORT || 3000;
const INSTANCE_ID = process.env.INSTANCE_ID || 'unknown';

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/health', async (req, res) => {
  try {
    // Vérifier connexion BDD
    const dbCheck = await database.query('SELECT 1');
    
    // Vérifier connexion Redis
    const redisCheck = await redis.ping();
    
    res.json({
      status: 'healthy',
      instance: INSTANCE_ID,
      timestamp: new Date().toISOString(),
      database: dbCheck ? 'connected' : 'disconnected',
      cache: redisCheck === 'PONG' ? 'connected' : 'disconnected'
    });
  } catch (error) {
    res.status(500).json({
      status: 'unhealthy',
      instance: INSTANCE_ID,
      error: error.message
    });
  }
});

// Import routes
const productsRouter = require('./routes/products');
app.use('/api/products', productsRouter);

// Error handler
app.use(errorHandler);

// Démarrage serveur
app.listen(PORT, () => {
  console.log(`🚀 API ${INSTANCE_ID} démarrée sur le port ${PORT}`);
  console.log(`📊 Environment: ${process.env.NODE_ENV}`);
  console.log(`🗄️  Database: ${process.env.DB_HOST}:${process.env.DB_PORT}`);
  console.log(`🔴 Redis: ${process.env.REDIS_HOST}:${process.env.REDIS_PORT}`);
});

// Graceful shutdown
process.on('SIGTERM', async () => {
  console.log('SIGTERM reçu, fermeture gracieuse...');
  await database.end();
  await redis.quit();
  process.exit(0);
});
