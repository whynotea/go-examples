FROM scratch
COPY basic /usr/bin/basic
ENTRYPOINT [ "/usr/bin/basic" ]
