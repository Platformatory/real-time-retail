FROM avinashupadhya99/shopify-webhook-connector:1.0.4

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.6.5
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-http:1.7.5

