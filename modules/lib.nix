{ lib, config, ... }:
{
  _module.args = {
    mkConfigurableUsersOptionOld =
      {
        description ? "",
      }:
      lib.mkOption {
        type = with lib.types; listOf str;
        default = config.configurableUsers;
        inherit description;
      };
    forEachUser = users: block: lib.genAttrs users (_: block);
    forEachUser' = users: block: lib.genAttrs users (username: block username);
  };
}
