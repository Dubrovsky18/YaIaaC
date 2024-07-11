# Установка nginx
nginx:
  pkg:
    - installed

# Запуск службы
  service:
    - running
    - enable: True

# Запуск службы
nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /var/www/html/index.html

# Отправка файла /etc/nginx/nginx.conf на удаленный хост
/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx.conf # путь к файлу на мастер-хосте
    - user: root
    - group: root
    - mode: 644

# Отправка файла index.html на удаленный хост
/usr/share/nginx/html/index.html:
  file.managed:
    - source: salt://nginx/index.html # путь к файлу на мастер-хосте
    - user: www-data
    - group: www-data
    - mode: 644