#!/bin/bash

CLUSTER_ID=$(jq -r .jobFlowId /emr/instance-controller/lib/info/job-flow.json)


#submit a jobi

keypair=$1

aws s3 cp s3://fhumustepvigi/$keypair /home/hadoop/
chmod 400 /home/hadoop/$keypair

aws emr add-steps --cluster-id $CLUSTER_ID \
--steps '[{"Args":["spark-submit","--deploy-mode","cluster","--driver-memory","8G","s3://fhumustepvigi/chow-yarn-whole.py"],"Type":"CUSTOM_JAR","ActionOnFailure":"CONTINUE","Jar":"command-runner.jar","Properties":"","Name":"Spark application"}]' 


sleep 240

AM_ID=$(yarn application -list | grep application_167)

echo $AM_ID

aws emr list-instances --cluster-id $CLUSTER_ID | grep PrivateDnsName | awk -F'"' '{print $4}' > /home/hadoop/ips.txt

input=/home/hadoop/ips.txt

while IFS= read -r ip
do
    if [[ $AM_ID == *"$ip"* ]];
    then
      echo "#!/bin/bash" > /home/hadoop/worker.sh
      echo "ID=\$(ps aux | grep ApplicationMaster | grep -v grep | tail -1 | awk '{print \$2}')" >> /home/hadoop/worker.sh
      echo "sudo -u yarn kill \$ID" >> /home/hadoop/worker.sh
      ssh -o StrictHostKeyChecking=no -i /home/hadoop/$keypair hadoop@$ip 'bash -s' <  /home/hadoop/worker.sh
       
    fi
done < "$input"

sleep 30

yarn application -list

chmod 777 /home/hadoop/$keypair
rm -f /home/hadoop/$keypair
#!/bin/bash

CLUSTER_ID=$(jq -r .jobFlowId /emr/instance-controller/lib/info/job-flow.json)


#submit a jobi

keypair=$1

aws s3 cp s3://BUCKET_NAME/$keypair /home/hadoop/
chmod 400 /home/hadoop/$keypair

aws emr add-steps --cluster-id $CLUSTER_ID \
--steps '[{"Args":["spark-submit","--deploy-mode","cluster","--driver-memory","8G","s3://BUCKET_NAME/chow-yarn-whole.py"],"Type":"CUSTOM_JAR","ActionOnFailure":"CONTINUE","Jar":"command-runner.jar","Properties":"","Name":"Spark application"}]' 


sleep 240

AM_ID=$(yarn application -list | grep application_167)

echo $AM_ID

aws emr list-instances --cluster-id $CLUSTER_ID | grep PrivateDnsName | awk -F'"' '{print $4}' > /home/hadoop/ips.txt

input=/home/hadoop/ips.txt

while IFS= read -r ip
do
    if [[ $AM_ID == *"$ip"* ]];
    then
      echo "#!/bin/bash" > /home/hadoop/worker.sh
      echo "ID=\$(ps aux | grep ApplicationMaster | grep -v grep | tail -1 | awk '{print \$2}')" >> /home/hadoop/worker.sh
      echo "sudo -u yarn kill \$ID" >> /home/hadoop/worker.sh
      ssh -o StrictHostKeyChecking=no -i /home/hadoop/$keypair hadoop@$ip 'bash -s' <  /home/hadoop/worker.sh
       
    fi
done < "$input"

sleep 30

yarn application -list

chmod 777 /home/hadoop/$keypair
rm -f /home/hadoop/$keypair
