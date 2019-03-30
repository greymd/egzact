#!/bin/bash
set -ue
readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" && pwd)"
{
  cd "${THIS_DIR}"
  rm -f "${THIS_DIR}"/egzact.tar.gz
  mkdir -p "${THIS_DIR}/pkg/"{bin,lib}
  (
  cd "${THIS_DIR}/bin"
  for f in *.egi; do
    sed '/load-file/s|../lib|/usr/lib|' < "$f" > "${THIS_DIR}/pkg/bin/${f%.egi}"
  done
  )
  cp -rf "${THIS_DIR}"/lib/egzact "${THIS_DIR}"/pkg/lib/
  _version="$(awk '/^version/{print $NF}' "${THIS_DIR}"/pkg/.tar2package.yml)"
  tar zcvf egzact.tar.gz -C "${THIS_DIR}/pkg" bin lib .tar2package.yml \
    && docker run -i greymd/tar2rpm < egzact.tar.gz > "${THIS_DIR}"/pkg/egzact-"${_version}".rpm \
    && docker run -i greymd/tar2deb < egzact.tar.gz > "${THIS_DIR}"/pkg/egzact-"${_version}".deb
  rm -f "${THIS_DIR}"/egzact.tar.gz
  rm -rf "${THIS_DIR}"/pkg/{bin,lib}
}
