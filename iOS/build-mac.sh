# Copyright (c) 2024 Project Nova LLC

set -e

TARGETS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGETS+=("$2")
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--target ios|macos]"
      exit 1
      ;;
    esac
done

if [[ ${#TARGETS[@]} -eq 0 ]]; then
  TARGETS=("ios" "macos")
fi

rm -rf build
mkdir -p build

for TARGET in "${TARGETS[@]}"; do
  if [[ "$TARGET" == "ios" ]]; then
    SDK_PATH=$(xcrun --sdk iphoneos --show-sdk-path)
    ARCH="arm64"
    OUT="build/libSinum_ios.dylib"
  elif [[ "$TARGET" == "macos" ]]; then
    SDK_PATH=$(xcrun --sdk macosx --show-sdk-path)
    ARCH="x86_64"
    OUT="build/libSinum_macos.dylib"
  else
    echo "Invalid target: $TARGET"
    echo "Valid targets: ios, macos"
    exit 1
  fi

  echo "Building Sinum for $TARGET $ARCH..."

  xcrun clang++ \
    -isysroot "$SDK_PATH" \
    -arch "$ARCH" \
    -dynamiclib Main.m \
    -o "$OUT" \
    -framework Foundation

  echo "Build completed!"

done
