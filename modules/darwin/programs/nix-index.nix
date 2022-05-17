# MIT License

# Copyright (c) 2020 Malo Bourgon

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Additional configuration for `nix-index` to enable `command-not-found` functionality with Fish.
{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.programs.nix-index.enable {
    programs.fish.interactiveShellInit = ''
      function __fish_command_not_found_handler --on-event="fish_command_not_found"
        ${if config.programs.fish.useBabelfish then ''
        command_not_found_handle $argv
        '' else ''
        ${pkgs.bashInteractive}/bin/bash -c \
          "source ${config.progams.nix-index.package}/etc/profile.d/command-not-found.sh; command_not_found_handle $argv"
        ''}
      end
    '';
    };
}
