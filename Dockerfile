FROM runpod/worker-comfyui:5.8.5-sdxl

RUN apt-get update && apt-get install -y ffmpeg && rm -rf /var/lib/apt/lists/*

RUN cd /comfyui/custom_nodes \
    && git clone https://github.com/kijai/ComfyUI-WanVideoWrapper \
    && uv pip install -r ComfyUI-WanVideoWrapper/requirements.txt \
    && git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite \
    && uv pip install -r ComfyUI-VideoHelperSuite/requirements.txt \
    && git clone https://github.com/city96/ComfyUI-GGUF \
    && uv pip install -r ComfyUI-GGUF/requirements.txt

# Patch worker handler to also capture VHS video output (stored under 'gifs' key in ComfyUI history)
RUN set +e; \
    TARGET=$(find /src /handler.py /app -name "rp_handler.py" -o -name "handler.py" 2>/dev/null | head -1); \
    if [ -z "$TARGET" ]; then TARGET=$(grep -rl "node_output" / --include="*.py" 2>/dev/null | grep -v "/__pycache__/" | head -1); fi; \
    if [ -n "$TARGET" ]; then \
      echo "Patching $TARGET"; \
      sed -i "s/'images' in node_output/'images' in node_output or 'gifs' in node_output/g" "$TARGET"; \
      sed -i 's/"images" in node_output/"images" in node_output or "gifs" in node_output/g' "$TARGET"; \
      sed -i "s/node_output\['images'\]/node_output.get('images', node_output.get('gifs', []))/g" "$TARGET"; \
      sed -i 's/node_output\["images"\]/node_output.get("images", node_output.get("gifs", []))/g' "$TARGET"; \
      echo "Patch done - verifying:"; \
      grep -n "gifs\|images" "$TARGET" | head -20; \
    else echo "Handler not found - skipping patch"; fi; \
    set -e

# Map WAN model folders from network volume
RUN echo "  checkpoints: models/diffusion_models/" >> /comfyui/extra_model_paths.yaml \
    && echo "  diffusion_models: models/diffusion_models/" >> /comfyui/extra_model_paths.yaml \
    && echo "  unet: models/diffusion_models/" >> /comfyui/extra_model_paths.yaml \
    && echo "  text_encoders: models/text_encoders/" >> /comfyui/extra_model_paths.yaml \
    && echo "  clip: models/text_encoders/" >> /comfyui/extra_model_paths.yaml \
    && echo "  loras: loras/" >> /comfyui/extra_model_paths.yaml
