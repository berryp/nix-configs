package deadnix

import (
	"dagger.io/dagger"

	"github.com/berryp/nix-configs/ci/nix"
)

#DeadNix: {
	source: dagger.#FS

	nix.#Run & {
		"source": source
		args: ["nixpkgs#deadnix", "."]
	}
}
