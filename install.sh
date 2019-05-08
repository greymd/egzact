#!/usr/bin/env bash
set -ue

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" && pwd)"
readonly BINMODE=755
readonly LIBMODE=644
readonly PREFIX="${1:-/usr/local}"
readonly PREFIX_BIN="${PREFIX}/bin"
readonly PREFIX_LIB="${PREFIX}/lib/egzact"

_install () {
  local _mode="$1" ;shift
  local _src="$1" ;shift
  local _dst="$1" ;shift
  echo "sed \"2,3s:\\.\\.:${PREFIX}:\" \"${_src}\" > \"${_dst}\""
  sed "2,3s:\\.\\.:${PREFIX}:" "${_src}" > "${_dst}"
  chmod "${_mode}" "${_dst}"
}

# Install (bin)
echo install -d "${PREFIX_BIN}"
install -d "${PREFIX_BIN}"
{
  cd "${THIS_DIR}/bin"
  for _file in *.egi ;do
    _install "${BINMODE}" "${_file}" "${PREFIX_BIN}/${_file/.egi}"
  done
}

# Install (lib)
echo install -d "${PREFIX_LIB}"
install -d "${PREFIX_LIB}"
{
  cd "${THIS_DIR}/lib/egzact"
  for _file in *.egi ;do
    _install "${LIBMODE}" "${_file}" "${PREFIX_LIB}/${_file}"
  done
}
