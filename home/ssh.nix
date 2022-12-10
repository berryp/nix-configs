{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    # useAgent = true;

    matchBlocks = {
      "*" = {
        serverAliveInterval = 50;
        extraOptions = {
          IdentityAgent = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
          TCPKeepAlive = "yes";
        };
      };
      "github.com" = {
        hostname = "ssh.github.com";
        port = 443;
        user = "git";
      };
    };
  };
}
