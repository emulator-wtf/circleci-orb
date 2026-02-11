#!/bin/bash
EW_BIN="$HOME/.cache/emulator-wtf/ew-cli"

args=("$EW_BIN")

if [[ -n "$APP_APK" ]]; then
    args+=("--app" "$APP_APK")
fi

if [[ -n "$TEST_APK" ]]; then
    args+=("--test" "$TEST_APK")
fi

if [[ -n "$OUTPUTS_DIR" ]]; then
    args+=("--outputs-dir" "$OUTPUTS_DIR")
fi

if [[ -n "$DEVICES" ]]; then
    # shellcheck disable=SC2086
    for device in $(echo $DEVICES | xargs); do
        args+=("--device" "$device")
    done
fi

if [[ "$USE_ORCHESTRATOR" == "1" ]]; then
    args+=("--use-orchestrator")
fi

if [[ "$CLEAR_PACKAGE_DATA" == "1" ]]; then
    args+=("--clear-package-data")
fi

if [[ "$WITH_COVERAGE" == "1" ]]; then
    args+=("--with-coverage")
fi

if [[ -n "$ADDITIONAL_APKS" ]]; then
    while IFS= read -r line ; do
        apk=$(echo "$line" | xargs)
        args+=("--additional-apks" "$apk")
    done <<< "$ADDITIONAL_APKS"
fi

if [[ -n "$ENVIRONMENT_VARIABLES" ]]; then
    args+=("--environment-variables" "$ENVIRONMENT_VARIABLES")
fi

if [[ -n "$NUM_UNIFORM_SHARDS" ]]; then
    if [[ "$NUM_UNIFORM_SHARDS" != "0" ]]; then
        args+=("--num-uniform-shards" "$NUM_UNIFORM_SHARDS")
    fi
fi

if [[ -n "$SHARD_TARGET_RUNTIME" ]]; then
    args+=("--shard-target-runtime" "$SHARD_TARGET_RUNTIME")
fi

if [[ -n "$TESTCASE_DURATION_HINT" ]]; then
    args+=("--testcase-duration-hint" "$TESTCASE_DURATION_HINT")
fi

if [[ -n "$NUM_BALANCED_SHARDS" ]]; then
    if [[ "$NUM_BALANCED_SHARDS" != "0" ]]; then
        args+=("--num-balanced-shards" "$NUM_BALANCED_SHARDS")
    fi
fi

if [[ -n "$NUM_SHARDS" ]]; then
    if [[ "$NUM_SHARDS" != "0" ]]; then
        args+=("--num-shards" "$NUM_SHARDS")
    fi
fi

if [[ -n "$DIRECTORIES_TO_PULL" ]]; then
    while IFS= read -r line ; do
        dirtopull=$(echo "$line" | xargs)
        args+=("--directories-to-pull" "$dirtopull")
    done <<< "$DIRECTORIES_TO_PULL"
fi

if [[ "$TEST_CACHE" == "0" ]]; then
    args+=("--no-test-cache")
fi

echo "${args[@]}"

# execute
"${args[@]}"