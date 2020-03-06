FROM atlas4openshift/powerai

USER 2051
RUN git clone -b feature-gpubiggan https://github.com/BU-CLOUD-S20/Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows.git /home/pwrai/atlas
#RUN chgrp -R 0 /home/pwrai/atlas && \
#    chmod -R g=u /home/pwrai/atlas
WORKDIR /home/pwrai/atlas

#ENTRYPOINT ["/bin/bash", "./workflows/BigGAN/gpu/entrypoint.sh"]
#USER 2051

#ENTRYPOINT ["/bin/bash", "./workflows/BigGAN/gpu/run.sh"]
#ENTRYPOINT ["echo", "$(whoami)"]
CMD ["echo $(whoami)"]
