
      # export JAVA_HOME=/home/y/libexec/jdk1.8.0/

      export HADOOP_JOB_HISTORYSERVER_HEAPSIZE=900

      # We need to add the RFA appender for the mr daemons only;
      # however, HADOOP_MAPRED_LOGGER is shared by the mapred client and the
      # daemons. This will restrict the RFA appender to daemons only.
      export HADOOP_LOGLEVEL=${HADOOP_LOGLEVEL:-INFO}
      export HADOOP_ROOT_LOGGER=${HADOOP_ROOT_LOGGER:-INFO,console}
      export HADOOP_DAEMON_ROOT_LOGGER=${HADOOP_DAEMON_ROOT_LOGGER:-${HADOOP_LOGLEVEL},RFA}

      
      export MAPRED_HISTORYSERVER_OPTS="-Djava.security.auth.login.config=/etc/hadoop/3.1.0.0-78/0/mapred_jaas.conf  -Djavax.security.auth.useSubjectCredsOnly=false"
      

      #export HADOOP_JHS_LOGGER=INFO,RFA # Hadoop JobSummary logger.
      #export HADOOP_IDENT_STRING= #A string representing this instance of hadoop. $USER by default
      #export HADOOP_NICENESS= #The scheduling priority for daemons. Defaults to 0.
      export HADOOP_OPTS="-Dhdp.version=$HDP_VERSION $HADOOP_OPTS"
      export HADOOP_OPTS="-Djava.io.tmpdir=/var/lib/ambari-server/data/tmp/hadoop_java_io_tmpdir $HADOOP_OPTS"
      export JAVA_LIBRARY_PATH="${JAVA_LIBRARY_PATH}:/var/lib/ambari-server/data/tmp/hadoop_java_io_tmpdir"

      # History server logs
      export HADOOP_LOG_DIR=/var/log/hadoop-mapreduce/$USER

      # History server pid
      export HADOOP_PID_DIR=/var/run/hadoop-mapreduce/$USER