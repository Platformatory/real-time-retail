```sh
wget https://github.com/ScreenStaring/shopify_id_export/releases/download/v0.0.3/shopify_id_export_0.0.3_linux_amd64.tar.gz

tar zxf shopify_id_export_0.0.3_linux_amd64.tar.gz

sudo mv shopify_id_export /usr/local/bin/

shopify_id_export -j -t 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 quick-start-0136bef3

kafka-topics --bootstrap-server localhost:9092 --create --topic shopify_products

cat quick-start-0136bef3.json | jq -c '.[]' | while read -r line; do echo "$line" | kafka-console-producer --topic shopify_products --bootstrap-server localhost:9092; done

kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --topic shopify_products | jq
```

```sh
curl -X GET \
  https://quick-start-0136bef3.myshopify.com/admin/api/2024-04/webhooks.json \
  -H 'Content-Type: application/json' \
  -H 'X-Shopify-Access-Token: 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'
```

```sh
kafka-console-consumer --bootstrap-server localhost:9092 --from-beginning --property print.key=true --topic shopify_clickstream
```

```sh
kafka-topics --bootstrap-server localhost:9092 --list
```

```sh
kafka-topics --bootstrap-server localhost:9092 --delete --topic shopify_clickstream
```