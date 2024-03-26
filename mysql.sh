source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo input password is missing
  exit 1
fi

print_task_heading "install mysql server"
dnf install mysql-server -y &>>$log
check_status $?

print_task_heading "start mysql service"
systemctl enable mysqld &>>$log
systemctl start mysqld &>>$log
check_status $?

print_task_heading "setup mysql password"
echo 'show database' |mysql -h 172.31.88.242  -uroot -p${mysql_root_password} &>>$log
if [ $? -ne 0 ]; then
  mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$log
fi
check_status $?
