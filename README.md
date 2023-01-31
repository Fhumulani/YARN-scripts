# YARN bash scripts

These bash scripts can be used to test different YARN scenarios. Like what happens to a running application should a Node Manager daemon of a node that is hosting the Application Master.

## What are the steps

* copy keypair file to master node. 
* change the mode to 400
* The bash script trigger a spark application by adding a spark step
* wait for 240 seconds for the application to be triggered
* depending on what you want to do check the node in question and populate worker.sh script with the required commands
* if the node is a worker node, ssh to the node and execute the worker.sh script

[`yarn-kill-am.sh`](https://github.com/Fhumulani/YARN-scripts/blob/main/yarn-kill-am.sh)
* In this script the application master is killed using its pid. `sudo -u yarn kill xxxx`  from the one can check the logs to see what happens with the application itself. <br />


[`yarn-kill-container.sh`](https://github.com/Fhumulani/YARN-scripts/blob/main/yarn-kill-container.sh)
* In this script all the containers in the worker nodes are killed using their pid. `sudo -u yarn kill xxxx`  from the one can check the logs to see what happens with the application itself.


[`yarn-reboot-am-node.sh`](https://github.com/Fhumulani/YARN-scripts/blob/main/yarn-reboot-am-node.sh)
* In this script the node that is hosting AM is rebooted using "sudo reboot"command.


[`yarn-stop-nm-am-node.sh`](https://github.com/Fhumulani/YARN-scripts/blob/main/yarn-stop-nm-am-node.sh)
* Here the Node Manager daemon in the node that host Application master is stopped.


[`yarn-terminate-am-node.sh`](https://github.com/Fhumulani/YARN-scripts/blob/main/yarn-terminate-am-node.sh)
* Terminated the node that is hosting the Application Master.


[`yarn-stop-RM.sh`](https://github.com/Fhumulani/YARN-scripts/blob/main/yarn-stop-RM.sh)
* Stop the resource manager while the application is running.

In order to get this going one can just launch a cluster from console and add a step the execute a shell script. Another way would be to launc a cluster using a AWS CLI as shown below:

```
aws emr create-cluster \
 --name "TERMINATE AM NODE" \
 --log-uri "s3n://aws-emr-resources-xxxxxxxxxxxxx-us-east-1/" \
 --release-label "emr-5.36.0" \
 --service-role "EMR_DefaultRole" \
 --ec2-attributes '{"InstanceProfile":"EMR_EC2_DefaultRole","EmrManagedMasterSecurityGroup":"sg-xxxxxxxxxxxxx","EmrManagedSlaveSecurityGroup":"sg-xxxxxxxxxxxxx","KeyName":"KEYNAME","AdditionalMasterSecurityGroups":[],"AdditionalSlaveSecurityGroups":[],"SubnetId":"subnet-sg-xxxxxxxxxxxxx"}' \
 --applications Name=Hadoop Name=Hive Name=Spark \
 --configurations '[{"Classification":"hive-site","Properties":{"hive.metastore.client.factory.class":"com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"}},{"Classification":"spark-hive-site","Properties":{"hive.metastore.client.factory.class":"com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"}}]' \
 --instance-groups '[{"InstanceCount":3,"InstanceGroupType":"CORE","Name":"Core","InstanceType":"m5.xlarge","EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"VolumeType":"gp2","SizeInGB":32},"VolumesPerInstance":2}]}},{"InstanceCount":1,"InstanceGroupType":"MASTER","Name":"Primary","InstanceType":"m5.xlarge","EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"VolumeType":"gp2","SizeInGB":32},"VolumesPerInstance":2}]}}]' \
 --steps '[{"Name":"Kill AM","ActionOnFailure":"CONTINUE","Jar":"s3://us-east-1.elasticmapreduce/libs/script-runner/script-runner.jar","Properties":"","Args":["s3://BUCKETNAME/yarn-terminate-am-node.sh","keypair.pem"]}]' --scale-down-behavior "TERMINATE_AT_TASK_COMPLETION" --ebs-root-volume-size "30" \
--auto-termination-policy '{"IdleTimeout":600}' \
--step-concurrency-level "2" \
--os-release-label "2.0.20221210.1" \
--region "us-east-1"
```





