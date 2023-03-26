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
}' | sed -e "s/IPADDRESS/${IP}/"