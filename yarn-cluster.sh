#!/bin/bash

aws emr create-cluster \
 --name "TERMINATE AM NODE" \
 --log-uri "s3n://aws-emr-resources-082810018603-us-east-1/" \
 --release-label "emr-5.36.0" \
 --service-role "EMR_DefaultRole" \
 --ec2-attributes '{"InstanceProfile":"EMR_EC2_DefaultRole","EmrManagedMasterSecurityGroup":"sg-0c30ec02dcdbea612","EmrManagedSlaveSecurityGroup":"sg-0774dfd0b14ecedf5","KeyName":"hadoop","AdditionalMasterSecurityGroups":[],"AdditionalSlaveSecurityGroups":[],"SubnetId":"subnet-02e679d6e33c5fba3"}' \
 --applications Name=Hadoop Name=Hive Name=Spark \
 --configurations '[{"Classification":"hive-site","Properties":{"hive.metastore.client.factory.class":"com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"}},{"Classification":"spark-hive-site","Properties":{"hive.metastore.client.factory.class":"com.amazonaws.glue.catalog.metastore.AWSGlueDataCatalogHiveClientFactory"}}]' \
 --instance-groups '[{"InstanceCount":3,"InstanceGroupType":"CORE","Name":"Core","InstanceType":"m5.xlarge","EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"VolumeType":"gp2","SizeInGB":32},"VolumesPerInstance":2}]}},{"InstanceCount":1,"InstanceGroupType":"MASTER","Name":"Primary","InstanceType":"m5.xlarge","EbsConfiguration":{"EbsBlockDeviceConfigs":[{"VolumeSpecification":{"VolumeType":"gp2","SizeInGB":32},"VolumesPerInstance":2}]}}]' \
 --steps '[{"Name":"Kill AM","ActionOnFailure":"CONTINUE","Jar":"s3://us-east-1.elasticmapreduce/libs/script-runner/script-runner.jar","Properties":"","Args":["s3://fhumustepvigi/yarn-terminate-am-node.sh","hadoop.pem"]}]' --scale-down-behavior "TERMINATE_AT_TASK_COMPLETION" --ebs-root-volume-size "30" \
--auto-termination-policy '{"IdleTimeout":600}' \
--step-concurrency-level "2" \
--os-release-label "2.0.20221210.1" \
--region "us-east-1"
