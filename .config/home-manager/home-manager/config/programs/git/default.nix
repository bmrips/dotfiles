{ config, lib, ... }:

with lib;

let
  gitWrapper = ''
    case $1 in
      cd-root) local repo_root="$(command git rev-parse --show-toplevel)" && cd "$repo_root" ;;
      *) command git "$@" ;;
    esac
  '';

in mkIf config.programs.git.enable {

  home.shellAliases.g = "git";

  programs.bash.initExtra = ''
    function git() {
      ${gitWrapper}
    }
  '';

  programs.zsh.siteFunctions.git = gitWrapper;

  programs.git = {
    userName = "Benedikt Rips";
    userEmail = "benedikt.rips@gmail.com";
    signing.key = null;
    signing.signByDefault = true;

    delta = {
      enable = true;
      options = let
        fg = "normal";
        hunk_color = "magenta";
      in {
        file-modified-label = "𝚫";
        hunk-header-decoration-style = "${hunk_color} ul";
        hunk-header-line-number-style = "${hunk_color}";
        hunk-header-style = "${hunk_color} line-number";
        minus-style = "${fg} auto";
        minus-emph-style = "${fg} auto";
        navigate = "true";
        plus-style = "${fg} auto";
        plus-emph-style = "${fg} auto";
        syntax-theme = "base16";
        width = 80;
        zero-style = "${fg}";
      };
    };

    extraConfig = {
      advice.detachedHead = false;
      advice.statusHints = false;
      core.whitespace = "tabwidth=4";
      commit.template = "${./commit_message_template}";
      credential.helper = "osxkeychain";
      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      diff.renames = "copy";
      fetch.all = true;
      fetch.prune = true;
      fetch.writeCommitGraph = true;
      init.defaultBranch = "main";
      init.templateDir = "${./templates}";
      log.date = "human";
      merge.ff = "only";
      merge.tool = "nvim";
      pull.rebase = true;
      push.gpgSign = "if-asked";
      push.useForceIfIncludes = true;
      rebase.missingCommitsCheck = "error";
      rebase.updateRefs = true;
      rerere.enabled = true;
      stash.showStat = true;
      status.showStash = true;

      # use HTTPS instead of plain Git for Github
      url."https://github.com/".insteadOf = "git://github.com/";

      color = {
        diff = {
          frag = "magenta bold";
          meta = "blue";
          whitespace = "red reverse";
        };
        status = {
          nobranch = "red bold";
          unmerged = "blue";
        };
      };

      diff.tool = "difftastic";
      difftool.difftastic.cmd = ''difft "$LOCAL" "$REMOTE"'';
      difftool.prompt = false;
      pager.difftool = true;

      mergetool.nvim = {
        cmd = ''nvim -d "$LOCAL" "$MERGED" "$REMOTE"'';
        trustExitCode = false;
      };
    };

    aliases = {
      a = "add";
      b = "branch";
      c = "commit";
      ca = "commit --amend";
      cf = "commit --fixup";
      co = "checkout";
      cp = "cherry-pick";
      cu = "commit --amend --no-edit";
      d = "diff";
      ds = "diff --staged";
      dt = "difftool";
      l = "log";
      lg = "log --oneline --graph";
      lo = "log --oneline";
      ls = "ls-files";
      lv =
        "log --format='%C(auto)%h%d %s - %C(blue)%an%C(reset), %C(magenta)%ad%C(reset)'";
      mc = "diff --name-only --diff-filter=U";
      mt = "mergetool";
      pushf = "push --force-with-lease";
      r = "reset";
      rb = "rebase";
      rbf = "rebase --autostash --autosquash";
      s = "status --short";
      sl = "shortlog";
      sw = "switch";
    };

    attributes = let
      diffDrivers = {
        bib = "bibtex";
        "c++" = "cpp";
        cpp = "cpp";
        css = "css";
        html = "html";
        java = "java";
        md = "markdown";
        php = "php";
        pl = "perl";
        py = "python";
        rb = "ruby";
        rs = "rust";
        tex = "tex";
        xhtml = "html";
      };
    in [ "* text=auto" ]
    ++ mapAttrsToList (ext: driver: "*.${ext} diff=${driver}") diffDrivers;

    ignores = [ ".direnv/" "Session*.vim" "taskell.md" ] ++ [
      ".DS_Store" # MacOS directory preferences
    ] ++ [
      ".directory" # KDE directory preferences
    ];
  };

}
