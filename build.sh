#!/bin/bash

script_dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

set -e

windriver_linux_project_dir="${script_dir}/windriver_linux_project"
conf_dir="${script_dir}/conf"
wrlinux_dir="${windriver_linux_project_dir}/wrlinux-x"
build_conf_dir="${windriver_linux_project_dir}/build/conf"

mkdir -p "${windriver_linux_project_dir}"
if [ ! -e "${wrlinux_dir}" ]; then
    git clone -b WRLINUX_10_21_BASE https://github.com/WindRiver-Labs/wrlinux-x.git "${wrlinux_dir}"
fi

cd "${windriver_linux_project_dir}"
"${wrlinux_dir}/setup.sh" \
    --accept-eula yes \
    --distros poky wrlinux \
    --machines xilinx-zynqmp \
    --layers meta-networking meta-mingw meta-python meta-oe \
    --templates feature/lttng feature/gdb feature/sftp-server feature/wrvscode feature/lttng

source "${windriver_linux_project_dir}/oe-init-build-env"
ln -sfv "${conf_dir}/local.conf" "${build_conf_dir}"
bitbake wrlinux-image-small