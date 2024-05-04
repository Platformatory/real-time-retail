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
