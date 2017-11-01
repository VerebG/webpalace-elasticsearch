FROM opsbears/base:16.04

RUN apt-get update \
  && apt-get install -y software-properties-common locales openjdk-8-jre wget apt-transport-https \
  && locale-gen en_US.UTF-8 \
  && wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
  && echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-5.x.list \
  && apt-get update \
  && apt-get install -y elasticsearch \
  && rm -rf /var/lib/apt/lists/*

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV JAVACMD="/usr/bin/java"
ENV ES_CONF_DIR='/etc/elasticsearch'
ENV ES_DATA_DIR='/var/lib/elasticsearch'
ENV ES_LOG_DIR='/var/log/elasticsearch'

COPY etc/elasticsearch $ES_CONF_DIR
RUN mkdir -p {$ES_CONF_DIR,$ES_DATA_DIR,$ES_LOG_DIR} && \
    chown elasticsearch:elasticsearch -R {$ES_CONF_DIR,$ES_DATA_DIR,$ES_LOG_DIR}

RUN /usr/share/elasticsearch/elasticsearch-plugin install x-pack

USER elasticsearch

CMD /usr/share/elasticsearch/bin/elasticsearch \
    -p /var/run/elasticsearch/elasticsearch.pid \
    --quiet \
    -Edefault.path.logs=$ES_LOG_DIR \
    -Edefault.path.data=$ES_DATA_DIR \
    -Edefault.path.conf=$ES_CONF_DIR

EXPOSE 9200 9300