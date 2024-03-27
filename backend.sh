source common.sh


mysql_root_password=$1
app_dir=/app
component=backend

# If password is not provided then we will exit
if [ -z "${mysql_root_password}" ]; then
  echo input password is missing.
  exit 1
fi

print_task_heading "disable default nodejs version module"
dnf module disable nodejs -y &>>$log
check_status $?

print_task_heading "enable nodejs module for v20"
dnf module enable nodejs:20 -y &>>$log
check_status $?

print_task_heading "install nodejs"
dnf install nodejs -y &>>$log
check_status $?

print_task_heading "adding application user"
id expense &>>$log
if [ $? -ne 0 ]; then
  useradd expense &>>$log
fi
check_status $?

print_task_heading "copy backend service file"
cp backend.service /etc/systemd/system/backend.service &>>$log
check_status $?

app_prereq

print_task_heading "download nodejs dependencies"
cd /app &>>$log
npm install &>>$log
check_status $?

print_task_heading "start backend service"
systemctl daemon-reload &>>$log
systemctl enable backend &>>$log
systemctl start backend &>>$log
check_status $?

print_task_heading "install mysql client"
dnf install mysql -y &>>$log
check_status $?

print_task_heading "load schema"
mysql -h mysql-dev.bdevops55.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$log
check_status $?

