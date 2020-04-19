#!/usr/bin/env bash
set -ue

readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" && pwd)"
readonly BINMODE=755
readonly LIBMODE=644
readonly SRCMODE=644
readonly PREFIX="${1:-/usr/local}"
readonly PREFIX_BIN="${PREFIX}/bin"
readonly PREFIX_LIB="${PREFIX}/lib/egzact"
readonly PREFIX_SRC="${PREFIX}/lib/egzact/src"

_installbin () {
  local _mode="$1" ;shift
  local _src="$1" ;shift
  local _dst="$1" ;shift
  cat <<TEMPLATE > "${_dst}"
#!/bin/bash
exec egison ${_src} -- \$@
TEMPLATE
  chmod "${_mode}" "${_dst}"
}

_install () {
  local _mode="$1" ;shift
  local _src="$1" ;shift
  local _dst="$1" ;shift
  echo "sed \"5,7s:\\.\\.:${PREFIX}:\" \"${_src}\" > \"${_dst}\""
  sed "5,7s:\\.\\.:${PREFIX}:" "${_src}" > "${_dst}"
  chmod "${_mode}" "${_dst}"
}

# Install (bin/src)
echo install -d "${PREFIX_SRC}"
install -d "${PREFIX_SRC}"
echo install -d "${PREFIX_BIN}"
install -d "${PREFIX_BIN}"
{
  cd "${THIS_DIR}/bin"
  for _file in *.egi ;do
    _src="${PREFIX_SRC}/${_file}"
    _install "${SRCMODE}" "${_file}" "${_src}"
    _installbin "${BINMODE}" "${_src}" "${PREFIX_BIN}/${_file/.egi}"
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
