#!/bin/bash

set -e

if ! command -v emsdk &> /dev/null
then
  echo "emsdk could not be found."
  echo "https://emscripten.org/docs/getting_started/downloads.html"
  exit 1
fi

EMCC_VERSION=3.1.24
emsdk install $EMCC_VERSION
emsdk activate $EMCC_VERSION
source emsdk_env.sh

rm -rf build || true
mkdir build
cd build

EMCC_FLAGS=(
  -s USE_SDL=2
  -s USE_SDL_MIXER=2 # Works if commented out.
  -s USE_PTHREADS=1 # Works if commented out.
)
LINKER_FLAGS=(
  -s SDL2_MIXER_FORMATS="['mid','mod','ogg']"
)

emcmake cmake \
  -G "Ninja Multi-Config" \
  -D CMAKE_C_FLAGS="${EMCC_FLAGS[*]}" \
  -D CMAKE_CXX_FLAGS="${EMCC_FLAGS[*]}" \
  -D CMAKE_EXE_LINKER_FLAGS="${LINKER_FLAGS[*]}" \
  ..

cmake --build . --config RelWithDebInfo -t al_example
