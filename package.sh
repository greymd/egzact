#!/bin/bash
set -ue
readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" && pwd)"
{
  cd "${THIS_DIR}"
  mkdir -p "${THIS_DIR}/pkg/"{bin,lib}
  (
  cd "${THIS_DIR}/bin"
  for f in *.egi; do
    sed '/load-file/s|../lib|/usr/lib|' < "$f" > "${THIS_DIR}/pkg/bin/${f%.egi}"
  done
  )
  cp -rf "${THIS_DIR}"/lib/egzact "${THIS_DIR}"/pkg/lib/
  tar zcvf egzact.tar.gz -C "${THIS_DIR}/pkg" bin lib .tar2package.yml \
    && docker run -i greymd/tar2rpm < egzact.tar.gz > "${THIS_DIR}"/pkg/egzact.rpm \
    && docker run -i greymd/tar2deb < egzact.tar.gz > "${THIS_DIR}"/pkg/egzact.deb
  rm -f egzact.tar.gz
}
