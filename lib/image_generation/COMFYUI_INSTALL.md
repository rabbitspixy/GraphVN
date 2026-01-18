git clone https://github.com/Comfy-Org/ComfyUI.git
cd .\ComfyUI\
python -m venv .venv
.\.venv\Scripts\activate

CUDA version:
nvcc --version

pip install torch torchvision --index-url https://download.pytorch.org/whl/cu128
pip install -r requirements.txt

curl https://huggingface.co/drbaph/Z-Image-Turbo-FP8/resolve/main/z_image_turbo_fp8_e4m3fn.safetensors -o .\models\diffusion_models\z_image_turbo_fp8_e4m3fn.safetensors
curl https://huggingface.co/jiangchengchengNLP/qwen3-4b-fp8-scaled/resolve/main/qwen3_4b_fp8_scaled.safetensors -o .\models\text_encoders\qwen3_4b_fp8_scaled.safetensors
curl https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors -o .\models\vae\ae.safetensors