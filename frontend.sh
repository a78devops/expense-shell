source common.sh

print_task_heading "install nginx"
dnf install nginx -y &>>$log
check_status $?

print_task_heading "copy expense nginx configuration"
cp expense.conf /etc/nginx/default.d/expense.conf &>>$log
check_status $?

print_task_heading "clean old content"
rm -rf /usr/share/nginx/html/* &>>$log
check_status $?

print_task_heading "download app content"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/expense-frontend-v2.zip &>>$log
check_status $?

print_task_heading "extract app content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log
check_status $?

print_task_heading "start nginx service"
systemctl enable nginx &>>$log
systemctl restart nginx &>>$log
check_status $?

