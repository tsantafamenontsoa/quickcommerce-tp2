-- ============================================
-- QuickCommerce - Base de données PostgreSQL
-- ============================================

-- Table products
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Données de test (10 produits)
INSERT INTO products (name, price, stock) VALUES
('iPhone 14 Pro', 1199.00, 50),
('Samsung Galaxy S23', 999.00, 75),
('MacBook Pro M2', 2499.00, 30),
('Dell XPS 15', 1899.00, 40),
('AirPods Pro', 279.00, 200),
('Sony WH-1000XM5', 399.00, 150),
('iPad Air', 699.00, 100),
('Apple Watch Series 8', 499.00, 80),
('Nintendo Switch', 349.00, 120),
('PlayStation 5', 549.00, 25)
ON CONFLICT DO NOTHING;

-- Index pour optimiser les requêtes
CREATE INDEX IF NOT EXISTS idx_products_name ON products(name);
CREATE INDEX IF NOT EXISTS idx_products_price ON products(price);

-- Statistiques
ANALYZE products;

-- Message de confirmation
DO $$
BEGIN
    RAISE NOTICE '✅ Base de données QuickCommerce initialisée avec succès';
    RAISE NOTICE '📦 % produits insérés', (SELECT COUNT(*) FROM products);
END $$;
