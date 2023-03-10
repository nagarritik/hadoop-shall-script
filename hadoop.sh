#!/bin/bash

# Install Java 8
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk

# Download and extract Hadoop
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.1/hadoop-3.3.1.tar.gz
tar -xzf hadoop-3.3.1.tar.gz
sudo mv hadoop-3.3.1 /usr/local/hadoop
rm hadoop-3.3.1.tar.gz

# Set up Hadoop environment variables
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> ~/.bashrc
echo "export HADOOP_HOME=/usr/local/hadoop" >> ~/.bashrc
echo "export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin" >> ~/.bashrc
source ~/.bashrc

# Configure Hadoop
cd /usr/local/hadoop/etc/hadoop
sudo cp mapred-site.xml.template mapred-site.xml
sudo cp core-site.xml core-site.xml.backup
sudo sed -i '/<\/configuration>/d' core-site.xml
echo '<property>' >> core-site.xml
echo '<name>fs.defaultFS</name>' >> core-site.xml
echo '<value>hdfs://localhost:9000</value>' >> core-site.xml
echo '</property>' >> core-site.xml
echo '</configuration>' >> core-site.xml

sudo cp hdfs-site.xml hdfs-site.xml.backup
sudo sed -i '/<\/configuration>/d' hdfs-site.xml
echo '<property>' >> hdfs-site.xml
echo '<name>dfs.replication</name>' >> hdfs-site.xml
echo '<value>1</value>' >> hdfs-site.xml
echo '</property>' >> hdfs-site.xml
echo '</configuration>' >> hdfs-site.xml

# Format the Hadoop file system
cd /usr/local/hadoop
bin/hdfs namenode -format

# Start Hadoop
sbin/start-all.sh

# Verify Hadoop installation
jps
