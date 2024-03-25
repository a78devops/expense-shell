source common.sh


mysql_root_password=$1

# If password is not provided then we will exit
if [ -z "${mysql_root_password}" ]; then
  echo input password is missing.
  exit 1
fi

Print_Task_Heading "disable default NodeJS version module"
dnf module disable nodejs -y &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Enable NodeJS module for V20"
dnf module enable nodejs:20 -y &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "Install NodeJS"
dnf install nodejs -y &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "adding application user"
useradd expense &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "copy backend service file"
cp backend.service /etc/systemd/system/backend.service &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "clean the old content"
rm -rf /app &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "create app directory"
mkdir /app &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "download app content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "extract app content"
cd /app &>>/tmp/expense.log
unzip /tmp/backend.zip &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "download NodeJS dependencies"
cd /app &>>/tmp/expense.log
npm install &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "start backend service"
systemctl daemon-reload &>>/tmp/expense.log
systemctl enable backend &>>/tmp/expense.log
systemctl start backend &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "install mysql client"
dnf install mysql -y &>>/tmp/expense.log
Check_Status $?

Print_Task_Heading "load schema"
mysql -h 54.146.189.38 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>/tmp/expense.log
Check_Status $?

