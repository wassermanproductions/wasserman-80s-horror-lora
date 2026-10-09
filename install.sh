#!/usr/bin/env bash
# Wasserman 80s Horror LoRA — one-line installer for ComfyUI (macOS / Linux)
#
#   curl -fsSL https://raw.githubusercontent.com/wassermanproductions/wasserman-80s-horror-lora/main/install.sh | bash
#
# Options (pass after `bash -s --`):
#   /path/to/ComfyUI   install into this ComfyUI folder (otherwise auto-detected)
#   --with-models      also download the MiniMax H3 base model files (~42 GB) if missing
#
#   curl -fsSL .../install.sh | bash -s -- ~/ComfyUI --with-models
set -euo pipefail

REPO="wassermanproductions/wasserman-80s-horror-lora"
LORA_URL="https://github.com/$REPO/releases/latest/download/80s_horror_wk.safetensors"
RAW="https://raw.githubusercontent.com/$REPO/main"
HF="https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main"

COMFY="${COMFYUI_PATH:-}"
WITH_MODELS=0
for arg in "$@"; do
  case "$arg" in
    --with-models) WITH_MODELS=1 ;;
    -h|--help) sed -n '2,11p' "$0" 2>/dev/null || true; exit 0 ;;
    *) COMFY="$arg" ;;
  esac
done

say()  { printf '\033[1;35m▸\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m✗\033[0m %s\n' "$*" >&2; exit 1; }

if [ -z "$COMFY" ]; then
  for c in "$HOME/ComfyUI" "$HOME/Documents/ComfyUI" "$HOME/comfy/ComfyUI" "$HOME/AI/ComfyUI" \
           "$HOME/Desktop/ComfyUI" "/opt/ComfyUI" "$PWD/ComfyUI" "$PWD"; do
    if [ -d "$c/models" ] && { [ -f "$c/main.py" ] || [ -d "$c/custom_nodes" ] || [ -d "$c/user" ]; }; then COMFY="$c"; break; fi
  done
fi
[ -n "$COMFY" ] && [ -d "$COMFY/models" ] || die "Couldn't find ComfyUI. Re-run with its path:  curl -fsSL $RAW/install.sh | bash -s -- /path/to/ComfyUI"
COMFY="$(cd "$COMFY" && pwd)"
say "ComfyUI: $COMFY"

fetch() {  # url dest
  mkdir -p "$(dirname "$2")"
  curl -fL --progress-bar --retry 3 -C - -o "$2.part" "$1" && mv "$2.part" "$2"
}

# 1. The LoRA
LORA="$COMFY/models/loras/80s_horror_wk.safetensors"
say "Downloading the 80s Horror LoRA…"
fetch "$LORA_URL" "$LORA"

# 2. Ready-to-run workflows (show up in ComfyUI's Workflows sidebar)
WF="$COMFY/user/default/workflows"
for w in 80s_horror_t2v.json 80s_horror_i2v.json; do
  fetch "$RAW/workflows/$w" "$WF/$w" >/dev/null 2>&1 || warn "Couldn't fetch $w (download it from the repo's workflows folder)"
done
say "Workflows installed: 80s_horror_t2v, 80s_horror_i2v"

# 3. MiniMax H3 base files
MODELS=(
  "diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors"
  "text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors"
  "vae/minimax_h3_video_vae_fp16.safetensors"
  "vae/minimax_h3_audio_vae_fp32.safetensors"
)
missing=()
for m in "${MODELS[@]}"; do
  [ -n "$(find "$COMFY/models/$(dirname "$m")" -name "$(basename "$m")" -print -quit 2>/dev/null)" ] || missing+=("$m")
done
if [ ${#missing[@]} -gt 0 ]; then
  if [ "$WITH_MODELS" = 1 ]; then
    for m in "${missing[@]}"; do say "Downloading $m…"; fetch "$HF/$m" "$COMFY/models/$m"; done
  else
    warn "These MiniMax H3 files are missing (re-run with --with-models to download them, ~42 GB):"
    for m in "${missing[@]}"; do echo "    models/$m   ←  $HF/$m"; done
  fi
fi

echo
say "Done. Restart ComfyUI (or press R to refresh models), open the Workflows sidebar,"
say "load 80s_horror_t2v, and start your prompt with:  80s_horror_wk, shot on VHS."
echo "  MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright © 2026 MiniMax. All Rights Reserved."
