export PYTHONUNBUFFERED=1
export PYTHONPATH=/opt/intel/openvino_2022/python/python3.6:/opt/intel/openvino_2022/python/python3:/opt/intel/openvino_2022/tools/model_optimizer:/opt/intel/openvino_2022/extras/opencv/python/:/opt/intel/openvino_2022/python/python3.6:/opt/intel/openvino_2022/python/python3:~/99.job/workbench/model_analyzer
export LD_LIBRARY_PATH=/opt/intel/openvino_2022/extras/opencv/lib:/opt/intel/openvino_2022/tools/compile_tool:/opt/intel/openvino_2022/runtime/3rdparty/tbb/lib:/opt/intel/openvino_2022/runtime/3rdparty/hddl/lib:/opt/intel/openvino_2022/runtime/lib/intel64
export INTEL_OPENVINO_DIR=/opt/intel/openvino_2022.3.2
export VENV_TF2_PYTHON=~/99.job/workbench/.unified_venv/bin/python
export SERVER_MODE=development
export PUBLIC_PORT=4200

~/99.job/workbench/.venv/bin/python \
 ~/99.job/workbench/.venv/bin/celery -A wb.main.tasks.task worker --loglevel=DEBUG
