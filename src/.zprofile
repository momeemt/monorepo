if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH=/opt/homebrew/bin:$PATH
else
  eval "$(/usr/local/bin/brew shellenv)"
fi
