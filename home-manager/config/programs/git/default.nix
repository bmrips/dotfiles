{ config, lib, ... }:

let
  gitWrapper = /* bash */ ''
    case $1 in
      cd-root) local repo_root="$(command git rev-parse --show-toplevel)" && cd "$repo_root" ;;
      *) command git "$@" ;;
    esac
  '';

in
lib.mkMerge [
  {
    programs.git = {
      signing.key = null;
      signing.signByDefault = true;

      settings = {
        advice.detachedHead = false;
        advice.statusHints = false;
        core.whitespace = "tabwidth=4";
        commit.template = "${./commit_message_template}";
        diff.algorithm = "histogram";
        diff.colorMoved = "default";
        diff.renames = "copy";
        diff.sops.textconv = "sops decrypt";
        fetch.all = true;
        fetch.prune = true;
        fetch.writeCommitGraph = true;
        init.defaultBranch = "main";
        init.templateDir = "${./templates}";
        log.date = "human";
        merge.ff = "only";
        merge.tool = "nvim";
        pager.difftool = true;
        pull.rebase = true;
        push.gpgSign = "if-asked";
        push.useForceIfIncludes = true;
        rebase.missingCommitsCheck = "error";
        rebase.updateRefs = true;
        rerere.enabled = true;
        stash.showStat = true;
        status.showStash = true;
        user.name = "Benedikt Rips";
        user.email = "benedikt.rips@gmail.com";

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

        mergetool.nvim = {
          cmd = /* bash */ ''nvim -d "$LOCAL" "$MERGED" "$REMOTE"'';
          trustExitCode = false;
        };
      };

      settings.alias = {
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
        lv = "log --format='%C(auto)%h%d %s - %C(blue)%an%C(reset), %C(magenta)%ad%C(reset)'";
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

      attributes =
        let
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
        in
        [ "* text=auto" ] ++ lib.mapAttrsToList (ext: driver: "*.${ext} diff=${driver}") diffDrivers;

      ignores = [
        "/.direnv/"
        "/result"
        "Session*.vim"
        "taskell.md"
      ];
    };
  }

  (lib.mkIf config.programs.git.enable {
    home.shellAliases.g = "git";
    programs.delta.enable = true;
    programs.zsh.siteFunctions.git = gitWrapper;
    programs.bash.initExtra = /* bash */ ''
      function git() {
          ${gitWrapper}
      }
    '';
  })
]
