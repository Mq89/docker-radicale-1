FROM python:3.9-alpine as builder

WORKDIR /app

RUN apk add --no-cache alpine-sdk libffi-dev
RUN pip install --user radicale[bcrypt]~=3.0


FROM python:3.9-alpine

RUN apk add --no-cache apache2-utils

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local:$PATH

WORKDIR /app

COPY ./entrypoint.sh .

ENV CONFIG_FILE=/data/config.ini
ENV USER_FILE=/data/users

VOLUME [ "/data" ]

EXPOSE 5232

CMD [ "/app/entrypoint.sh" ]