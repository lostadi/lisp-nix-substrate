{ pkgs, ... }: {
  home.stateVersion = "24.11";
  home.packages = with pkgs; [ git curl ];
  programs.zsh.enable = false;
}
