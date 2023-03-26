IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=jenkins" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)

echo '
{
  "Comment": "CREATE/DELETE/UPSERT a record ",
    "Changes": [{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "COMPONENT.DOMAIN",
        "Type": "A",
        "TTL": 30,
        "ResourceRecords": [{ "Value": "IPADDRESS"}]
      }}]
}' | sed -e "s/IPADDRESS/${IP}/" >/tmp/jenkins.json

ZONE_ID="Z0636942108K930OU3P3D"
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/jenkins.json | jq.
