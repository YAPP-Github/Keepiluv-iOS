init:
	curl https://mise.run | sh
	eval "$(~/.local/bin/mise activate zsh)"
	mise exec node@24 -- node -v
	mise use --global node@24 go@1
	mise install tuist
	mise use tuist@4.115.1
	
clean:
	tuist clean
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

generate:
	tuist install
	tuist generate

module:
	swift Scripts/GenerateModule.swift

