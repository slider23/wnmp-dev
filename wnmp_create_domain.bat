@echo off
SetLocal
if "%1" equ "" goto usage

set templatefile = %2
if "%2" equ "" set templatefile = laravel

copy /y nginx\conf\vhosts\laravel nginx\conf\vhosts\%1.conf

sed -i -e 's/DOMAIN/%1/g' nginx\conf\vhosts\%1.conf
sed -i -e 's/PATH/c:\/Sites\/%1\/public/g' nginx\conf\vhosts\%1.conf

echo Nginx nginx\conf\vhosts\%1.conf vhost added

echo 127.0.0.1 %1 >> c:\Windows\System32\drivers\etc\hosts

echo Hosts file c:\Windows\System32\drivers\etc\hosts updated

set /p "restart=Restart wnmp-dev ? [y,n]"
if "%restart%" equ "y" (
call wnmp_all_restart
)
exit

:usage
echo Create
echo Usage: wnmp_create_domain domain_name nginx_vhost_template
echo By default nginx_vhost_template is "laravel"
echo Example: wnmp_create_domain foo.local
echo Example: wnmp_create_domain bar.local slim
