FROM scratch

COPY bin /opt/bin
COPY cni /opt/cni
COPY images.tgz /opt/images.tgz
COPY services /opt/services
COPY contiv-1.1.1 /opt/contiv-1.1.1

