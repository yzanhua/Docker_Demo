FROM gcc:9.4

COPY install.sh .
RUN chmod +x ./install.sh
RUN ./install.sh

COPY hello_world.c /mpich-demo/c
COPY makefile /mpich-demo/c
COPY send_rec.py /mpich/py
