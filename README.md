# Docker образ PHP-FPM

[ ![Download](https://api.bintray.com/packages/javister/docker/javister%3Ajavister-docker-php/images/download.svg) ](https://bintray.com/javister/docker/javister%3Ajavister-docker-php/_latestVersion)

## Введение

В большинстве случаев руководства по установке PHP рекомендуют устанавливать 
PHP-FPM совместно с Nginx или Apache Server. Это связано с тем, что PHP-FPM
работает не по протоколу HTTP, а по протоколу FastCGI и без того-же Nginx работать
с PHP приложением не выйдет.

В тоже время для Docker образа устанавливать сразу и PHP-FPM и Nginx - избыточно.
Гораздо выгоднее иметь PHP-FPM отдельно, а Nginx - отдельно. Тогда можно, 
например, отдельно масштабировать контейнеры с PHP-FPM, не имея накладных 
расходов на ненужное, по сути, промежуточное звено в виде дублирующихся инстансов
Nginx. Последний-же можно запустить один раз и обеспечивать с его помощью 
масштабирование по многим контейнерам PHP-FPM.

Данный образ не содержит каких-либо приложений. Он является базовым для
построения других образов, уже с приложениями.

## Построение образов с приложениями

*TBD*

## Настройка

Для настройки в образе предусмотрен ряд переменных окружения, значения которых
подставляются в файл конфигурации PHP-FPM:

|Имя переменной             |Описание|
|---------------------------|--------|
|FPM_PM                     |Choose how the process manager will control the number of child processes.|
|FPM_PM_MAX_CHILDREN        |The number of child processes to be created when pm is set to 'static' and the maximum number of child processes when pm is set to 'dynamic' or 'ondemand'. This value sets the limit on the number of simultaneous requests that will be served. Equivalent to the ApacheMaxClients directive with mpm_prefork. Equivalent to the PHP_FCGI_CHILDREN environment variable in the original PHP CGI. The below defaults are based on a server without much resources. Don't forget to tweak pm.* to fit your needs. Note: Used when pm is set to 'static', 'dynamic' or 'ondemand' Note: This value is mandatory.
|FPM_PM_START_SERVERS       |The number of child processes created on startup. Note: Used only when pm is set to 'dynamic' Default Value: `min_spare_servers + (max_spare_servers - min_spare_servers) / 2`
|FPM_PM_MIN_SPARE_SERVERS   |The desired minimum number of idle server processes. Note: Used only when pm is set to 'dynamic' Note: Mandatory when pm is set to 'dynamic'
|FPM_PM_MAX_SPARE_SERVERS   |The desired maximum number of idle server processes. Note: Used only when pm is set to 'dynamic'Note: Mandatory when pm is set to 'dynamic'
|FPM_PM_PROCESS_IDLE_TIMEOUT|The number of seconds after which an idle process will be killed. Note: Used only when pm is set to 'ondemand' Default Value: 10s
|FPM_PM_MAX_REQUESTS        |The number of requests each child process should execute before respawning. This can be useful to work around memory leaks in 3rd party libraries. For endless request processing specify '0'. Equivalent to PHP_FCGI_MAX_REQUESTS. Default Value: 0

## Утилиты
### cgi-fci

Для удобства диагностики в образе установлена утилита `cgi-fcgi`, которая
позволяет [обращаться](http://www.gregfreeman.io/2016/how-to-connect-to-php-fpm-directly-to-resolve-issues-with-blank-pages/)
к сервису по протоколу FastCGI.

Пример:

```bash
SCRIPT_FILENAME=/ping \
    REQUEST_URI=/ping \
    QUERY_STRING= \
    REQUEST_METHOD=GET \
    cgi-fcgi -bind -connect ${HOSTNAME}:9000
```