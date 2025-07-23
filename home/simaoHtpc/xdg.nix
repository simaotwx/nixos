{ config, ... }:
{
  xdg = {
    enable = true;
    mimeApps.enable = true;
    mimeApps.associations = {
      added = { };
    };
    mimeApps.defaultApplications = config.xdg.mimeApps.associations.added;
    portal.enable = true;
  };
}
