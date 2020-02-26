### BigGAN Workflow Documentation
We replicate the [BigGAN workflow]() on Satori to make it runnable on local, cpu-only environment  

The local workflow is then containerize into a docker image.

#### Data
The model is trained on ImageNet2012. The whole image set can be downloaded [here]().  

For the sake of fast reproduction, we train our workflow on a subset of the training data (150MB).  

#### Tutorial
```bash
cd Cloud-native-deployments-of-bare-metal-high-performance-AI-workflows/ # hate the long repo name...
cd workflows/BigGAN/
docker build -t big-gan
docker run -d -v [data_path]:/data big-gan:latest
```
