# Week 8 — Serverless Image Processing

### New Directory 

```
cd /workspace/aws-bootcamp-cruddur-2023
mkdir thumbing-serverless-cdk
```
### Install CDK globally
```npm install aws-cdk -g```

add the the install to our gitpod task file
```
  - name: cdk
    before: |
      npm install aws-cdk -g
```
### Initialize a new project
 initialize a new cdk project within the folder I created:
 ``` cdk init app --language typescript ```
 ### Bootstrapping
 ```cdk bootstrap "aws://$AWS_ACCOUNT_ID/$AWS_DEFAULT_REGION" ```
 
 ### Build
 Use build to catch errors prematurely. This jsut builds tyescript
 ```npm run build ```
 ### Synth
 The synth command is used to synthesize the AWS CloudFormation stack(s) that represent your infrastructure as code. 
 ```cdk synth ```
 
 ### Load Env Vars
 ```
 const dotenv = require('dotenv');
dotenv.config();

const bucketName: string = process.env.THUMBING_BUCKET_NAME as string;
const folderInput: string = process.env.THUMBING_S3_FOLDER_INPUT as string;
const folderOutput: string = process.env.THUMBING_S3_FOLDER_OUTPUT as string;
const webhookUrl: string = process.env.THUMBING_WEBHOOK_URL as string;
const topicName: string = process.env.THUMBING_TOPIC_NAME as string;
const functionPath: string = process.env.THUMBING_FUNCTION_PATH as string;
console.log('bucketName',bucketName)
console.log('folderInput',folderInput)
console.log('folderOutput',folderOutput)
console.log('webhookUrl',webhookUrl)
console.log('topicName',topicName)
console.log('functionPath',functionPath)

```
### Create Bucket
```
import * as s3 from 'aws-cdk-lib/aws-s3';

const bucket = this.createBucket(bucketName)

createBucket(bucketName: string): s3.IBucket {
  const logicalName: string = 'ThumbingBucket';
  const bucket = new s3.Bucket(this, logicalName , {
    bucketName: bucketName,
    removalPolicy: cdk.RemovalPolicy.DESTROY,
  });
  return bucket;
}
```


 

 
