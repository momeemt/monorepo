zstyle ":completion:*:commands" rehash 1 # インストールしたコマンドを即認識させる

PATH=/bin:$PATH
PATH=/usr/bin:$PATH
PATH=/usr/sbin:$PATH
PATH=/usr/local/bin:$PATH
PATH=/opt/local/bin:$PATH

alias nims='nim --hints:off'

# zsh-completions,zsh-autosuggestions（cf. https://zenn.dev/sprout2000/articles/bd1fac2f3f83bc）
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  autoload -Uz compinit
  compinit
fi

if [ "$(uname -m)" = "arm64" ]; then
  PATH=$HOME/.cargo/bin:$PATH
  PATH=$HOME/.nodebrew/current/bin:$PATH
  PATH=$HOME/.rbenv/shims:$PATH
  PATH=$HOME/.yarn/bin:$PATH
  PATH=$HOME/.poetry/bin:$PATH
  PATH=/opt/homebrew/bin:$PATH
else
  PATH=$HOME/.nimble/bin:$PATH # x86_64環境ではNimをchoosenimで管理する
fi

eval $(opam env)

export PATH
export SATYROGRAPHOS_EXPERIMENTAL=1 # SATySFiパッケージマネージャの環境変数
