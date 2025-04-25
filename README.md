# Smart Vault – EBS Snapshot Automation

![IaC](https://img.shields.io/badge/IaC-Terraform-7B42BC?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/Cloud-AWS-232F3E?style=for-the-badge&logo=amazonaws)
![EventBridge](https://img.shields.io/badge/AWS%20EventBridge-Scheduler-FF4F8B?style=for-the-badge&logo=amazonaws)
![SNS](https://img.shields.io/badge/AWS%20SNS-Notifications-F29111?style=for-the-badge&logo=amazonaws)
![Lambda](https://img.shields.io/badge/AWS%20Lambda-Serverless-F58536?style=for-the-badge&logo=awslambda)

> Terraform · AWS · Lambda · EventBridge · SNS · CloudWatch

## Overview
Smart Vault is a serverless, infrastructure-as-code solution that automates EBS snapshot creation and cleanup using **AWS Lambda**, **Amazon EventBridge**, **SNS**, and **CloudWatch**, all deployed entirely through **Terraform**. This project showcases modular design, automated scheduling, error alerting, and snapshot retention logic with no manual intervention required.

---

## Demo

🎥 **Watch the full demo on YouTube**  
[Watch the YouTube demo](https://www.youtube.com/watch?v=YOUR_VIDEO_ID)


> This walkthrough shows the entire setup and behavior of Smart Vault — including snapshot creation, cleanup, notifications, and scheduling via Terraform.

📦 This service is currently turned off to reduce AWS costs, but everything in the demo is fully reproducible from this repo.

---

## Architecture
This diagram summarizes the full AWS-powered design of Smart Vault:

![Architecture](./screenshots/smart-vault-diagram.png)

- **Lambda Functions** create and clean up EBS snapshots
- **EventBridge Rules** schedule daily snapshot + cleanup
- **SNS** sends success/failure alerts to email
- **CloudWatch Logs** monitor function execution and errors

---

## How It Works
Each step below corresponds with a real screenshot inside the `screenshots/` folder.

### 1. Project Structure & Terraform Backend
- `backend.tf` stores Terraform state in S3 + DynamoDB
- Modular setup inside `modules/`

![backend config](./screenshots/1-backend.tf.png)

```markdown
## Folder Structure

```bash
/terraform-smart-vault/
├── backend.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── variables.tf
├── .terraform.lock.hcl
├── .gitignore
├── README.md
├── modules/
│   ├── cloudwatch_logs/
│   ├── eventbridge_trigger/
│   ├── lambda_cleanup/
│   ├── lambda_snapshot/
│   └── sns_alert/
└── screenshots/
    ├── 1-backend.tf.png
    ├── 2-terraform-apply.png
    ├── ...
    └── smart-vault-diagram.png

---

### 2. Create Backend Resources
- Provision backend S3 + DynamoDB with Terraform

![apply backend](./screenshots/2-terraform-apply.png)

### 3. Reconfigure Local State to Remote
- Initialize the new backend after enabling the `backend.tf`

![reconfigure](./screenshots/2-terraform-apply-reconfigure.png)

### 4. Deploy Snapshot Lambda + IAM Role
- Uses module `lambda_snapshot`

![apply snapshot module](./screenshots/4-terraform-apply-lambda-module.png)

### 5. Create EventBridge Rule (Daily Trigger)
- Triggers snapshot Lambda once per day

![eventbridge rule](./screenshots/5-eventbridge-rule.png)
![apply eventbridge module](./screenshots/5-terraform-apply-eventbridge.png)

### 6. Test Snapshot Function
- Python code filters for `tag:Backup = True`

![lambda snapshot code](./screenshots/manual-trigger-lambda-snapshot.png)
![lambda test](./screenshots/5-Lambda-Test.png)

### 7. Enable CloudWatch Logging
- Log group auto-created and tracked in Terraform

![cloudwatch](./screenshots/6-cloudwatch.png)

### 8. Add SNS Alerts
- Sends snapshot result/failure emails to user

![apply sns module](./screenshots/7-terraform-apply-sns.png)
![terraform sns](./screenshots/terraform-apply-SNS.png)

### 9. Deploy Cleanup Lambda
- Deletes snapshots older than 7 days

![lambda cleanup code](./screenshots/manual-trigger-lambda-cleanup.png)
![apply cleanup module](./screenshots/8-lambda-cleanup.png)

### 10. Schedule Cleanup with EventBridge
- Daily cleanup trigger added via `eventbridge_cleanup_trigger`

![eventbridge cleanup rule](./screenshots/9-eventbridge_cleanup.png)

### 11. Modify or Redeploy Modules
- Example apply with changes

![terraform modify modules](./screenshots/terraform-apply-SNS.png)

---

## Modules Used
All reusable modules are stored in the `modules/` folder:

- `lambda_snapshot` - Creates EBS snapshots tagged with the current date
- `lambda_cleanup` - Deletes EBS snapshots older than retention threshold
- `eventbridge_trigger` - Triggers Lambda functions on schedule
- `cloudwatch_logs` - Manages log group for each Lambda
- `sns_alert` - Configures SNS topic + email alert subscription

---

## What I Learned
- 📅 How to automate snapshots using EventBridge without manual triggers
- 💬 How to send real-time failure alerts with SNS
- 🧼 How to build logic that filters and deletes only old snapshots
- ⚙️ How to modularize Terraform projects and keep code clean
- 💡 Keeping logging optional helps reduce clutter and cost

It also pushed me to improve how I document and present my work for technical audiences.


---

## Connect with Me

📫 [LinkedIn](https://www.linkedin.com/in/franc-kevin-v-07108b111/)