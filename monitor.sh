#!/bin/bash

# Specify your AWS region
AWS_REGION="us-east-1"

# List all EC2 instance IDs in the region
INSTANCE_IDS=$(aws ec2 describe-instances --region $AWS_REGION --query 'Reservations[*].Instances[*].InstanceId' --output text)

# Loop through each instance ID
for INSTANCE_ID in $INSTANCE_IDS; do
    # Create a CloudWatch Alarm for CPUUtilization metric
    aws cloudwatch put-metric-alarm \
        --region $AWS_REGION \
        --alarm-name "CPUUtilizationAlarm-${INSTANCE_ID}" \
        --alarm-description "Alarm for high CPU utilization on instance ${INSTANCE_ID}" \
        --actions-enabled \
        --alarm-actions "arn:aws:sns:your-region:your-account-id:your-sns-topic" \
        --metric-name CPUUtilization \
        --namespace AWS/EC2 \
        --statistic Average \
        --dimensions "Name=InstanceId,Value=${INSTANCE_ID}" \
        --period 300 \
        --threshold 80 \
        --comparison-operator GreaterThanOrEqualToThreshold \
        --evaluation-periods 2
done
