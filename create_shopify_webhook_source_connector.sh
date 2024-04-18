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
    "schema.infer": true,
    "validator.class":"com.platformatory.kafka.connect.ShopifyRequestValidator",
    "port":8000,
    "shopify.access.token":"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",
    "shopify.webhook.create":true,
    "shopify.store.name":"quick-start-0136bef3",
    "shopify.webhook.topics":"inventory_items/create,inventory_items/update,inventory_items/delete",
    "shopify.apisecret":"1c953f8bf6ea333f41dc938485b776a3",
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
