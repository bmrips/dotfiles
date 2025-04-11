{
  programs.yamllint.settings = {
    extends = "default";
    rules = {
      document-start = "disable";
      empty-values = "enable";
      float-values.require-numeral-before-decimal = true;
      octal-values.forbid-implicit-octal = true;
    };
  };
}
