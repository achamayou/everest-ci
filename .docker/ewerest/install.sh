#!/bin/bash

# NOTE: we assume that everything has been installed in the Docker image

if [[ -z "$EVEREST_ENV_DEST_FILE" ]] ; then
  EVEREST_ENV_DEST_FILE="$HOME/.bash_profile"
fi

# Install OCaml for Windows, from:
# https://fdopen.github.io/opam-repository-mingw/

OCAMLV=4.02.3
export OPAMYES=1

mkdir ocaml
pushd ocaml
curl --location --output opam64.tar.xz 'https://github.com/fdopen/opam-repository-mingw/releases/download/0.0.0.1/opam64.tar.xz'
tar xf opam64.tar.xz
bash opam64/install.sh
opam init mingw 'https://github.com/fdopen/opam-repository-mingw.git' --comp "$OCAMLV"+mingw64c --switch "$OCAMLV"+mingw64c
eval `opam config env`
opam config env > "$EVEREST_ENV_DEST_FILE"
popd

# Install Everest

git clone --branch taramana_vs2017 'https://github.com/project-everest/everest.git' everest
pushd everest
./everest --yes check # will stop after installing Cygwin packages
source "$EVEREST_ENV_DEST_FILE"
./everest --yes check # hopefully resumes at installing OCaml packages?
# source "$EVEREST_ENV_DEST_FILE"
# export PLATFORM=X64 # until Vale's SConscript/SConstruct are fixed
# ./everest make
popd
