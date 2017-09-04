FROM continuumio/miniconda3:4.3.11

WORKDIR /app

# Adding requirements files before installing requirements
COPY requirements.txt ./

RUN apt-get update -y && \
    apt-get install -y build-essential libssl-dev openssl libffi-dev python-dev

COPY . ./
RUN conda install --yes --file requirements.txt -c menpo
ENTRYPOINT ["./bin/loop"]
CMD ["300"]
