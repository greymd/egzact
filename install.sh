#!/usr/bin/env bash
set -ue

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" && pwd)"
readonly BINMODE=755
readonly LIBMODE=644
readonly PREFIX="${1:-/usr/local}"
readonly PREFIX_BIN="${PREFIX}/bin"
readonly PREFIX_LIB="${PREFIX}/lib/egzact"

# Install (bin)
echo install -d "${PREFIX_BIN}"
install -d "${PREFIX_BIN}"
{
  cd "${THIS_DIR}/bin"
  for _file in * ;do
    echo install -m "${BINMODE}" "${THIS_DIR}/bin/${_file}" "${PREFIX_BIN}/${_file/.egi}"
    install -m "${BINMODE}" "${THIS_DIR}/bin/${_file}" "${PREFIX_BIN}/${_file/.egi}"
  done
}

# Install (lib)
echo install -d "${PREFIX_LIB}"
install -d "${PREFIX_LIB}"
{
  cd "${THIS_DIR}/lib/egzact"
  for _file in * ;do
    echo install -m "${LIBMODE}" "${THIS_DIR}/lib/egzact/${_file}" "${PREFIX_LIB}/${_file}"
    install -m "${LIBMODE}" "${THIS_DIR}/lib/egzact/${_file}" "${PREFIX_LIB}/${_file}"
  done
}
