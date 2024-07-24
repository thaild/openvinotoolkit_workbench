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

python3 -m pip install ${OPENVINO_WHEEL}
python3 -m pip install "${OPENVINO_DEV_WHEEL}"

arch -arm64 python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/requirements/requirements.txt
arch -arm64 python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/requirements/requirements_dev.txt
arch -arm64 python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/requirements/requirements_jupyter.txt
arch -arm64 python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/client/automation/requirements_dev.txt
arch -arm64 python3 -m pip install -r ${OPENVINO_WORKBENCH_ROOT}/model_analyzer/requirements.txt
# fixed error incompatible architecture (have 'x86_64', need 'arm64e' or 'arm64')
arch -arm64 python3 -m pip install numpy==1.22 pandas==1.3.5 PyNaCl==1.5.0  --no-cache
ARCHFLAGS="-arch arm64" pip install psutil lxml datumaro==1.1.0  --no-cache
deactivate

printf "\n Installing dependencies of deep learning frameworks \n\n"

python3 -m virtualenv ${OPENVINO_WORKBENCH_ROOT}/.unified_venv
source ${OPENVINO_WORKBENCH_ROOT}/.unified_venv/bin/activate
python3 -m pip install -U pip wheel setuptools
python3 -m pip install ${OPENVINO_WHEEL}
python3 -m pip install "${OPENVINO_DEV_WHEEL}"
deactivate
