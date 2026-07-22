{ config, pkgs, ... }:
{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    settings = {
      corner-radius = 8;
      shadow = true;
      shadow-opacity = 0.6;
      fading = true;
      fade-in-step = 0.03;
      fade-out-step = 0.03;
    };
  };
}
