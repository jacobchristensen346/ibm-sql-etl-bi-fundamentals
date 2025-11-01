# These lines are used to download, configure, and start the kafka server
# additionally we explore kafka message keys and offset

wget https://downloads.apache.org/kafka/3.8.0/kafka_2.13-3.8.0.tgz

tar -xzf kafka_2.13-3.8.0.tgz

cd kafka_2.13-3.8.0

# Generate a cluster UUID that will uniquely identify the Kafka cluster.
KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"

# KRaft requires the log directories to be configured. Run the following command to configure the log directories passing the cluster ID.
bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c config/kraft/server.properties

# Now that KRaft is configured, you can start the Kafka server by running the following command.
bin/kafka-server-start.sh config/kraft/server.properties

# create a topic named "bankbranch"
# use --partitions 2 argument to create two partitions
bin/kafka-topics.sh --create --topic bankbranch --partitions 2 --bootstrap-server localhost:9092

# use this line to list all topics created
bin/kafka-topics.sh --bootstrap-server localhost:9092 --list

# use the --describe option to check the details of "bankbranch"
bin/kafka-topics.sh --bootstrap-server localhost:9092 --describe --topic bankbranch

# create a producer for the bankbranch topic
bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic bankbranch

# add the following messages to the ">" prompt, pressing Enter for each line
# these represent JSON objects from possible transactions at a bank
# {"atmid": 1, "transid": 100}
# {"atmid": 1, "transid": 101}
# {"atmid": 2, "transid": 200}
# {"atmid": 1, "transid": 102}
# {"atmid": 2, "transid": 201}

# now create a consumer to view the messages from above
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic bankbranch --from-beginning

# In this step, you will use message keys to ensure that messages 
# with the same key are consumed in the same order as they were published. 
# In the back end, messages with the same key are published into the same 
# partition and will always be consumed by the same consumer. 
# As such, the original publication order is kept on the consumer side.

# create a new producer which uses the option for parsing message keys
# also specify the message key separator
bin/kafka-console-producer.sh --bootstrap-server localhost:9092 --topic bankbranch --property parse.key=true --property key.separator=:

# now add in these lines to pass as messages
# we include a number at the beginning with the ":" separator we specified
# this number represents the message key for that specific message
# 1:{"atmid": 1, "transid": 103}
# 1:{"atmid": 1, "transid": 104}
# 2:{"atmid": 2, "transid": 202}
# 2:{"atmid": 2, "transid": 203}
# 1:{"atmid": 1, "transid": 105}

# now start a new consumer but also with the "--property print.key=true" and "--property key.separator=:" arguments
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic bankbranch --from-beginning --property print.key=true --property key.separator=:

# now we will create consumer groups, which helps us organize multiple consumers that are related
# in this case we can create a consumer group for all consumers that are used to manage each atm machine at the bank
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic bankbranch --group atm-app

# run this command to check on the consumer group atm-app
# this will show the current offset in consumed messages for both bankbranch partitions
# you can see the number of consumed messages, and the number of remaining messages
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group atm-app

# to start the consumption from the very beginning (reset offset), use the "--reset-offsets" argument
# additionally use "--to-earliest" to go back to the very beginning
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092  --topic bankbranch --group atm-app --reset-offsets --to-earliest --execute

# you can reset the offset to any position, for instance shifting to the left by two...
# --reset-offsets --shift-by -2
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092  --topic bankbranch --group atm-app --reset-offsets --shift-by -2 --execute
# in this case we consume four messages, two for each partition in "bankbranch"