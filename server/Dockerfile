FROM python:3.10

ADD https://github.com/vishnubob/wait-for-it/raw/master/wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

WORKDIR /server

COPY . .
RUN pip install -r requirements.txt

ENTRYPOINT ["/wait-for-it.sh", "mongodb:27017", "-t", "100", "--", "python", "server.py"]