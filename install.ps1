# Wasserman 80s Horror LoRA — one-line installer for ComfyUI (Windows PowerShell)
#
#   irm https://raw.githubusercontent.com/wassermanproductions/wasserman-80s-horror-lora/main/install.ps1 | iex
#
# To pick the folder or also download the MiniMax H3 base files (~42 GB):
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/wassermanproductions/wasserman-80s-horror-lora/main/install.ps1))) -ComfyUI "C:\ComfyUI" -WithModels
param([string]$ComfyUI = $env:COMFYUI_PATH, [switch]$WithModels)
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$Repo = "wassermanproductions/wasserman-80s-horror-lora"
$LoraUrl = "https://github.com/$Repo/releases/latest/download/80s_horror_wk.safetensors"
$Raw = "https://raw.githubusercontent.com/$Repo/main"
$HF = "https://huggingface.co/Comfy-Org/MiniMax-H3/resolve/main"

function Say($m) { Write-Host "> $m" -ForegroundColor Magenta }
function Warn($m) { Write-Host "! $m" -ForegroundColor Yellow }

if (-not $ComfyUI) {
  $candidates = @("$HOME\ComfyUI", "$HOME\Documents\ComfyUI", "C:\ComfyUI", "C:\ComfyUI_windows_portable\ComfyUI",
                  "$HOME\Desktop\ComfyUI_windows_portable\ComfyUI", "$HOME\Downloads\ComfyUI_windows_portable\ComfyUI", (Get-Location).Path)
  foreach ($c in $candidates) { if (Test-Path "$c\models") { $ComfyUI = $c; break } }
}
if (-not $ComfyUI -or -not (Test-Path "$ComfyUI\models")) {
  throw "Couldn't find ComfyUI. Re-run with -ComfyUI 'C:\path\to\ComfyUI' (the folder that contains 'models')."
}
$ComfyUI = (Resolve-Path $ComfyUI).Path
Say "ComfyUI: $ComfyUI"

function Fetch($url, $dest) {
  New-Item -ItemType Directory -Force -Path (Split-Path $dest) | Out-Null
  Invoke-WebRequest -Uri $url -OutFile "$dest.part" -UseBasicParsing
  Move-Item -Force "$dest.part" $dest
}

Say "Downloading the 80s Horror LoRA..."
Fetch $LoraUrl "$ComfyUI\models\loras\80s_horror_wk.safetensors"

foreach ($w in @("80s_horror_t2v.json", "80s_horror_i2v.json")) {
  try { Fetch "$Raw/workflows/$w" "$ComfyUI\user\default\workflows\$w" } catch { Warn "Couldn't fetch $w (download it from the repo's workflows folder)" }
}
Say "Workflows installed: 80s_horror_t2v, 80s_horror_i2v"

$Models = @(
  "diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors",
  "text_encoders/qwen3vl_32b_minimax_h3_nvfp4_awq.safetensors",
  "vae/minimax_h3_video_vae_fp16.safetensors",
  "vae/minimax_h3_audio_vae_fp32.safetensors"
)
$missing = @()
foreach ($m in $Models) {
  $dir = Join-Path "$ComfyUI\models" (Split-Path $m)
  $name = Split-Path $m -Leaf
  if (-not (Get-ChildItem -Path $dir -Recurse -Filter $name -ErrorAction SilentlyContinue | Select-Object -First 1)) { $missing += $m }
}
if ($missing.Count -gt 0) {
  if ($WithModels) {
    foreach ($m in $missing) { Say "Downloading $m (large file, be patient)..."; Fetch "$HF/$m" (Join-Path "$ComfyUI\models" $m) }
  } else {
    Warn "These MiniMax H3 files are missing (re-run with -WithModels to download them, ~42 GB):"
    foreach ($m in $missing) { Write-Host "    models/$m  <-  $HF/$m" }
  }
}

Write-Host ""
Say "Done. Restart ComfyUI (or press R to refresh models), open the Workflows sidebar,"
Say "load 80s_horror_t2v, and start your prompt with:  80s_horror_wk, shot on VHS."
Write-Host "  MiniMax H3 is licensed under the MiniMax H3 Community License Agreement, Copyright (c) 2026 MiniMax. All Rights Reserved."
