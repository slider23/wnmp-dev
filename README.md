# wnmp-dev

English readme below

wnmp-dev это веб-окружение для Windows для php-разработки. Замена OpenServer (ospanel.io). 

Идеология данного проекта - дать php-разработчикам под windows удобную среду, похожую на среду linux-разработчиков, с настройкой через стандартные конфигурационные файлы приложений. 

В комплекте идёт веб-сервер nginx, php версий 5.6 и 7.4, mysql 5.7 . Php всех версий работают в браузере одновременно, т.е. вы можете параллельно с новыми проектами работать и со старыми легаси-проектами.

Для запуска php для nginx используется PHP CGI spawner (`php-cgi-spawner.exe`) https://github.com/deemru/php-cgi-spawner   

Этот репозиторий - форк оригинального репозитория Александра Макарова https://github.com/samdark/wnmp-dev с предустановленными php 5.6 , php 7.4 и mysql 5.7 

## Установка

1. Загрузите релиз и распакуйте в любую удобную папку.
2. ВАЖНО! Проинициализируйте mysql, создав дефолтную структуру баз данных. Выполните `mysql57\bin\mysqld.exe --defaults-file=mysql57\my.ini --initialize-insecure` . Будет создан mysql-пользователь root без пароля.
3. Измените конфиги `php56/php.ini`, `php74/php.ini`, `mysql57/php.ini`, `nginx/conf/nginx.conf` под свои нужды, если это требуется.
4. Добавьте путь до корневой папки в PATH, чтобы работал консольный php. Проверьте, чтобы в PATH у вас не осталось путей, которые могут вести на другие версии php.
5. Добавьте домен в nginx. Для этого скопируйте шаблон (файл без расширения в папке `nginx/conf/vhosts/`) в файл с расширением `.conf` и измените внутри название домена и путь до файлов. Добавьте домен в файл c:\Windows\System32\drivers\etc\hosts.
Можете вместо ручного добавления воспользоваться скриптом: `wnmp_create_domain foobar.local`. Скрипт требует наличия консольной утилиты `sed` в системе (она идёт в комплекте с `git`). Отредактируйте скрипт, заменив дефолтный путь размещения сайтов (c:\Sites) на ваш. 
6. Запустите nginx, mysql и обработчики php: `wnmp_all_start` или `wnmp_all_restart`
7. Всё, можно работать !
     
## Работа

Не бойтесь менять все конфиги и скрипты запуска. Делайте удобную для себя среду.

Скрипт `wnmp_all_start` запускает процессы обработки php 5.6 и php 7.4 на портах 9056 и 9074 соответственно. К этим портам коннектится nginx, обрабатывая директиву `fastcgi_pass` в конфиге домена. Чтобы домен работал на нужной версии php - просто поменяйте порт.

Версия php в консоли по умолчанию задаётся в файле `php.bat`. Так как папка добавлена в PATH, любое использование `php` (в phpstorm и любых терминалах) будет обращаться к этому файлу. Чтобы использовать другую версию php в консоли без изменения дефолта - вызовите соотвествующий батник явно - `php56 legacy_script.php`

Команды `composer`, `composer56`, `composer74` вызывают composer.phar при помощи соответствующих версий php. 

Конфигурационные файлы php - `php.ini`, они находятся в соответствующих php-папках. Они общие для консоли и веба. Для консольного запуска `max_execution_time` в конфиге игнорируется и ставится в 0.      

Конфиг nginx - `nginx/conf/nginx.conf`

Конфиг mysql - `mysql57/my.cnf`, он явно указывается в `wnmp_all_start`

Логи nginx - запросы к вебсерверу: `nginx/logs/domain.local-access.log`, ошибки соединения с php: `nginx/logs/domain.local-error.log` 

Логи mysql - лог работы mysqld: `mysql57/data/mysql57.err`, лог медленных запросов: `mysql57/data/mysql57-slow.err`, лог всех запросов: `mysql57/data/mysql57.log` (по умолчанию выключен)

## Добавление новой версии php

Для добавления новой версии php нужно:

