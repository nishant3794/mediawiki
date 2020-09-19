#!/bin/bash
# 1st argument = autoscaling group name
# 2nd argument = target group Name
# 3rd argument = final capacity
# 4th argument = region ap-south-1
# ./script.sh asg-name tg-arn capacity eu-central-1
set +e
retry=20
aws_profile=default
AutoScalingGroupName=$1
targetGroup=$2
finalCapacity=$3
region=$4

echo "AutoScalingGroupName "$AutoScalingGroupName
echo "targetGroup "$targetGroup
echo "finalCapacity "$finalCapacity

/usr/local/bin/aws autoscaling describe-auto-scaling-instances --region $region --profile $aws_profile  --query "AutoScalingInstances[?AutoScalingGroupName=='$AutoScalingGroupName']" --output text | cut -f4 > mediawiki-oldInstances.txt

originalCapacity=`wc -l mediawiki-oldInstances.txt | cut -d ' ' -f1`
echo "originalCapacity "$originalCapacity
let desiredCapacity=$finalCapacity+$originalCapacity
echo "desiredCapacity "$desiredCapacity

echo "Adding new instances in autoscaling group!!"
/usr/local/bin/aws autoscaling update-auto-scaling-group --region $region --profile $aws_profile --auto-scaling-group-name $AutoScalingGroupName --max-size $desiredCapacity
/usr/local/bin/aws autoscaling update-auto-scaling-group --region $region --profile $aws_profile --auto-scaling-group-name $AutoScalingGroupName --min-size $desiredCapacity
/usr/local/bin/aws autoscaling set-desired-capacity --region $region --profile $aws_profile --auto-scaling-group-name $AutoScalingGroupName --desired-capacity $desiredCapacity
sleep 70
success=0
for (( i=1; i <= $retry; i++ ))
do
  echo "Retry Number $i"
  /usr/local/bin/aws elbv2 describe-target-health --target-group-arn $targetGroup --region $region --profile $aws_profile > mediawiki-elbdata
  TOTAL_INSTANCES_IN_ELB=`/bin/cat mediawiki-elbdata | grep -wc Id`
  echo "TOTAL_INSTANCES_IN_ELB "$TOTAL_INSTANCES_IN_ELB

  IN_SERVICE_INSTANCES=`/bin/cat mediawiki-elbdata | grep -wc healthy`
  echo "IN_SERVICE_INSTANCES "$IN_SERVICE_INSTANCES

  OUT_OF_SERVICE_INSTANCES=`/bin/cat mediawiki-elbdata | grep -wc unhealhty`
  echo "OUT_OF_SERVICE_INSTANCES "$OUT_OF_SERVICE_INSTANCES

  if [[ "$TOTAL_INSTANCES_IN_ELB" != 0 && "$TOTAL_INSTANCES_IN_ELB" == "$IN_SERVICE_INSTANCES" && "$OUT_OF_SERVICE_INSTANCES" == 0  && "$IN_SERVICE_INSTANCES" == "$desiredCapacity" ]]
  then
    success=1
    echo "all the instances are in service"
    break
  else
    sleep 90
  fi
done

if [ $success != 1 ]; then
  echo "Deployment Failed, New Instances didn't pass the health checks. Rolling back to previous build!!"
  /usr/local/bin/aws autoscaling update-auto-scaling-group --region $region --profile $aws_profile --auto-scaling-group-name $AutoScalingGroupName --termination-policies NewestInstance
  /usr/local/bin/aws autoscaling update-auto-scaling-group --region $region --profile $aws_profile --auto-scaling-group-name $AutoScalingGroupName --min-size $originalCapacity
  /usr/local/bin/aws autoscaling set-desired-capacity --region $region --profile $aws_profile --auto-scaling-group-name $AutoScalingGroupName --desired-capacity $originalCapacity
  sleep 90
  /usr/local/bin/aws autoscaling update-auto-scaling-group --region $region --profile $aws_profile --auto-scaling-group-name $AutoScalingGroupName --termination-policies OldestInstance
  exit 1;
fi


/usr/local/bin/aws autoscaling update-auto-scaling-group --region $region --profile $aws_profile --auto-scaling-group-name $AutoScalingGroupName --min-size $finalCapacity
/usr/local/bin/aws autoscaling set-desired-capacity --region $region --profile $aws_profile --auto-scaling-group-name $AutoScalingGroupName --desired-capacity $finalCapacity
echo "Initializing termination of old instances"

for instance in $(cat mediawiki-oldInstances.txt)
do
  for (( j=1; j <= $retry; j++ ))
  do
    if [ $(/usr/local/bin/aws ec2 describe-instances --instance-id $instance --profile $aws_profile --region $region --query "Reservations[].Instances[].State[].Name" --output text) == "terminated" ]; then
      echo "$instance successfully terminated"
      break
    else
      sleep 5
      echo ".. Still Terminating $instance .."
    fi
  done
done

echo "--------------Mediawiki succesfully deployed-----------------"

rm -rf mediawiki-oldInstances.txt