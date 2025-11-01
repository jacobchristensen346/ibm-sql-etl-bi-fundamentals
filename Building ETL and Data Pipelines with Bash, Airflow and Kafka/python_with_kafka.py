# This script demonstrates how to utilize the kafka-python package Python client for Apache Kafka

# create an instance of the KafkaAdminClient class to start making topics
admin_client = KafkaAdminClient(bootstrap_servers="localhost:9092", client_id='test')

# create a list of desired topics
topic_list = []
new_topic = NewTopic(name="bankbranch", num_partitions=2, replication_factor=1)
topic_list.append(new_topic)

# then execute the create_topics method on your list
admin_client.create_topics(new_topics=topic_list)

# check the config details of the topics you created...
configs = admin_client.describe_configs(
    config_resources=[ConfigResource(ConfigResourceType.TOPIC, "bankbranch")])

# now we can start producing messages in our topic using KafkaProducer
# we define a lambda function to take a JSON format input and serialize it into bytes
# since Kafka produces and consumes messages in raw bytes
producer = KafkaProducer(value_serializer=lambda v: json.dumps(v).encode('utf-8'))

# let's send the messages in our producer
# we specify the producer in the first argument, and the message in the second
producer.send("bankbranch", {'atmid':1, 'transid':100})
producer.send("bankbranch", {'atmid':2, 'transid':101})

# now we need a consumer to read out the messages we produced
consumer = KafkaConsumer('bankbranch')

# the consumer, upon creation, consumes the messages
# we can print the results by iterating through
for msg in consumer:
    print(msg.value.decode("utf-8"))