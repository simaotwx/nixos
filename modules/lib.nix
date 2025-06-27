{ lib, config, ... }: {
  _module.args = {
    mkConfigurableUsersOption = { description ? "" }: lib.mkOption {
      type = with lib.types; listOf str;
      default = config.configurableUsers;
      inherit description;
    };
    forEachHomeUser = users: block: lib.genAttrs users (_: block);
    forEachHomeUser' = users: block: lib.genAttrs users (username: block username);
  };
}