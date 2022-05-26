package main

import (
	"dagger.io/dagger"

	"github.com/berryp/nix-configs/ci/deadnix"
	"github.com/berryp/nix-configs/ci/statix"
)

dagger.#Plan & {
	client: filesystem: ".": read: exclude: [
		"result/",
		".direnv",
	]
	actions: {
		lint: {
			"deadnix": deadnix.#DeadNix & {
				source: client.filesystem.".".read.contents
			}
			"statix": statix.#Statix & {
				source: client.filesystem.".".read.contents
			}
		}
	}
}
