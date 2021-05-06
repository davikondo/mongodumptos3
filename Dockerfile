FROM ubuntu:focal

ENV MONGO_URI="mongodb://user:P%40ssw0rd@localhost/"

RUN apt-get update \
&&  apt-get install -y mongo-tools --no-install-recommends \
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
