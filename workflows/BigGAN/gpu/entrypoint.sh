HOME=/home/pwrai

echo "import pty; pty.spawn('/bin/bash')" > /tmp/enter_into_bash.py
python3 /tmp/enter_into_bash.py

su pwrai

echo 1 > bash accept-powerai-license.sh

bash $HOME/workflows/BigGAN/gpu/run.sh