1. На [http://windows.php.net/download/](http://windows.php.net/download/) найти **x86 Non Thread Safe** нужной версии, скачать zip и распаковать в папку внутри wnmp-dev. Для удобства папки рекомендуется называть по аналогии с существующими, с номером версии.
2. Внутри скопировать `php-development.ini` в `php.ini` . Файл нужно отредактировать, раскомментировать `extension_dir = "ext"` , в зоне `Dynamic Extensions` расскоментировать 
нужные расширения php, идущие в комплекте, если нужны дополнительные (например xdebug) - скачать необходимые dll в папку ext и дополнить конфиг.
3. Отредактировать `wnmp_php_restart` - добавить вызов нового php на нужном порту и с нужным количеством инстансов.
4. Создать `phpXX.bat` и `composerXX.bat`.
5. Если нужно сделать его дефолтным в консоли - отредактировать `php.bat`
6. Запустить `wnmp_all_restart`  

## Добавления новой версии mysql

Для добавления новой версии mysql (например, 5.6 для легаси-проектов) нужно:

1. На [https://downloads.mysql.com/archives/community/](https://downloads.mysql.com/archives/community/) скачать mysql нужной версии, распаковать в папку внутри wnmp-dev. Для удобства папки рекомендуется называть по аналогии с существующими, с номером версии.  
2. Внутри создать конфиг-файл, например my.ini, в котором указать нужные настройки. Особое внимание уделить параметрам: `datadir=` , в котором указывается путь до баз данных, `port=`, в котором указывается порт, на котором будет висеть БД, если вы хотите иметь несколько одновременно запущенных баз данных, им надо назначить разные порты.   
3. Если баз даных нет, запустить создание базового набора (пользователи, права и т.п.): `mysqlXX\bin\mysqld.exe --defaults-file=mysqlXX\my.ini --initialize-insecure` . Создастся mysql-пользователь `root` без пароля.
4. Отредактировать `wnmp_all_start` - добавить вызов нового mysql, по аналогии с mysql57. Укажите путь до конфиг-файла.
5. Отредактировать `wnmp_all_stop` - добавить вызов mysqladmin для остановки mysql, по аналогии с mysql57. Если у вас несколько mysql на разных портах, укажите порт явно. 
6. Запустить `wnmp_all_restart`

Добавление postgres, mariadb происходит по тому же принципу, но с особенностями, присущими каждой платформе. 

## FAQ

**А где redis, memcached и т.д. ?**

Скачайте инсталлятор нужного вам софта и поставьте в систему. Со времён Денвера почему-то принято делать сборки веб-окружения портабельными, но для этого нет никакой реальной необходимости. Какие-то программы проще поставить глобально или при помощи пакетного менеджера `choko` или подобных. Это же, кстати, относится и к установке баз данных - их тоже можно ставить windows-инсталлятором, если делать версию в wnmp-dev неудобно.    

**Какой ещё софт полезен для организации веб-окружения на windows ?**

Git for windows - https://gitforwindows.org/ . В комплекте идёт мастхэвный комплект из базовых unix-утилит.

Удобный терминал - https://cmder.net/ . При наличии git можно ставить minimal-версию.

Клиент для работы с базами данных HeidiSQL - https://www.heidisql.com/

**Как ещё можно упростить разработку под windows ?**

Можно делать алиасы. Синтаксис batch files придумали чужие для хищников, но разобраться в нём можно. Например, файл `pf.bat` в папке, добавленной в PATH с содержимым `@clear && "vendor\bin\phpunit" --filter=%*` выполняет аналогичные функции, что и строка `alias pf = clear && vendor/bin/phpunit --filter=` в `.bashrc` в unix-системах - а именно, команда `pf name_of_test` в папке проекта запускает выполнение теста с этим именем.

Можете располагать свои алиасы в корне wnmp-dev , а можете сделать папку aliases и добавить её в PATH. Справочник по синтаксису: https://en.wikibooks.org/wiki/Windows_Batch_Scripting 

-------------------------------------------

# English readme for wnmp-dev

wnmp-dev is development environment for Windows that consists of nginx, MySQL and PHP.

## Installation

1. Download last release and unzip to some folder
2. Add folder to PATH
3. Add domain to `nginx/conf/vhosts` - copy `nginx/conf/vhosts/laravel` to `nginx/conf/vhosts/foobar.local.conf` and edit it to point to your webroot
4. Add domain to hosts file
4. `wnmp_all_restart`  

##Customization
-------------
1. Download PHP [from PHP for Windows website](http://windows.php.net/download/). You need `nts` and `x86` zip.
2. Extract archive. PHP 5.5 should end up in `php55`, PHP 7.5 should end up in `php75` etc.
3. Download [MariaDB](https://downloads.mariadb.org/) or [MySQL](https://downloads.mysql.com/archives/community/),
   put it to folder `mysql56` for example. 
4. Create config files. Initialize database `mysql56\bin\mysqld.exe --defaults-file=mysql56\my.ini --initialize-insecure`
5. Add new software to .bat files 

## Credits

- PHP CGI spawner (`php-cgi-spawner.exe`): https://github.com/deemru/php-cgi-spawner
- Original wnmp-dev: https://github.com/samdark/wnmp-dev
