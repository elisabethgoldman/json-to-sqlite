FROM python:3.10 as builder

ENV VIRTUAL_ENV=/home/ubuntu/merge-sqlite/docker_test_env

RUN python3 -m venv $VIRTUAL_ENV 

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY ./ /opt

WORKDIR /opt

RUN pip install greenlet==2.0.0
RUN pip install tox && tox -p

FROM python:3.10

COPY --from=builder /opt/dist/*.tar.gz /opt
COPY dev-requirements.txt /opt

WORKDIR /opt

RUN pip install -r dev-requirements.txt *.tar.gz \
        && rm -f *.tar.gz dev-requirements.txt

ENTRYPOINT ["json_to_sqlite"]

CMD ["--help"]
