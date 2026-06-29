FROM runpod/worker-comfyui:5.8.5-sdxl

RUN cd /comfyui/custom_nodes \
    && git clone https://github.com/kijai/ComfyUI-WanVideoWrapper \
    && uv pip install -r ComfyUI-WanVideoWrapper/requirements.txt \
    && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite \
    && uv pip install -r ComfyUI-VideoHelperSuite/requirements.txt \
    && git clone https://github.com/city96/ComfyUI-GGUF \
    && uv pip install -r ComfyUI-GGUF/requirements.txt

# Map WAN model folders from network volume
RUN echo "  checkpoints: models/diffusion_models/" >> /comfyui/extra_model_paths.yaml \
    && echo "  diffusion_models: models/diffusion_models/" >> /comfyui/extra_model_paths.yaml \
    && echo "  unet: models/diffusion_models/" >> /comfyui/extra_model_paths.yaml \
    && echo "  text_encoders: models/text_encoders/" >> /comfyui/extra_model_paths.yaml \
    && echo "  clip: models/text_encoders/" >> /comfyui/extra_model_paths.yaml \
    && echo "  loras: loras/" >> /comfyui/extra_model_paths.yaml
