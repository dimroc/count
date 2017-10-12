FROM continuumio/miniconda3:4.3.11
SHELL ["/bin/bash", "-c"]
RUN apt-get update -y && \
    apt-get install -y build-essential libssl-dev openssl libffi-dev python-dev libgtk2.0-0 libglu1
WORKDIR /app
COPY docker.environment.yml .
RUN ["conda", "env", "create", "--file", "docker.environment.yml"]
COPY . ./
ENTRYPOINT ["/bin/bash", "-c"]
CMD [ "source activate counting_company && KERAS_BACKEND=tensorflow exec python -u manage.py rpcserver" ]
EXPOSE 50051 50052
