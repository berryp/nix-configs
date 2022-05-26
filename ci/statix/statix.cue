package statix

import (
	"dagger.io/dagger"

	"github.com/berryp/nix-configs/ci/nix"
)

#Statix: {
	source: dagger.#FS

	nix.#Run & {
		"source": source
		args: ["nixpkgs#statix", "check"]
	}
}
