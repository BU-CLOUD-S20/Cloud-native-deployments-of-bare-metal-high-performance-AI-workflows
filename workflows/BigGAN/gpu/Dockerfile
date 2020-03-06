FROM atlas4openshift/powerai

RUN git clone -b feature-gpubiggan https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows.git /home/pwrai/atlas
WORKDIR /home/pwrai/atlas

USER 2051
ENTRYPOINT ["/bin/bash", "./workflows/BigGAN/gpu/entrypoint.sh"]
