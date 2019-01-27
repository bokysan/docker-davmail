FROM alpine AS build

RUN apk add curl tar
RUN mkdir -p /opt/davmail
RUN \
    export LINK=`curl --retry-connrefused --retry 5 --connect-timeout 10 -ksL "https://sourceforge.net/projects/davmail/rss?path=/" | fgrep "<link>" | fgrep ".zip" | fgrep -i -v "windows" | fgrep -i -v "osx" | head -n 1 | sed -E 's|.*<link>(.*)</link>.*|\1|'` && \
    echo Latest version.. $LINK && \
    export LINK=`echo "$LINK" | sed -E 's|https://sourceforge|https://downloads.sourceforge|' | sed -E 's|projects/davmail/files/|project/davmail/|' | sed -E 's|/download$||'` && \
    echo Download URL.... $LINK && \
    echo "$LINK" > /tmp/url
RUN \
    curl --retry-connrefused --retry 5 --connect-timeout 10 -kL "$(cat /tmp/url)" -o /opt/davmail.zip && \
    cd /opt/davmail && unzip ../davmail.zip

# ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡ #
FROM openjdk:13-alpine

LABEL maintainer="Bokysan <https://github.com/bokysan/>"

RUN \
    addgroup -g 20191 davmail && adduser -D -u 20191 -G davmail davmail && \
    mkdir -p /etc/davmail /var/log/davmail && \
    chown -R davmail:davmail /etc/davmail /var/log/davmail
COPY --from=build /opt/davmail /opt/davmail
COPY --chown=davmail:davmail davmail.properties /etc/davmail

EXPOSE 1080
EXPOSE 1143
EXPOSE 1389
EXPOSE 1110
EXPOSE 1025

USER davmail

WORKDIR /opt/davmail
CMD [ "/opt/davmail/davmail", "/etc/davmail/davmail.properties"]
