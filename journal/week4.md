# Week 4 — Postgres and RDS

### Provisioning a RDS Instance
```
aws rds create-db-instance \
  --db-instance-identifier cruddur-db-instance \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --engine-version  14.6 \
  --master-username root \
  --master-user-password *********** \
  --allocated-storage 20 \
  --availability-zone us-east-1a \
  --backup-retention-period 0 \
  --port 5432 \
  --no-multi-az \
  --db-name cruddur \
  --storage-type gp2 \
  --publicly-accessible \
  --storage-encrypted \
  --enable-performance-insights \
  --performance-insights-retention-period 7 \
  --no-deletion-protection
  ```
After provisioning  I made sure to temporarily stop the RDS instance in order to prevent additional charges since I'm not currently using it.
  
![Stopping RDS Instance](assets/Week_4_RDS_Stop.PNG)
  
### Postgres
To connect to psql via the psql client cli tool
```
psql -Upostgres --host localhost
```
### Creating a database
I can create the database within the PSQL client

```
CREATE database cruddur;
```
### Import Script
I created a new SQL file called schema.sql and placed it in backend-flask/db then pasted in the UUID extension
```
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
```

