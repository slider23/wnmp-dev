@echo off

echo Killing nginx.
taskkill /im nginx.exe /F > NUL 2>&1

pushd nginx
start "nginx" /B "nginx.exe"
popd
echo Started nginx at port 80
