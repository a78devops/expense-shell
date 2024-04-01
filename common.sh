log=/tmp/expense.log

print_task_heading() {
  echo $1
  echo "########## $1 ##########" &>>$log
}

check_status() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

app_prereq() {
 print_task_heading "clean the old content"
 rm -rf ${app_dir} &>>$log
 check_status $?

 print_task_heading "create app directory"
 mkdir ${app_dir} &>>$log
 check_status $?

 print_task_heading "download app content"
 curl -o /tmp/${component}.zip https://expense-artifacts.s3.amazonaws.com/expense-${component}-v2.zip &>>$log
 check_status $?

 print_task_heading "extract app content"
 cd ${app_dir} &>>$log
 unzip /tmp/${component}.zip &>>$log
 check_status $?
}

