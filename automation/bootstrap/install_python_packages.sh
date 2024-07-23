#!/bin/bash

set -xe

printf "\n Installing virtualenv \n\n"

python3 -m pip install --user virtualenv
export PYTHON_ENVIRONMENT_PATH=${OPENVINO_WORKBENCH_ROOT}/.venv

python3 -m virtualenv ${PYTHON_ENVIRONMENT_PATH}

source ${PYTHON_ENVIRONMENT_PATH}/bin/activate
pip install -U pip wheel setuptools

export ARCHFLAGS="-arch x86_64"


VERSIONS_FILE="automation/Jenkins/openvino_version.yml"
WHEELS_FOLDER="wheels"
if [[ ! -d ${WHEELS_FOLDER} ]]; then
  WHEELS_VERSION=$(grep 'openvino_wheels_version'  ${VERSIONS_FILE} | awk '{print $2}')
  mkdir ${WHEELS_FOLDER}
  pushd ${WHEELS_FOLDER}
    pip download "openvino==${WHEELS_VERSION}" -d . --no-deps
    pip download "openvino-dev==${WHEELS_VERSION}" -d . --no-deps
  popd
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(sys.version_info.major, sys.version_info.minor, sep="")')
OPENVINO_WHEEL=$(find ${WHEELS_FOLDER} -name "openvino-202*cp${PYTHON_VERSION}*macos*.whl" -print -quit)
OPENVINO_DEV_WHEEL=$(find ${WHEELS_FOLDER} -name "openvino_dev*.whl" -print -quit)

# python3 -m pip install ${OPENVINO_WHEEL}

# export OPENBLAS=$(/opt/homebrew/bin/brew --prefix openblas)
# export CFLAGS="-falign-functions=8 ${CFLAGS}"

# # Tell scipy-1.7.3.tar.gz installer where to find lapack
# export SYSTEM_VERSION_COMPAT=1
# export LDFLAGS="-L/opt/homebrew/opt/lapack/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/lapack/include"
# export PKG_CONFIG_PATH="opt/homebrew/opt/lapack/lib/pkgconfig"

# # See https://github.com/scipy/scipy/issues/12935
# export CFLAGS=-Wno-error=implicit-function-declaration

# # The location may vary - use find command to find this on your local /usr/local/opt
# export LAPACK=/opt/homebrew/opt/lapack/lib/liblapack.dylib
# export BLAS=/opt/homebrew/opt/openblas/lib/libopenblasp-r0.3.27.dylib

# python3 -m pip install "${OPENVINO_DEV_WHEEL}"
#  export OPENVINO_WORKBENCH_ROOT=$(pwd)

# fixed error interval.cpython-39-darwin.so'
# (mach-o file, but is an incompatible architecture (have 'x86_64', need 'arm64e' or 'arm64')
# arch -arm64 python -m pip install numpy==1.22 pandas==1.3.5 --no-cache
# arch -arm64 python -m pip install PyNaCl==1.4.0 --no-cache
python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/requirements/requirements.txt
python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/requirements/requirements_dev.txt
python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/requirements/requirements_jupyter.txt
python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/client/automation/requirements_dev.txt
python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/model_analyzer/requirements.txt
deactivate

printf "\n Installing dependencies of deep learning frameworks \n\n"

python3 -m virtualenv ${OPENVINO_WORKBENCH_ROOT}/.unified_venv
source ${OPENVINO_WORKBENCH_ROOT}/.unified_venv/bin/activate
python3 -m pip install -U pip wheel setuptools
python3 -m pip install ${OPENVINO_WHEEL}
python3 -m pip install "${OPENVINO_DEV_WHEEL}[caffe,mxnet,onnx,pytorch,tensorflow2]"
deactivate
