return {
  settings = {
    ['nil'] = {
      formatting = {
        command = { 'nixfmt' },
      },
      nix = {
        flake = {
          autoEvalInputs = true,
        },
      },
    },
  },
}
