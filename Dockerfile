FROM debian

ENV NGROK /opt/ngrok
env DOMAIN te.uexun.com

EXPOSE 80 443 4443

copy docker_init.sh $NGROK/start.sh
copy server/ngrokd $NGROK/

copy server.crt $NGROK/server.crt
copy server.key $NGROK/server.key

RUN chmod +x $NGROK/start.sh

CMD $NGROK/start.sh
