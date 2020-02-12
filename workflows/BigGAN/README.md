### BigGAN Workflow Documentation

```
cd workflows/BigGAN/
docker build -t big-gan
docker run -d -v [data_path]:/data big-gan:latest
```
