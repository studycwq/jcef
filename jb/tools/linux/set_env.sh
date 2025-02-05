#!/bin/bash
# Copyright 2000-2022 JetBrains s.r.o. Use of this source code is governed by the Apache 2.0 license that can be found in the LICENSE file.

script_dir=$(cd -- "$(dirname -- "$0")" &>/dev/null && pwd)

JCEF_ROOT_DIR="$(cd "$script_dir/../../.." && pwd)"
export JCEF_ROOT_DIR
echo "JCEF_ROOT_DIR is $JCEF_ROOT_DIR"
export JB_TOOLS_DIR="$JCEF_ROOT_DIR"/jb/tools
export JB_TOOLS_OS_DIR="$JB_TOOLS_DIR"/linux
export MODULAR_SDK_DIR="$JCEF_ROOT_DIR"/out/linux64/modular-sdk
export OS=linux
case "${TARGET_ARCH:=x86_64}" in
arm64) export DEPS_ARCH="aarch64" ;;
x86_64) export DEPS_ARCH="amd64" ;;
*) echo "Incorrect TARGET_ARCH: $TARGET_ARCH" && exit 1 ;;
esac

if [ -z "${JDK_11:-}" ]; then
  if [ -d "$JCEF_ROOT_DIR"/jdk11 ]; then
    # set on the TeamCity agent
    JDK_11="$JCEF_ROOT_DIR"/jdk11
  else
    echo "error: JDK_11 is not set"
    exit 1
  fi
fi
export JAVA_HOME="$JDK_11"
echo "JAVA_HOME is $JAVA_HOME"

# shellcheck disable=SC2230
if ! which ant &>/dev/null; then
  if [ -z "${ANT_HOME:-}" ]; then
    echo "error: ANT_HOME is not set nor ant present in PATH"
    exit 1
  fi
  export PATH="$ANT_HOME/bin:$PATH"
  echo "ANT_HOME is $ANT_HOME"
fi
