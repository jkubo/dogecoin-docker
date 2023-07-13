FROM debian:bullseye-slim

LABEL maintainer.0="Dave Sharone <radardave1@gmai.....>" \
    maintainer.1="Jay Kubo <@jkubo>"

ARG UID=101
ARG GID=101

RUN groupadd --gid ${GID} dogecoin \
    && useradd --create-home --no-log-init -u ${UID} -g ${GID} dogecoin \
    && apt update -y \
    && apt install -y curl gpg ca-certificates tar dirmngr gosu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG TARGETPLATFORM
ENV DOGECOIN_VERSION=1.14.6
ENV DOGECOIN_DATA=/home/dogecoin/.dogecoin
ENV PATH=/opt/dogecoin-${DOGECOIN_VERSION}/bin:$PATH

RUN set -ex \
  && if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then export TARGETPLATFORM=x86_64-linux-gnu; fi \
  && if [ "${TARGETPLATFORM}" = "linux/arm64" ]; then export TARGETPLATFORM=aarch64-linux-gnu; fi \
  && if [ "${TARGETPLATFORM}" = "linux/arm/v7" ]; then export TARGETPLATFORM=arm-linux-gnueabihf; fi \
  && curl -SLO https://github.com/dogecoin/dogecoin/releases/download/v${DOGECOIN_VERSION}/dogecoin-${DOGECOIN_VERSION}-${TARGETPLATFORM}-linux-gnu.tar.gz \
  && tar -xzf *.tar.gz -C /opt

WORKDIR /opt
RUN install -m 0755 -o root -g root -t /opt/dogecoin-${DOGECOIN_VERSION}/bin dogecoin-${DOGECOIN_VERSION}/bin/*

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME ["/home/dogecoin/.dogecoin"]

EXPOSE 22556

ENTRYPOINT ["/entrypoint.sh"]

RUN dogecoind -version
# | grep "Dogecoin Core version v${DOGECOIN_VERSION}"

CMD ["dogecoind", "-printtoconsole"]