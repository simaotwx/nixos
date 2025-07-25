{
  config,
  mkConfigurableUsersOption,
  forEachUser,
  ...
}:
{
  options = {
    customization.programs.alacritty = {
      users = mkConfigurableUsersOption {
        description = "Which users to apply Simao's Alacritty config to. Defaults to all users.";
      };
    };
  };

  config =
    let
      cfg = config.customization.programs.alacritty;
    in
    {
      home-manager.users = forEachUser cfg.users {
        programs.alacritty.enable = true;
        programs.alacritty.settings = {
          "bell" = {
            "duration" = 0;
          };
          "colors" = {
            "bright" = {
              "black" = "#424242";
              "blue" = "#0099ff";
              "cyan" = "#00a5ab";
              "green" = "#11ab00";
              "magenta" = "#9854ff";
              "red" = "#ff4053";
              "white" = "#ffffff";
              "yellow" = "#bf8c00";
            };
            "cursor" = {
              "cursor" = "#9ca1aa";
              "text" = "#fafafa";
            };
            "draw_bold_text_with_bright_colors" = true;
            "normal" = {
              "black" = "#343434";
              "blue" = "#448AFF";
              "cyan" = "#00a5ab";
              "green" = "#00E676";
              "magenta" = "#9854ff";
              "red" = "#ff4053";
              "white" = "#ffffff";
              "yellow" = "#FDD835";
            };
            "primary" = {
              "background" = "#000000";
              "bright_foreground" = "#fefefe";
              "foreground" = "#fafafa";
            };
          };
          "cursor" = {
            "style" = {
              "shape" = "Block";
            };
          };
          "font" = {
            "normal" = {
              "family" = "Hasklug Nerd Font Mono";
            };
            "size" = 10.5;
          };
          "mouse" = {
            "bindings" = [
              {
                "action" = "None";
                "mouse" = "Middle";
              }
            ];
          };
          "scrolling" = {
            "history" = 100000;
          };
          "window" = {
            "decorations" = "none";
            "opacity" = 0.56;
            "padding" = {
              "x" = 8;
              "y" = 8;
            };
          };
        };
      };
    };
}
