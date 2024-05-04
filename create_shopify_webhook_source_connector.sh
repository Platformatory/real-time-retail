#!/bin/bash
# Variables
KAFKA_CONNECT_URL="http://localhost:8083" # Update with your Kafka Connect URL
CONNECTOR_NAME="ShopifyWebhookConnector"

PAYLOAD=$(cat <<- JSON
{
  "name": "$CONNECTOR_NAME", 
  "config": {
    "connector.class": "com.platformatory.kafka.connect.ShopifyWebhookConnector",
    "tasks.max":1,
    "topic.default":"webhook",
    "topic.header":"X-Shopify-Topic",
    "topic.prefix":"plf_",
    "key.json.path": "$.id",
    "schema.infer": false,
    "validator.class":"com.platformatory.kafka.connect.ShopifyRequestValidator",
    "port":8000,
    "shopify.access.token":"$SHOPIFY_ACCESS_TOKEN",
    "shopify.webhook.create":true,
    "shopify.store.name":"$SHOPIFY_STORE_NAME",
    "shopify.webhook.topics":"products/update",
    "shopify.apisecret":"$SHOPIFY_API_SECRET",
    "shopify.connector.hostname":"$NGROK_PUBLIC_URL"
  }
}
JSON
)

# Create the connector
curl -s -X POST -H "Content-Type: application/json" --data "$PAYLOAD" "$KAFKA_CONNECT_URL/connectors"

# Output message
if [ $? -eq 0 ]; then
  echo "Successfully created Shopify Webhook connector $CONNECTOR_NAME."
else
  echo "Failed to create Shopify Webhook connector. Check your Kafka Connect cluster and configurations."
fi
