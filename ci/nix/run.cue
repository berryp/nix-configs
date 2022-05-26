package nix

import (
	"dagger.io/dagger"

	"universe.dagger.io/docker"
)

#Run: {
	source: dagger.#FS
	args: [...string]

	_image: docker.#Pull & {
		source: "nixos/nix"
	}

	docker.#Run & {
		input:   _image.output
		workdir: "/src"
		mounts: "source": {
			dest:     "/src"
			contents: source
		}
		command: {
			name:   "nix"
			"args": [
				"--experimental-features",
				"nix-command flakes",
				"run",
			] + args
		}

		// script: contents: "nix run \(pkg) \(args) > /output"
		// export: files: "/output": string
	}

	// output: _container.export.files["/output"]
}
