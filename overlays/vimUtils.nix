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

final: prev:

let
  buildVimPluginFromFlakeInput = inputs: name:
    prev.vimUtils.buildVimPluginFrom2Nix {
      pname = name;
      version = inputs.${name}.lastModifiedDate;
      src = inputs.${name};
    };

  buildNeovimLuaPackagePlugin = { pname, src, version ? "HEAD" }:
    final.vimUtils.buildVimPluginFrom2Nix {
      inherit pname version;
      src = prev.linkFarm pname [ { name = "lua"; path = src; } ];
    };
in

{
  vimUtils = prev.vimUtils // {
    inherit buildVimPluginFromFlakeInput buildNeovimLuaPackagePlugin;

    # Vim Plugin helpers
    buildVimPluginsFromFlakeInputs = inputs: names:
      prev.lib.genAttrs names (buildVimPluginFromFlakeInput inputs);

    buildNeovimLuaPackagePluginFromFlakeInput = inputs: name:
      buildNeovimLuaPackagePlugin {
        pname = name + "-nvim";
        version = inputs.${name}.lastModifiedDate;
        src = inputs.${name};
      };
  };
}
