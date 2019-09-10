
JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
HADOOP_HOME=${HADOOP_HOME:-/opt/hadoop}

if [ -d "/usr/lib/tez" ]; then
  PIG_OPTS="$PIG_OPTS -Dmapreduce.framework.name=yarn"
fi