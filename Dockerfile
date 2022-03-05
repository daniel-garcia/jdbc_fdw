from ubuntu:20.04

RUN apt-get update && apt-get install -y wget gpg 
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget https://www.postgresql.org/media/keys/ACCC4CF8.asc && apt-key add ACCC4CF8.asc

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql-13 postgresql-server-dev-13
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential openjdk-8-jdk-headless ruby-dev
RUN ln -s /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/server/libjvm.so /usr/lib64/libjvm.so
RUN gem install fpm
ADD . /usr/local/jdbc_fdw
WORKDIR /usr/local/jdbc_fdw
RUN USE_PGXS=1 make
RUN USE_PGXS=1 make install DESTDIR=/tmp/jdbc_fdw
RUN fpm -s dir -t deb -C /tmp/jdbc_fdw --name jdbc_fdw --version 1.0.0 --iteration 1 --depends postgresql-13,openjdk-8-jdk-headless 
