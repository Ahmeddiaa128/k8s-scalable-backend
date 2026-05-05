#!/bin/bash

echo "Waiting for MongoDB pods..."

kubectl wait --for=condition=ready pod mongo-0 -n k8s-backend --timeout=120s
kubectl wait --for=condition=ready pod mongo-1 -n k8s-backend --timeout=120s
kubectl wait --for=condition=ready pod mongo-2 -n k8s-backend --timeout=120s

echo "Initializing Replica Set..."

kubectl exec mongo-0 -n k8s-backend -- mongo --eval '
try {
  rs.status()
} catch (e) {
  rs.initiate({
    _id: "rs0",
    members: [
      { _id: 0, host: "mongo-0.mongo:27017" },
      { _id: 1, host: "mongo-1.mongo:27017" },
      { _id: 2, host: "mongo-2.mongo:27017" }
    ]
  })
}
'

echo "Replica Set Done"
