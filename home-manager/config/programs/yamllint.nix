{
  programs.yamllint.settings = {
    extends = "default";
    rules = {
      document-start = "disable";
      empty-values = "enable";
      float-values.require-numeral-before-decimal = true;
      line-length = "disable";
      octal-values.forbid-implicit-octal = true;
    };
  };
}
