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

COPY etc/elasticsearch /etc/elasticsearch

CMD /usr/share/elasticsearch/bin/elasticsearch \
    -p /var/run/elasticsearch/elasticsearch.pid \
    --quiet \
    -Edefault.path.logs=/var/log/elasticsearch \
    -Edefault.path.data=/var/lib/elasticsearch \
    -Edefault.path.conf=/etc/elasticsearch

EXPOSE 9200 9300