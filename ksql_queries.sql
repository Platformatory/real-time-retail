SET 'auto.offset.reset'='earliest';

CREATE OR REPLACE STREAM PRODUCTS_UPDATE_STREAM 
    (PAYLOAD STRUCT<
        id BIGINT,
        created_at STRING,
        inventory_management STRING,
        title STRING,
        vendor STRING,
        variants Array<
            Struct<
                id BIGINT,
                created_at STRING,
                title STRING,
                inventory_item_id BIGINT,
                inventory_quantity BIGINT,
                old_inventory_quantity BIGINT,
                sku STRING,
                price STRING,
                product_id BIGINT
                >
            >
        >
    ) WITH (KAFKA_TOPIC='plf_products_update', KEY_FORMAT='KAFKA', VALUE_FORMAT='JSON');

CREATE OR REPLACE STREAM PRODUCTS_UPDATES
    WITH (KAFKA_TOPIC='ksql_product_updates', PARTITIONS=6, REPLICAS=1) AS SELECT
        PAYLOAD->id id,
        PAYLOAD->created_at created_at,
        PAYLOAD->inventory_management inventory_management,
        PAYLOAD->title title,
        PAYLOAD->vendor vendor,
        EXPLODE(PAYLOAD->variants) variant
    FROM PRODUCTS_UPDATE_STREAM
    EMIT CHANGES;

CREATE OR REPLACE STREAM CLICKSTREAM_STREAM (
    time STRING,
    user_id BIGINT,
    product_variant_id BIGINT,
    activity STRING,
    ip STRING
) WITH (KAFKA_TOPIC='shopify_clickstream', KEY_FORMAT='KAFKA', VALUE_FORMAT='JSON');


CREATE OR REPLACE TABLE CLICKSTREAM_ACTIVITY
WITH (KAFKA_TOPIC='ksql_clickstream_activity', PARTITIONS=6, REPLICAS=1, KEY_FORMAT='JSON')
AS
SELECT 
    product_variant_id product_variant_id,
    COUNT(activity) activity_count
FROM CLICKSTREAM_STREAM
WHERE activity='contentView'
GROUP BY product_variant_id
EMIT CHANGES;


CREATE OR REPLACE STREAM PRODUCT_CLICKSTREAM
WITH (KAFKA_TOPIC='ksql_product_clickstream', PARTITIONS=6, REPLICAS=1)
AS
SELECT p.id product_id,
    p.created_at product_created_at,
    p.inventory_management inventory_management,
    p.title product_title,
    p.vendor product_vendor,
    p.variant->created_at variant_created_at,
    p.variant->inventory_item_id variant_inventory_item_id,
    p.variant->old_inventory_quantity old_inventory_quantity,
    p.variant->inventory_quantity inventory_quantity,
    p.variant->sku variant_sku,
    p.variant->price price,
    c.product_variant_id variant_id,
    c.activity_count activity_count
FROM PRODUCTS_UPDATES p INNER JOIN CLICKSTREAM_ACTIVITY c ON ((p.variant->id = c.product_variant_id)) EMIT CHANGES;
