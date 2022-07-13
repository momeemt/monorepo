PATH=/bin:$PATH
PATH=/usr/bin:$PATH
PATH=/usr/sbin:$PATH
PATH=/usr/local/bin:$PATH
PATH=/opt/local/bin:$PATH

if [ "$(uname -m)" = "arm64" ]; then
  PATH=$PATH
else
  # x86_64ではchoosenimでNimを管理する
  PATH=$HOME/.nimble/bin:$PATH
fi

export PATH
