#!/bin/bash

CLUSTER_ID=$(jq -r .jobFlowId /emr/instance-controller/lib/info/job-flow.json)


#submit a jobi


aws emr add-steps --cluster-id $CLUSTER_ID \
--steps '[{"Args":["spark-submit","--deploy-mode","cluster","--driver-memory","8G","s3://fhumustepvigi/chow-yarn-whole.py"],"Type":"CUSTOM_JAR","ActionOnFailure":"CONTINUE","Jar":"command-runner.jar","Properties":"","Name":"Stop RM on master Node"}]'
 
sleep 240

AM_ID=$(yarn application -list | grep application_167)

echo $AM_ID


sudo systemctl stop hadoop-yarn-resourcemanager

#!/bin/bash

CLUSTER_ID=$(jq -r .jobFlowId /emr/instance-controller/lib/info/job-flow.json)


#submit a jobi


aws emr add-steps --cluster-id $CLUSTER_ID \
--steps '[{"Args":["spark-submit","--deploy-mode","cluster","--driver-memory","8G","s3://BUCKET_NAME/chow-yarn-whole.py"],"Type":"CUSTOM_JAR","ActionOnFailure":"CONTINUE","Jar":"command-runner.jar","Properties":"","Name":"Stop RM on master Node"}]'
 
sleep 240

AM_ID=$(yarn application -list | grep application_167)

echo $AM_ID


sudo systemctl stop hadoop-yarn-resourcemanager

