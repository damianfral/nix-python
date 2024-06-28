# Nix flake with a pre-configured dev shell for python

1. Install nix:
  ```shell
  sh curl -L <https://nixos.org/nix/install> | sh -s -- --daemon
  ```
2. Enable `flakes` feature:
  ```shell
  mkdir -p ~/.config/nix
  echo "extra-experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
  ```
3. Clone this repo.
4. Launch the dev shell:
  ```shell
  nix develop
  ```
