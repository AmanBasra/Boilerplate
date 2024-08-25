FROM python:3.11-alpine
WORKDIR /usr/src/app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip3 install --upgrade pip
RUN apk update
RUN apk add make automake gcc g++ subversion python3-dev
RUN apk add libpq-dev

COPY ./requirements.txt /usr/src/app/requirements.txt

RUN pip3 install -r requirements.txt

COPY ./entrypoint.sh /usr/src/app/entrypoint.sh


COPY . /usr/src/app/
EXPOSE 8000
RUN chmod +x /usr/src/app/entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]