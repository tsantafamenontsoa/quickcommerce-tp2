#!/bin/bash
# ============================================
# Script de test de charge - QuickCommerce
# ============================================

REQUESTS=${1:-100}
URL="http://localhost/api/products"

echo "Test de charge : $REQUESTS requêtes simultanées"
echo "URL : $URL"
echo ""

START=$(date +%s)

# Lancer les requêtes en parallèle
for i in $(seq 1 $REQUESTS); do
    curl -s "$URL" > /dev/null &
done

# Attendre que toutes les requêtes se terminent
wait

END=$(date +%s)
DURATION=$((END - START))

echo ""
echo "✅ Test terminé"
echo "📊 Durée totale : ${DURATION}s"
echo "📈 Requêtes/sec : $((REQUESTS / DURATION))"
echo ""
echo "💡 Pour voir la répartition :"
echo "   docker logs quickcommerce_api_1 | grep 'Cache'"
echo "   docker logs quickcommerce_api_2 | grep 'Cache'"
echo "   docker logs quickcommerce_api_3 | grep 'Cache'"
