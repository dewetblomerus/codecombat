FROM node:5.10.1
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update
RUN apt-get install -y build-essential python2.7 git curl mongodb-org
RUN npm config set python `which python2.7`
RUN useradd -ms /bin/bash combat
USER combat
WORKDIR /home/combat
#RUN git config --global user.name "De Wet"
#RUN git config --global user.email "dewet@blomerus.org"
#RUN git clone https://github.com/codecombat/codecombat.git
RUN git clone http://blom:9999/dewet/codecombat.git
WORKDIR /home/combat/codecombat
#RUN git remote add -f upstream https://github.com/codecombat/codecombat.git
RUN npm install
ENV PATH "$PATH:/usr/bin/mongod"
RUN mkdir -p /data/db
WORKDIR /tmp
COPY dump.tar.gz .
RUN tar xzf dump.tar.gz
RUN mongod --fork --logpath /var/log/mongo && mongorestore --drop --noIndexRestore --host 127.0.0.1
WORKDIR /home/combat
#ENTRYPOINT "mongod --fork --logpath /var/log/mongo && npm run dev"
