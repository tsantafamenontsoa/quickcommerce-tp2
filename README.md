# TP2 - QuickCommerce Infrastructure AWS

Architecture résiliente avec 7 conteneurs Docker simulant une infrastructure AWS complète.

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│     LOAD BALANCER (Nginx)               │
│          Port 80                         │
└──────────┬──────────┬──────────┬─────────┘
           │          │          │
    ┌──────▼─┐   ┌───▼────┐  ┌──▼─────┐
    │ API-1  │   │ API-2  │  │ API-3  │
    │Node.js │   │Node.js │  │Node.js │
    └───┬────┘   └───┬────┘  └───┬────┘
        │            │           │
        └────────────┼───────────┘
                     │
          ┌──────────▼──────────┐
          │ PostgreSQL Primary  │
          │   + Replica         │
          │   (Multi-AZ)        │
          └──────────┬──────────┘
                     │
          ┌──────────▼──────────┐
          │   Redis Cache       │
          │  (ElastiCache)      │
          └─────────────────────┘
```

## 🚀 Démarrage Rapide

```bash
# Cloner le projet
git clone <URL_REPO>
cd quickcommerce-tp2

# Lancer les 8 conteneurs
docker-compose up -d

# Vérifier le déploiement
docker ps

# Tester l'API via Load Balancer
curl http://localhost/health
```

## 📦 Conteneurs Déployés

| Conteneur | Rôle | Port |
|-----------|------|------|
| `quickcommerce_lb` | Load Balancer | 80 |
| `quickcommerce_api_1` | API Instance 1 | - |
| `quickcommerce_api_2` | API Instance 2 | - |
| `quickcommerce_api_3` | API Instance 3 | - |
| `quickcommerce_postgres_primary` | BDD Principale | 5432 |
| `quickcommerce_postgres_replica` | BDD Réplica | - |
| `quickcommerce_redis` | Cache | 6379 |

## 🧪 Tests de Résilience

### Test 1 : Crash d'une API
```bash
docker stop quickcommerce_api_1
curl http://localhost/health
# Résultat : 0 downtime, LB redirige vers api-2 et api-3
```

### Test 2 : Failover BDD
```bash
docker stop quickcommerce_postgres_primary
# Modifier DB_HOST vers postgres-replica
docker-compose up -d
# Résultat : Downtime ~2 min
```

### Test 3 : Performance Cache
```bash
# 1ère requête (sans cache)
time curl http://localhost/api/products

# 2ème requête (avec cache)
time curl http://localhost/api/products
# Résultat : ×10 plus rapide
```

### Test 4 : Test de charge
```bash
bash code/scripts/test-load.sh 1000
# Envoie 1000 requêtes simultanées
```

## 📊 Comparaison TP1 vs TP2

| Aspect | TP1 (Monolithe) | TP2 (AWS) |
|--------|----------------|-----------|
| Conteneurs | 2 | 7 |
| SPOF | 5 | 0 |
| Disponibilité | 95% | 99.9% |
| Crash API | 5 min → 415€ | 0 min → 0€ |
| Crash BDD | 30 min → 2,490€ | 2 min → 166€ |

## 🛠️ Commandes Utiles

```bash
# Voir les logs
docker-compose logs -f

# Stats en temps réel
docker stats

# Redémarrer un conteneur
docker restart quickcommerce_api_1

# Arrêter tout
docker-compose down

# Rebuild
docker-compose up --build -d
```

## 📝 Variables d'Environnement

Les APIs utilisent :
- `INSTANCE_ID` : Identifiant de l'instance (api-1, api-2, api-3)
- `DB_HOST` : Hôte PostgreSQL (postgres-primary ou postgres-replica)
- `REDIS_HOST` : Hôte Redis (redis)

## Objectifs Pédagogiques

Ce TP vous permet de :
- ✅ Déployer une architecture multi-services
- ✅ Configurer un Load Balancer
- ✅ Tester la haute disponibilité
- ✅ Simuler des pannes et failover
- ✅ Mesurer l'impact d'un cache
- ✅ Calculer le ROI d'une migration cloud

---

**QuickCommerce - TP2 Architecture AWS** 🚀
