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
	// client: filesystem: "./deadnix.txt": write: contents: actions.lint."deadnix".output
	// client: filesystem: "./statix.txt": write: contents:  actions.lint."statix".output

	// client: commands: "out": {
	//  name: "mkdir"
	//  args: [ "-p", "./out"]
	// }

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
