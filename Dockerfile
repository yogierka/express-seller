FROM gitpod/workspace-full-vnc
RUN sudo apt-get update
RUN sudo apt-get install wget
# A browser for testing
RUN sudo apt-get install -y firefox
# A REST Client for express.js API testing
# Add to sources
RUN echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" | sudo tee -a /etc/apt/sources.list.d/insomnia.list

# Add public key used to verify code signature
RUN wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc | sudo apt-key add -

# Refresh repository sources and install Insomnia
RUN sudo apt-get update
RUN sudo apt-get install -y insomnia
# The powerful Visual Studio Code for someone that wants it
RUN sudo apt-get install -y software-properties-common apt-transport-https
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
RUN sudo apt-get update && sudo apt-get -y install code
# A Database Client is always useful with Express.js
RUN sudo apt-get install -y openjdk-8-jdk
RUN wget -O - https://dbeaver.io/debs/dbeaver.gpg.key | sudo apt-key add -
RUN echo "deb https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
RUN sudo apt update && sudo apt install -y dbeaver-ce
RUN apt-get update && apt-get install -y \
        postgresql \
        postgresql-contrib \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
USER gitpod
ENV PATH="/usr/lib/postgresql/10/bin:$PATH"
RUN mkdir -p ~/pg/data; mkdir -p ~/pg/scripts; mkdir -p ~/pg/logs; mkdir -p ~/pg/sockets; initdb -D pg/data/
RUN echo '#!/bin/bash\n\
pg_ctl -D ~/pg/data/ -l ~/pg/logs/log -o "-k ~/pg/sockets" start' > ~/pg/scripts/pg_start.sh
RUN echo '#!/bin/bash\n\
pg_ctl -D ~/pg/data/ -l ~/pg/logs/log -o "-k ~/pg/sockets" stop' > ~/pg/scripts/pg_stop.sh
RUN chmod +x ~/pg/scripts/*
ENV PATH="$HOME/pg/scripts:$PATH"
USER root
