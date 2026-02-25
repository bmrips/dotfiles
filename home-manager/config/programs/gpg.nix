{
  programs.gpg.settings = rec {
    default-new-key-algo = "ed25519/cert"; # certification-only master keys
    default-keyserver-url = "https://github.com/bmrips.gpg";
    sig-keyserver-url = default-keyserver-url;
    keyserver-options = "honor-keyserver-url";
    auto-key-retrieve = true; # Import keys from keyserver listed in signatures
    trust-model = "tofu+pgp";
    tofu-default-policy = "unknown";
  };
}
