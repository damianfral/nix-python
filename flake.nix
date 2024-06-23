{
  description = "Example of nix devshell for python";

  # The inputs required to build the outputs.
  inputs = {
    # The official nix package set.
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    # pre-commit-hooks.nix is a nix library to derive the'script' that setups
    # git precommit hooks.
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs"; # Just an optional optimization.
    };
  };

  # Outputs is a function that takes the inputs to 
  outputs = { self, nixpkgs, pre-commit-hooks, ...} : 
    # Define some values used to create the shell.
    let
      system = "x86_64-linux";
      # Import nixpkgs to get the pkgs set.
      pkgs = import nixpkgs { system = system; }; 
      # The precommit hook script.
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          markdownlint.enable = true;
          # Formatter/linter for python.
          ruff.enable = true;
          # Remove unused imports and unused variables from Python code.
          autoflake.enable = true;
          # Upgrades syntax for newer versions of python.
          pyupgrade.enable = true;
          # Nix LSP server.
          nil.enable = true;
        };
      };
    in {
      # The devshell
      devShells.${system}.default = pkgs.mkShell {
        # Add git, tig (TUI for git) and helix, a vim-like editor to the devshell.
        # and pylsp, an LSP server (standar for language tooling) for python.
        packages = with pkgs; 
          [ git tig helix python311 python311Packages.python-lsp-server ];
        shellHook = ''
          # Setup the git precommit hooks.
          ${pre-commit-check.shellHook}
          echo "In Nix we trust"
        '';
      };
  };
}

