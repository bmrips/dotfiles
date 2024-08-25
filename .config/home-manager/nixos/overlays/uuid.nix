final: prev:

{
  lib = prev.lib // {
    uuid = id: "/dev/disk/by-uuid/" + id;
    partuuid = id: "/dev/disk/by-partuuid/" + id;
  };
}
