#!/bin/bash
# Variables
KAFKA_CONNECT_URL="http://localhost:8083" # Update with your Kafka Connect URL
CONNECTOR_NAME="ClickstreamConnector"

PAYLOAD=$(cat <<- JSON
{
  "name": "$CONNECTOR_NAME", 
  "config": { 
    "connector.class": "io.confluent.kafka.connect.datagen.DatagenConnector",
    "tasks.max": "1",
    "kafka.topic": "shopify_clickstream",
    "schema.filename": "/home/appuser/retail_clickstream_schema.avro",
    "schema.keyfield": "activity",
    "topic.creation.default.partitions": 6,
    "topic.creation.default.replication.factor": 1,
    "key.converter": "org.apache.kafka.connect.storage.StringConverter",
    "value.converter": "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable": "false"
  }
}
JSON
)

echo $PAYLOAD

# Create the connector
curl -s -X POST -H "Content-Type: application/json" --data "$PAYLOAD" "$KAFKA_CONNECT_URL/connectors"

# Output message
if [ $? -eq 0 ]; then
  echo "Successfully created Datagen connector $CONNECTOR_NAME."
else
  echo "Failed to create Datagen connector. Check your Kafka Connect cluster and configurations."
fi
