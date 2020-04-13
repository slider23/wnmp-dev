@echo off

IF [%~1] == [] GOTO usage

if [%~2] == [] (
	GOTO usage
) else (
	set cgi_port=%~2
)

if [%~3] == [] (
	GOTO usage
) else (
	set cgi_instances=%~3
)


start "PHP %1 FastCGI Spawner" /B "php-cgi-spawner.exe" %1/php-cgi.exe %cgi_port% %cgi_instances%

echo Started %cgi_instances% PHP %1 FastCGI on port %cgi_port%.

GOTO :EOF

:usage
echo Starts specified process from directory specified.
echo To start php-cgi from php74 directory on 9000 port and 4 instances: wnmp_php_start php74 9000 4
