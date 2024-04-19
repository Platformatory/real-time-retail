#!/bin/bash
# Variables
KAFKA_CONNECT_URL="http://localhost:8083" # Update with your Kafka Connect URL
CONNECTOR_NAME="DynamicPricingConnnector"

PAYLOAD=$(cat <<- JSON
{
  "name": "$CONNECTOR_NAME", 
  "config": {
    "connector.class": "io.confluent.connect.http.HttpSinkConnector",
    "tasks.max":1,
    "http.api.url":"http://api:5000/dynamic-pricing",
    "headers":"Content-Type:application/json|Accept:application/json",
    "request.body.format": "json",
    "reporter.result.topic.replication.factor":1,
    "reporter.error.topic.replication.factor":1,
    "reporter.bootstrap.servers": "broker:29092",
    "confluent.topic.bootstrap.servers": "broker:29092",
    "confluent.topic.replication.factor": "1",
    "topics": "ksql_product_clickstream",
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "false"
  }
}
JSON
)

# Create the connector
curl -s -X POST -H "Content-Type: application/json" --data "$PAYLOAD" "$KAFKA_CONNECT_URL/connectors"

# Output message
if [ $? -eq 0 ]; then
  echo "Successfully created HTTP Sink connector $CONNECTOR_NAME."
else
  echo "Failed to create HTTP Sink connector. Check your Kafka Connect cluster and configurations."
fi
