# Week 6 — Deploying Containers
## Implementing healthchecks
### Test RDS Connecetion
Under `/bin/db` I created the script to easily check our connection from our container.
```sh
#!/usr/bin/env python3

import psycopg
import os
import sys

connection_url = os.getenv("CONNECTION_URL")

conn = None
try:
  print('attempting connection')
  conn = psycopg.connect(connection_url)
  print("Connection successful!")
except psycopg.Error as e:
  print("Unable to connect to the database:", e)
finally:
  conn.close()
```
### Task Flask Script
In the `app.py` file
```
@app.route('/api/health-check')
def health_check():
  return {'success': True}, 200
```
create a new bin script at `bin/flask/health-check`
```
#!/usr/bin/env python3

import urllib.request

try:
  response = urllib.request.urlopen('http://localhost:4567/api/health-check')
  if response.getcode() == 200:
    print("[OK] Flask server is running")
    exit(0) # success
  else:
    print("[BAD] Flask server is not running")
    exit(1) # false
# This for some reason is not capturing the error....
#except ConnectionRefusedError as e:
# so we'll just catch on all even though this is a bad practice
except Exception as e:
  print(e)
  exit(1) # false
  
```

## ECS and ECR
### Creating an ECS Cluster
```
aws ecs create-cluster \
--cluster-name cruddur \
--service-connect-defaults namespace=cruddur
```
### Creating ECR repo and push image
```
aws ecr create-repository \
  --repository-name cruddur-python \
  --image-tag-mutability MUTABLE
```
### Login to ECR
`aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin "$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"`

### Set URL
```
export ECR_PYTHON_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/cruddur-python"
echo $ECR_PYTHON_URL
```
### Pull Image
`docker pull python:3.10-slim-buster`

### Tag Image 
`docker tag python:3.10-slim-buster $ECR_PYTHON_URL:3.10-slim-buster`

### Push Image
`docker push $ECR_PYTHON_URL:3.10-slim-buster`

### For Flask
In the flask dockerfile update the from to instead of using DockerHub's python image
```
aws ecr create-repository \
  --repository-name backend-flask \
  --image-tag-mutability MUTABLE
```
### Build Image
```docker build -t backend-flask . `

### Tag Image
`docker tag backend-flask:latest $ECR_BACKEND_FLASK_URL:latest`

### Push Image
`docker push $ECR_BACKEND_FLASK_URL:latest`

## Register Task Defintions
### Passing Senstive Data to Task Defintion 
```
aws ssm put-parameter --type "SecureString" --name "/cruddur/backend-flask/AWS_ACCESS_KEY_ID" --value $AWS_ACCESS_KEY_ID
aws ssm put-parameter --type "SecureString" --name "/cruddur/backend-flask/AWS_SECRET_ACCESS_KEY" --value $AWS_SECRET_ACCESS_KEY
aws ssm put-parameter --type "SecureString" --name "/cruddur/backend-flask/CONNECTION_URL" --value $PROD_CONNECTION_URL
aws ssm put-parameter --type "SecureString" --name "/cruddur/backend-flask/ROLLBAR_ACCESS_TOKEN" --value $ROLLBAR_ACCESS_TOKEN
aws ssm put-parameter --type "SecureString" --name "/cruddur/backend-flask/OTEL_EXPORTER_OTLP_HEADERS" --value "x-honeycomb-team=$HONEYCOMB_API_KEY"
```

