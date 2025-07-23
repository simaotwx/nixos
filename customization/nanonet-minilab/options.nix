{ lib, ... }:
{
  options = {
    customization.nanonet-minilab = {
      acmeEmail = lib.mkOption {
        type = lib.types.str;
      };
      cfApiToken = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
}
