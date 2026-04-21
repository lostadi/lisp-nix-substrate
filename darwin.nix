{ ... }: {
  system.stateVersion = 6;

  # Explicitly bind the Nix daemon's capabilities to the declarative state
  nix.settings.experimental-features = "nix-command flaks";

  # Explicitly map the pure Nix user to the impure macOS user coordinate.
  # This provides the geometric anchor home-manager requires to resolve the tree.
  users.users.ustad = {
    name = "ustad";
    home = "/Users/ustad";
  };
}
