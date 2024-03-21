mysql_root_password=$1

echo Disable default NodeJS version Module
dnf module disable nodejs -y &>>/tmp/expense.log
echo $?

echo Enable NodeJS module for V20
dnf module enable nodejs:20 -y &>>/tmp/expense.log
echo $?

echo Install NodeJS
dnf install nodejs -y &>>/tmp/expense.log
echo $?

echo adding application user
useradd expense &>>/tmp/expense.log
echo $?

echo copy backend service file
cp backend.service /etc/systemd/system/backend.service &>>/tmp/expense.log
echo $?

echo clean the old content
rm -rf /app &>>/tmp/expense.log
echo $?

echo create app directory
mkdir /app &>>/tmp/expense.log
echo $?

echo download app content
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>/tmp/expense.log
echo $?

echo extract app content
cd /app &>>/tmp/expense.log
unzip /tmp/backend.zip &>>/tmp/expense.log
echo $?


echo download NodeJS dependencies
cd /app &>>/tmp/expense.log
npm install &>>/tmp/expense.log
echo $?

echo start backend service
systemctl daemon-reload &>>/tmp/expense.log
systemctl enable backend &>>/tmp/expense.log
systemctl start backend &>>/tmp/expense.log
echo $?

echo install mysql client
dnf install mysql -y &>>/tmp/expense.log
echo $?

echo load schema
mysql -h 172.31.47.222 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>/tmp/expense.log
echo $?
