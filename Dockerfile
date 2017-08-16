FROM debian

ENV NGROK /opt/ngrok
env DOMAIN te.uexun.com

EXPOSE 80 443 4443

copy start.sh $NGROK/
copy server/ngrokd $NGROK/

copy server.crt $NGROK/server.crt
copy server.key $NGROK/server.key

RUN chmod +x $NGROK/start.sh

CMD $NGROK/start.sh
