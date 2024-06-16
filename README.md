# Real time retail

Demo code from the talk on [Real Time Retail](https://youtu.be/UXuplv4MKWI) at [Bengaluru Streams April 2024](https://platformatory.io/events/2024-04-bengaluru-streams-april/).

## Setup

```sh
ngrok http 8000
```

### In a separate terminal

```sh
export SHOPIFY_ACCESS_TOKEN=""
export SHOPIFY_STORE_NAME=""
export SHOPIFY_API_SECRET=""
./setup.sh
```

- Make changes to the inventory in Shopify

- Consume from sell through and dynamic pricing topics

```sh
kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic SellThroughConnnector-success | jq
```

```sh
kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic DynamicPricingConnnector-success | jq
```
