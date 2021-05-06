FROM ubuntu:focal

ENV MONGO_URI="mongodb://user:P%40ssw0rd@localhost/"
ENV AWS_ACCESS_KEY_ID=value
ENV AWS_SECRET_ACCESS_KEY=value
ENV AWS_DEFAULT_REGION=sa-east-1
ENV S3_BUCKET=value

RUN apt-get update \
&&  apt-get install -y mongo-tools python3-pip --no-install-recommends \
&&  pip3 install awscli \
&& rm -rf /var/lib/apt/lists/*

RUN echo '#!/bin/bash \n\
export TIMESTAMP=$(date -u +%Y-%m-%d_%Hh%M) \n\
export ACTUALDATE=$(echo $TIMESTAMP | cut -d_ -f1) \n\
echo "Creating mongo dump file at ${TIMESTAMP}" \n\
mongodump --uri ${MONGO_URI} --out=./${ACTUALDATE}\${TIMESTAMP} \n\
echo "Done"' > /bin/backup.sh \
&& chmod +x /bin/backup.sh

WORKDIR /backup

VOLUME [ "/backup" ]

CMD [ "backup.sh" ]
