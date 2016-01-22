FROM ruby

ENV INSTALL_DIR /opt/dailydilbertreducer

RUN apt-get update && apt-get install -y python
RUN git clone https://github.com/phylor/DailyDilbertReducer.git $INSTALL_DIR
WORKDIR $INSTALL_DIR
RUN bundle install
RUN echo '/srv/dilbert/dilbert.rss' > $INSTALL_DIR/feed_file_location.conf
RUN mkdir -p /srv/dilbert

WORKDIR /srv/dilbert
EXPOSE 80

RUN echo '#!/bin/sh\n\
cd /srv/dilbert\n\
nohup python -m SimpleHTTPServer 80 &\n\
cd $INSTALL_DIR\n\
while true; do ruby $INSTALL_DIR/reducer.rb; sleep 86400; done' > /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
