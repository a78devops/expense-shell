source common.sh

app_dir=/usr/share/nginx/html
component=frontend

print_task_heading "install nginx"
dnf install nginx -y &>>$log
check_status $?

print_task_heading "copy expense nginx configuration"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log
check_status $?

app_prereq

print_task_heading "start nginx service"
systemctl enable nginx &>>$log
systemctl restart nginx &>>$log
check_status $?

