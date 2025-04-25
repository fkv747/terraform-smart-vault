import boto3
import datetime

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    today = datetime.datetime.now().strftime('%Y-%m-%d') # Gets the current date
    # strftime('%Y-%m-%d') turns it into a readable format (YYYY-MM-DD)
    # The date is used to tag the snapshot with the current date
    # Describe the snapshot, Let you know when it was created
    volumes = ec2.describe_volumes(
        Filters=[{'Name': 'tag:Backup', 'Values': ['True']}]
        # This grabs all EBS volumes that have a tag: Backup = True
        # That’s your opt-in filter so you don’t snapshot every single volume
        # Only tagged volumes will be included in the loop
    )

    for volume in volumes['Volumes']:
        volume_id = volume['VolumeId']
        description = f"Automated snapshot for {volume_id} on {today}"
        # Loops over each tagged volume
        # Stores the volume ID
        # Builds a readable description string (e.g., "Automated snapshot for vol-123...")
        
        ec2.create_snapshot(
            VolumeId=volume_id,
            Description=description,
            TagSpecifications=[{
                'ResourceType': 'snapshot',
                'Tags': [
                    {'Key': 'CreatedBy', 'Value': 'Lambda'},
                    {'Key': 'Date', 'Value': today}
                ]
            }]
        )
        # Calls AWS to create a snapshot of the volume
        # Date = YYYY-MM-DD → for cleanup automation later
    return {
        'statusCode': 200,
        'body': f"Created snapshots for {len(volumes['Volumes'])} volume(s)."
        # This just confirms how many snapshots were created
    }
