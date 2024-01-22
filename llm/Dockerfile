FROM ubuntu:latest

WORKDIR /server

COPY . .

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y python3 pip \
    && apt-get clean

RUN pip install -r ./requirements.txt

EXPOSE 8080

CMD ["uvicorn", "server:app", "--port", "8080"]
