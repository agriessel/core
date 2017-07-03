FROM node:8.1
# Usage:
# Use existing host SSL keys
# docker run -d -p 8080:8080 -v /etc/letsencrypt/:/etc/letsencrypt/ --name "nimiq" nimiq
# Override Docker environment variables, you will need to ensure you mount a volume where the key and crt files are located on the local host
# docker run -d -p 8080:8080 -e "DOMAIN=example.com" -e "SEED=seed" -e "KEY=/path/to/keyfile" -e "CRT=/path/to/crtfile" -v /etc/letsencrypt/:/etc/letsencrypt/ --name "nimiq" nimiq


ENV RELEASE="https://github.com/agriessel/core/archive/dockerseed.tar.gz"
ENV DOMAIN="node.nimiq.io"
ENV SEED="xxxxx"
ENV KEY="/etc/letsencrypt/live/nimiq.io/privkey.pem"
ENV CRT="/etc/letsencrypt/live/nimiq.io/cert.pem"
ENV PORT="8080"

RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y python build-essential

RUN wget ${RELEASE} && tar -xvzf ./master.tar.gz
RUN cd /core-dockerseed && npm install && npm run build

EXPOSE ${PORT}
ENTRYPOINT node /core-dockerseed/clients/nodejs/index.js --host ${DOMAIN} --port ${PORT} --key ${KEY} --cert ${CRT} --wallet-seed=${SEED} --miner
