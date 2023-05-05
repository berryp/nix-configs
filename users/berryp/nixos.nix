{ pkgs, ... }:
{
  users.users.berryp = {
    isNormalUser = true;
    home = "/home/berryp";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.fish;
    # nix run nixpkgs#mkpasswd -- -m sha-512
    hashedPassword = "$6$7zveKNm/L1MtvADy$b8aNHYUAbHtMzMEJcvMsAvqIoF3L3/TS.v09ZktMCE6NvmPmglEym56W6pE/HwmWAyZbyLyX6ea94x933iny3";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2o35XUfVCZPxvsxowdfoY5+g4/P8Kz/ufkb81wMmuT"
    ];
  };

}
