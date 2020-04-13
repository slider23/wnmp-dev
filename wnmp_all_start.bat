@echo off

call wnmp_php_stop
call wnmp_php_start php56 9056 2
call wnmp_php_start php74 9074 2

pushd nginx
start "nginx" /B "nginx.exe"
popd
echo Started nginx at port 80

start "MySQL57" /B "mysql57\bin\mysqld.exe" "--defaults-file=mysql57\my.ini"
echo Started MySQL 5.7 with config mysql57/my.ini
