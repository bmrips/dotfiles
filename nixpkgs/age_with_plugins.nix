_final: prev:

{
  age = prev.age.withPlugins (plugins: [ plugins.age-plugin-tpm ]);
}
