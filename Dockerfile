FROM runpod/worker-comfyui:5.8.5-sdxl

RUN cd /comfyui/custom_nodes \
    && git clone https://github.com/kijai/ComfyUI-WanVideoWrapper \
    && uv pip install -r ComfyUI-WanVideoWrapper/requirements.txt \
    && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite \
    && uv pip install -r ComfyUI-VideoHelperSuite/requirements.txt \
    && git clone https://github.com/city96/ComfyUI-GGUF \
    && uv pip install -r ComfyUI-GGUF/requirements.txt
