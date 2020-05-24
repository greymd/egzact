#!/bin/bash
set -ue
readonly THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-${(%):-%N}}")" && pwd)"
trap 'rm -f "${THIS_DIR}"/egzact.tar.gz' EXIT
{
  cd "${THIS_DIR}"
  rm -f "${THIS_DIR}"/egzact.tar.gz
  docker run -v "${PWD}":/work -i phusion/baseimage:latest /bin/bash -c '
    _pholder="@@@@@REPLACE_HERE@@@@@"
    /work/install.sh /usr/$_pholder
    shopt -s globstar
    sed -i "s|/$_pholder||g" /usr/$_pholder/{bin/*,lib/**/*.egi}
    cp /work/pkg/.tar2package.yml /usr/$_pholder/
    tar zcvf /work/egzact.tar.gz -C "/usr/$_pholder" bin lib .tar2package.yml
  '
  _version="$(awk "/^version/{print \$NF}" "${THIS_DIR}"/pkg/.tar2package.yml)"
  docker run -i greymd/tar2rpm:1.0.1 < egzact.tar.gz > "${THIS_DIR}"/pkg/egzact-"${_version}".rpm
  docker run -i greymd/tar2deb:1.0.1 < egzact.tar.gz > "${THIS_DIR}"/pkg/egzact-"${_version}".deb
}
