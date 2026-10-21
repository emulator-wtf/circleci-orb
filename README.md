# emulator.wtf CircleCI Orb

[![CircleCI Build Status](https://circleci.com/gh/emulator-wtf/circleci-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/emulator-wtf/circleci-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/emulator-wtf/emulator-wtf.svg)](https://circleci.com/developer/orbs/orb/emulator-wtf/emulator-wtf) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/emulator-wtf/circleci-orb/main/LICENSE)

[Emulator.wtf](https://emulator.wtf) is an Android cloud emulator laser-focused
on performance to deliver quick feedback to your PRs.

Use this orb to run your Android instrumentation tests with emulator.wtf on
CircleCI. See the
[Orb Registry page](https://circleci.com/developer/orbs/orb/emulator-wtf/emulator-wtf)
for the latest version.

## `emulator-wtf/run_tests`

Run your instrumentation tests with emulator.wtf, optionally with multiple
shards.

### Quick usage

A basic example that builds the app and test APKs, runs the tests and stores
the results in CircleCI. Set the `EW_API_TOKEN` environment variable in your
project settings or use the `emulator-wtf/configure_credentials` command to avoid storing an API token in CircleCI.

```yaml
version: 2.1

orbs:
  emulator-wtf: emulator-wtf/emulator-wtf@0.3.0

jobs:
  run-tests:
    docker:
      - image: cimg/android:2024.01.1
    steps:
      - checkout
      - run:
          name: Build app
          command: ./gradlew assembleDebug assembleAndroidTest
      - emulator-wtf/run_tests:
          app: app/build/outputs/apk/debug/app-debug.apk
          test: app/build/outputs/apk/androidTest/app-debug-androidTest.apk
          outputs_dir: build/test-results
      - store_test_results:
          path: build/test-results

workflows:
  test:
    jobs:
      - run-tests
```

### Parameters

See the full list of parameters on the
[Orb Registry page](https://circleci.com/developer/orbs/orb/emulator-wtf/emulator-wtf#commands-run_tests).

### Common examples

#### Run tests with multiple device profiles

By default emulator.wtf runs tests on a Pixel7-like emulator with API 30. Use the `devices` parameter to run on other versions:

```yaml
      - emulator-wtf/run_tests:
          app: app/build/outputs/apk/debug/app-debug.apk
          test: app/build/outputs/apk/androidTest/app-debug-androidTest.apk
          devices: |
            model=NexusLowRes,version=29
            model=Pixel2,version=37
```

#### Run tests with shards

Use sharding for faster test execution.

```yaml
      - emulator-wtf/run_tests:
          app: app/build/outputs/apk/debug/app-debug.apk
          test: app/build/outputs/apk/androidTest/app-debug-androidTest.apk
          shard-target-runtime: 3m
          outputs_dir: build/test-results
```

## `emulator-wtf/configure_credentials`

Use `configure_credentials` to authenticate test runs using temporary [OIDC tokens](https://circleci.com/docs/openid-connect-tokens/) instead of a long living API token.

### Quick usage

1. Create a new configuration in the [emulator.wtf](https://emulator.wtf) OIDC configurations page and copy the OIDC configuration ID to the CircleCI project environment variables. E.g you can use variable name `OIDC_CONFIGURATION_ID`.
2. Run `emulator-wtf/configure_credentials` with the OIDC configuration ID
   from step 1.

   ```yaml
   - emulator-wtf/configure_credentials:
       oidc_configuration_id: ${OIDC_CONFIGURATION_ID}
   ```

3. Run `emulator-wtf/run_tests` later in the same job. No API token is needed.

Read more about [OIDC in emulator.wtf](https://docs.emulator.wtf/oidc).

## Contributing

We welcome [issues](https://github.com/emulator-wtf/circleci-orb/issues) and
[pull requests](https://github.com/emulator-wtf/circleci-orb/pulls).

