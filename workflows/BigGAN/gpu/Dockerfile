FROM atlas4openshift/powerai

# USER 2051
RUN git clone -b feature-gpubiggan https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows.git /home/pwrai/atlas && \
    chgrp -R 0 /home/pwrai && \
    chmod -R g=u /home/pwrai && \
    chmod g=u /etc/passwd && \
    chmod -R og+r /proc/driver

WORKDIR /home/pwrai/atlas

ENTRYPOINT ["/bin/bash", "./workflows/BigGAN/gpu/entrypoint.sh"]
USER 2051

#ENTRYPOINT ["/bin/bash", "./workflows/BigGAN/gpu/run.sh"]
# CMD ["whoami"]
