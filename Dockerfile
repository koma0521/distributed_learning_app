FROM ruby:alpine

ENV LANG=ja_JP.UTF-8
ENV ROOT=/distributed_learning_app
    TZ=Asia/Tokyo

WORKDIR $ROOT
    
RUN apk update &&\
    apk upgrade &&\
    apk add --no-cache \
        gcc \
        g++ \
        libc-dev \
        libxml2-dev \
        linux-headers \
        make \
        nodejs \
        postgresql \
        postgresql-dev \
        tzdata \
        git \
        yarn && \
    apk add --virtual build-packs --no-cache \
        build-base \
        curl-dev

COPY Gemfile $ROOT
COPY Gemfile.lock $ROOT

RUN bundle install -j4

RUN rm -rf /usr/local/bundle/cache/* /usr/local/share/.cache/* /var/cache/* /tmp/* && \
apk del build-packs

COPY . $ROOT

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["sh", "/usr/bin/entrypoint.sh"]
EXPOSE 3000