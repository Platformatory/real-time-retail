#!/bin/bash

docker-compose up -d

sleep 10

kafka-topics --bootstrap-server localhost:9092 --create --topic shopify_products

echo "Producing products data into kafka"

cat quick-start-0136bef3.json | jq -c '.[]' | while read -r line; do echo "$line" | kafka-console-producer --topic shopify_products --bootstrap-server localhost:9092; done

echo "Produced products data into kafka"

sh ./create_datagen_source_connector.sh

export NGROK_PUBLIC_URL=`curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url'`

sh ./create_shopify_webhook_source_connector.sh

sh ./create_http_sink_connector.sh