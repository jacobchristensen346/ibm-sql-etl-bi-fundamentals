# These lines are used to download, configure, and start the kafka server

wget https://downloads.apache.org/kafka/3.8.0/kafka_2.13-3.8.0.tgz

tar -xzf kafka_2.13-3.8.0.tgz

cd kafka_2.13-3.8.0

# Generate a cluster UUID that will uniquely identify the Kafka cluster.
KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"

# KRaft requires the log directories to be configured. Run the following command to configure the log directories passing the cluster ID.
bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c config/kraft/server.properties

# Now that KRaft is configured, you can start the Kafka server by running the following command.
bin/kafka-server-start.sh config/kraft/server.properties

# create a topic named "news"
bin/kafka-topics.sh --create --topic news --bootstrap-server localhost:9092

# You need a producer to send messages to Kafka. Run the command below to start a producer.
bin/kafka-console-producer.sh   --bootstrap-server localhost:9092   --topic news

# Run the command below to listen to the messages in the topic 
bin/kafka-console-consumer.sh   --bootstrap-server localhost:9092   --topic news   --from-beginning

# To check the logs generated for the topic "news run the following command
ls /tmp/kraft-combined-logs/news-0