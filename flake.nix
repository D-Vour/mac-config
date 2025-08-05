{
  description = "Godark – minimal macOS with nix-darwin + Homebrew";

  inputs = {
    nixpkgs.url  = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url   = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, darwin, ... }: {
    darwinConfigurations.macbook = darwin.lib.darwinSystem {
      system  = "aarch64-darwin";             # change to x86_64-darwin on Intel
      modules = [ ./configuration.nix ];
    };
  };
}

