import boto3
import datetime # 📅 datetime = Used to compare snapshot age

sns = boto3.client('sns')
sns_arn = 'arn:aws:sns:us-east-1:245994248859:snapshot-alerts'
ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    today = datetime.datetime.now() # Get current date
    retention_days = 7 # Set retention threshold (7 days by default)

    snapshots = ec2.describe_snapshots(OwnerIds=['self'])['Snapshots']
    deleted = 0
    # Grab all snapshots you own
    for snapshot in snapshots: # Loop through all your snapshots
        tags = {tag['Key']: tag['Value'] for tag in snapshot.get('Tags', [])} # Convert tags into a dictionary for easy lookup
        if tags.get('CreatedBy') == 'Lambda' and 'Date' in tags: # Only delete snapshots: Created by Lambda, That are older than retention threshold

            snapshot_date = datetime.datetime.strptime(tags['Date'], '%Y-%m-%d')
            age = (today - snapshot_date).days
            if age > retention_days: # If it’s too old → delete it
                ec2.delete_snapshot(SnapshotId=snapshot['SnapshotId'])
                deleted += 1

    message = f"Deleted {deleted} snapshot(s) older than {retention_days} days."

    sns.publish(
        TopicArn=sns_arn,
        Subject='Smart Vault Snapshot Cleanup Report',
        Message=message
)

    return {
        'statusCode': 200,
        'body': message
}
