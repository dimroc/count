FROM python:3.6

WORKDIR /app

# Adding requirements files before installing requirements
COPY requirements.txt ./

RUN apt-get update -y && \
    apt-get install -y build-essential libssl-dev openssl libffi-dev python-dev

RUN pip install -r requirements.txt

# Adding the whole repository to the container
COPY . ./
ENTRYPOINT ["./loop"]
CMD ["300"]
