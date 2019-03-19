.PHONY: ar build

# (build)
# 	_arguments \
# 		'--configuration: :(Release Debug)' \
# 		'--platform: :(all macOS iOS watchOS tvOS)' \
# 		'--toolchain: :(com.apple.dt.toolchain.Swift_2_3 com.apple.dt.toolchain.XcodeDefault)' \
# 		'--derived-data: :_directories' \
# 		'--no-skip-current' \
# 		'--color: :(auto always never)' \
# 		'--verbose' \
# 		'--project-directory: :_directories' \
# 		'--cache-builds' \

correct:
	swiftlint autocorrect

update:
	carthage update --platform ios

ar: build
	carthage archive YumeKit

build:
	carthage build \
		--platform iOS \
		--no-skip-current

.PHONY = podLint
podLint:
	pod lib lint YumeKit.podspec --allow-warnings

