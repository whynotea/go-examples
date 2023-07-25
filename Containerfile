FROM scratch
COPY basic /usr/bin/basic
COPY basic-cli /usr/bin/basic-cli
CMD [ "/usr/bin/basic" ]
