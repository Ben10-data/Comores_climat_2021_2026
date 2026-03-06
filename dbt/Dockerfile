FROM python:3.11-slim


RUN apt-get update \
    && apt-get install -y --no-install-recommends bash git vim \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip
RUN pip install dbt-snowflake==1.11.2
# Actuellement on est sur du 1.10, mais par stabilité, j'ai choisi le 1.9

RUN pip install pytz


WORKDIR /usr/app


CMD ["tail","-f","/dev/null"]