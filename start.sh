#!/bin/bash
./server/ngrokd -tlsKey=./server.key -tlsCrt=./server.crt -domain="te.uexun.com" -httpAddr=":8880" -httpsAddr=":8443" -log='/var/log/ngrok.log'
