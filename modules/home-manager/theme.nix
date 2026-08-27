# Shared design tokens for the niri desktop config.
# Imported by both niri.nix (window borders/focus-ring/corner radius)
# and niri-utils.nix (waybar/fuzzel/mako).
{
  colors = {
    base = "1c1c1cd9";
    surface = "2f2f2fd9";
    border = "ffffff12";
    text = "e0e0e0";
    textBright = "ffffff";
    textMuted = "7a7a7a";
    urgent = "b3554f";
    accent = "212B9C"; # selection/active-state color, distinct from urgent
    accentBright = "424ED7"; # same hue as accent, lifted lightness — used where accent needs to read against varied/dark backdrops (e.g. focus-ring)
    baseRgba = "rgba(28,28,28,0.85)";
    surfaceRgba = "rgba(47,47,47,0.85)";
    borderRgba = "rgba(255,255,255,0.07)";
  };

  # Corner radius scale, kept as bare numbers so each consumer can
  # format it the way it needs: CSS wants "<n>px", niri's KDL-ish
  # settings want a bare number.
  radius = {
    sm = 10;
    md = 14;
    lg = 18;
  };
}
