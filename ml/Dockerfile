FROM continuumio/miniconda3:4.3.11
SHELL ["/bin/bash", "-c"]
RUN apt-get update -y && \
    apt-get install -y build-essential libssl-dev openssl libffi-dev python-dev libgtk2.0-0 libglu1
WORKDIR /app
COPY . ./
ENV KERAS_BACKEND tensorflow
RUN conda env create -f docker.environment.yml
ENTRYPOINT ["/bin/bash", "-c"]
CMD [ "source activate counting_company && KERAS_BACKEND=tensorflow exec python manage.py rpcserver" ]
