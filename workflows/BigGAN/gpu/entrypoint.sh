HOME=/home/pwrai

echo "import pty; pty.spawn('/bin/bash')" > /tmp/enter_into_bash.py
python3 /tmp/enter_into_bash.py

su pwrai
bash $HOME/workflows/BigGAN/gpu/run.sh
