{ config, pkgs, lib, ... }:

{
  home.packages = lib.attrValues ({
    inherit (pkgs)
      awscn
      keychain
      obsidian-export
      go_1_19
      cue
      kubectx
      kubectl
      k9s
      kubernetes-helm-wrapped
      ;
  });

  programs.fish.shellAliases = {
    vzone2_prod_provisioner = "awscn 10.111.171.55";
    vzoneTW_prod_provisioner = "awscn 10.232.64.188";
    vzone_dev_provisioner = "awscn 10.238.23.169";
    vzone_prod_provisioner = "awscn 10.236.109.107";
  };

  programs.ssh.enable = true;

  programs.ssh.matchBlocks = {
    "dev" = {
      hostname = "aws-gw-dev.coupang.net";
    };

    "prod" = {
      hostname = "aws-gw.coupang.net";
    };

    "dev-boltx" = {
      hostname = "boltx-jumpbox-dev.coupang.net";
      extraOptions = {
        ProxyCommand = "ssh - q - W %h:%p dev";
      };
    };

    "prod-boltx" = {
      hostname = "boltx-jumpbox-prod.coupang.net";
      extraOptions = {
        ProxyCommand = "ssh - q - W %h:%p prod";
      };
    };

    "SG_PROVISIONER" = {
      hostname = " 10.111.171.55";
      extraOptions = {
        ProxyCommand = "ssh - q - W %h:%p prod";
      };
    };

    "SG_TEST" = {
      hostname = " 10.111.171.55";
      extraOptions = {
        ProxyJump = " daroche@prod";
      };
    };

    "TW_PROVISIONER" = {
      hostname = "10.232.11.85";
      extraOptions = {
        ProxyCommand = "ssh -q -W %h:%p prod";
      };
    };

    "TW_MONGO" = {
      hostname = "10.232.69.149";
      extraOptions = {
        ProxyCommand = "ssh -q -W %h:%p prod";
      };
    };

    "KR_MONGO" = {
      hostname = "10.219.104.36";
      extraOptions = {
        ProxyCommand = "ssh -q -W %h:%p prod";
      };
    };

    "KR_PROVISIONER" = {
      hostname = "10.238.23.169";
      extraOptions = {
        ProxyCommand = "ssh -q -W %h:%p prod";
      };
    };

    "CIRCLECI" = {
      hostname = "10.224.174.163";
      extraOptions = {
        ProxyCommand = "ssh -q -W %h:%p prod";
      };
    };

    "EMRTEST" = {
      hostname = "10.213.207.153";
      extraOptions = {
        ProxyCommand = "ssh -q -W %h:%p dev";
      };
    };

    "OEBOLTX" = {
      hostname = "10.219.65.22";
      extraOptions = {
        ProxyCommand = "ssh -q -W %h:%p prod";
      };
    };

    "prod_prov" = {
      hostname = "10.236.109.107";
      extraOptions = {
        ProxyCommand = "ssh -q -W %h:%p prod";
      };
    };
  };
}

