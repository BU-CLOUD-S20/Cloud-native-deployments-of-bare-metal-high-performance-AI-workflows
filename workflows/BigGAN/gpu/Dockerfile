FROM atlas4openshift/powerai

RUN id && git clone -b feature-gpubiggan https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows.git /home/pwrai/atlas && \
    chgrp -R 0 /home/pwrai && \
    chmod -R g=u /home/pwrai && \
    chmod g=u /etc/passwd
    #chmod -R og+r /proc/driver

ENV LD_LIBRARY_PATH="/usr/local/nvidia/lib:/usr/local/nvidia/lib64"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,utility"
ENV NVIDIA_REQUIRE_CUDA=cuda>="10.1"

WORKDIR /home/pwrai/atlas

ENTRYPOINT ["/bin/bash", "./workflows/BigGAN/gpu/entrypoint.sh"]
USER 2051

#ENTRYPOINT ["/bin/bash", "./workflows/BigGAN/gpu/run.sh"]
# CMD ["whoami"]
