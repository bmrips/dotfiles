{
  programs.yamllint.settings = {
    extends = "default";
    rules = {
      document-end = "disable";
      document-start = "disable";
      empty-values = "enable";
      float-values.require-numeral-before-decimal = true;
    };
  };
}
