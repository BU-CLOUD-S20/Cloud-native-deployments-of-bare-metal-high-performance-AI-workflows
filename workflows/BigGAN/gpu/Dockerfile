FROM atlas4openshift/powerai

RUN useradd -m -s atlas
USER atlas

RUN git clone -b feature-gpubiggan https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows.git /home/atlas/atlas4openshift & \
    /home/pwrai/anaconda/bin/conda init

WORKDIR /home/atlas/atlas4openshift
ENTRYPOINT ["/bin/bash", "./workflows/BigGAN/gpu/entrypoint.sh"]
