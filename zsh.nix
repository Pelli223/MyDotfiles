{ pkgs, lib, ... }:

{
  # Configuración de FZF
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Configuración de Zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Configuración de Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 5000;
      save = 5000;
      path = "$HOME/.zsh_history";
      share = true;
      ignoreSpace = true;
      ignoreDups = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
    };

    autocd = true;

    shellAliases = {
      ls = "ls --color";
      get_idf = ". $IDF_PATH/export.sh";
    };

   initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Esto se ejecuta al principio del todo (Antiguo initExtraFirst)
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')

      (lib.mkAfter ''
        # Esto se ejecuta al final (Antiguo initExtra)
        if [[ -z "''${SSH_CONNECTION}" ]]; then
            export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
        fi

        export IDF_PATH="$HOME/GitRepos/esp-idf"
        export ANDROID_HOME="$HOME/.android/sdk"

        bindkey -e
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward
        bindkey '^[w' kill-region

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '')
    ];

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "command-not-found" "colored-man-pages" "extract" 
        "history" "sudo" "git" "pip" "docker-compose" "docker"
      ];
    };
  };
}
