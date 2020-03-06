FROM atlas4openshift/powerai
RUN git clone -b feature-gpubiggan https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows.git atlas
WORKDIR atlas/workflows/BigGAN/gpu
ENTRYPOINT ["/bin/bash", "run.sh"]
