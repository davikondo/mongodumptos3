FROM ubuntu:focal

ENV MONGO_URI="mongodb://localhost"
ENV AWS_ACCESS_KEY_ID=value
ENV AWS_SECRET_ACCESS_KEY=value
ENV AWS_DEFAULT_REGION=sa-east-1
ENV S3_BUCKET=value

RUN apt update \
&&  apt install -y mongo-tools python3-pip \
&&  pip3 install awscli \
&& rm -rf /var/lib/apt/lists/*

CMD mongodump --uri ${MONGO_URI} --gzip --archive=/tmp/$(date -u +%Y-%m-%d_%H)_UTC.gz && aws s3 cp "/tmp/$(date -u +%Y-%m-%d_%H)_UTC.gz" "s3://${S3_BUCKET}/$(date -u +%Y-%m-%d)/"
