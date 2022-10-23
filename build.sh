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
  -s USE_PTHREADS=1
)
LINKER_FLAGS=(
  --shared-memory
  -lpthread
)

# Wish I knew how to remove this.
EMCC_CACHE_DIR="$(dirname $(which emcc))/cache"
EMCC_CACHE_INCLUDE_DIR="$EMCC_CACHE_DIR/sysroot/include"
EMCC_CACHE_LIB_DIR="$EMCC_CACHE_DIR/sysroot/lib/wasm32-emscripten"

emcmake cmake \
  -G "Ninja Multi-Config" \
  -D ALLEGRO_SDL=ON \
  -D WANT_ALLOW_SSE=OFF \
  -D WANT_OPENAL=OFF \
  -D WANT_ALSA=OFF \
  -D SDL2_INCLUDE_DIR="$EMCC_CACHE_INCLUDE_DIR" \
  -D SDL2_LIBRARY="$EMCC_CACHE_LIB_DIR/libSDL2-mt.a" \
  -D CMAKE_C_FLAGS="${EMCC_FLAGS[*]}" \
  -D CMAKE_CXX_FLAGS="${EMCC_FLAGS[*]}" \
  -D CMAKE_EXE_LINKER_FLAGS="${LINKER_FLAGS[*]}" \
  ..

cmake --build . --config Debug -t app
