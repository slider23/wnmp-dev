@echo off

taskkill /im php-cgi-spawner.exe /F > NUL 2>&1
taskkill /im php-cgi.exe /F > NUL 2>&1

echo Taskkill all FastCGI

