fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios info

```sh
[bundle exec] fastlane ios info
```

Show project info

### ios setup_signing

```sh
[bundle exec] fastlane ios setup_signing
```



### ios load_signing

```sh
[bundle exec] fastlane ios load_signing
```



### ios archive_for_ci

```sh
[bundle exec] fastlane ios archive_for_ci
```



### ios archive_for_upload

```sh
[bundle exec] fastlane ios archive_for_upload
```



### ios generate

```sh
[bundle exec] fastlane ios generate
```

Generate Tuist project

### ios build_modules

```sh
[bundle exec] fastlane ios build_modules
```

Build all modules (without main app)

### ios build_app_simulator

```sh
[bundle exec] fastlane ios build_app_simulator
```



### ios lint

```sh
[bundle exec] fastlane ios lint
```

Run SwiftLint

### ios ci_pr

```sh
[bundle exec] fastlane ios ci_pr
```

CI for pull requests: build modules + test modules

### ios ci_main

```sh
[bundle exec] fastlane ios ci_main
```



### ios release_tag

```sh
[bundle exec] fastlane ios release_tag
```



----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
