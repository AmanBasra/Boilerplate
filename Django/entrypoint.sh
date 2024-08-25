#!/bin/ash

echo "Apply database migrations"
python manage.py makemigrations --noinput
python manage.py migrate
python manage.py collectstatic --noinput

gunicorn --log-level debug --access-logfile ./access.log --error-logfile ./error.log Wedsite.wsgi:application --bind 0.0.0.0:8000 --certfile cert.crt --keyfile key.key