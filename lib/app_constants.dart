class AppConstants {
  static final transitionDeviationMagnitude = 30.0;
  static final projectsDir = 'projects';
  static final gamesDir = 'games';
  static final aiRuntimeDir = 'airuntime';


  static final llmParallelInference = 4;

  //Qwen3.5 too much thinking :( maybe it can be fixed by prompting. will try...

  // static final llmMainUrl = 'https://huggingface.co/unsloth/Qwen3.5-4B-GGUF/resolve/main/Qwen3.5-4B-Q8_0.gguf';
  // static final llmMainFile = 'Qwen3.5-4B.Q8_0.gguf';
  // static final llmMainSha256 = '10cc391b403021dd11c614679d2fd92f611c3681d29e29651b717316965d61e1';

  // static final llmMainUrl = 'https://huggingface.co/unsloth/Qwen3.5-9B-GGUF/resolve/main/Qwen3.5-9B-UD-Q5_K_XL.gguf';
  // static final llmMainFile = 'Qwen3.5-9B-UD-Q5_K_XL.gguf';
  // static final llmMainSha256 = '96cf42ddb97f9572410a72b9ed6f2299b1e887ee08da4c2a6c01e897cfa9f673';

  static final llmMainUrl = 'https://huggingface.co/unsloth/Ornith-1.0-9B-GGUF/resolve/main/Ornith-1.0-9B-UD-Q4_K_XL.gguf';
  static final llmMainFile = 'Ornith-1.0-9B-UD-Q4_K_XL.gguf';
  static final llmMainSha256 = '3e865c778cf254af1b5d0fd3e9d4876718279df543c3ef801039c4ff7010edb0';

  static final llamaZipUrl = 'https://github.com/ggml-org/llama.cpp/releases/download/b10107/llama-b10107-bin-win-vulkan-x64.zip';
  static final llamaZipSha256 = 'c5b3a5ee8319b1eccbb748a54390aa806bbf7d1aceeea452e4c57921d113e53e';
  static final llamaDirName = 'llama-b10107-bin-win-vulkan-x64';

  static final sdZipUrl = 'https://github.com/leejet/stable-diffusion.cpp/releases/download/master-789-5114672/sd-master-5114672-bin-win-vulkan-x64.zip';
  static final sdZipSha256 = 'cb5fb173430147d83fa3439040be1e1d97906c2e8fb3a06cc8afb761ea98ba17';
  static final sdDirName = 'sd-master-5114672-bin-win-vulkan-x64';
}

class ZImageTurboConstants {
  static final vaeUrl = 'https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors';
  static final vaeFileName = 'ae.safetensors';
  static final vaeSha256 = 'afc8e28272cd15db3919bacdb6918ce9c1ed22e96cb12c4d5ed0fba823529e38';

  static final llmUrl = 'https://huggingface.co/unsloth/Qwen3-4B-GGUF/resolve/main/Qwen3-4B-UD-Q6_K_XL.gguf';
  static final llmFileName = 'Qwen3-4B-UD-Q6_K_XL.gguf';
  static final llmSha256 = 'ac0767b5e9c9f16efe57ce422253a33747970c166c3131c4d4d59d20511f07e1';

  // static final zImageTurboUrl = 'https://huggingface.co/leejet/Z-Image-Turbo-GGUF/resolve/main/z_image_turbo-Q4_K.gguf';
  // static final zImageTurboFileName = 'z_image_turbo-Q4_K.gguf';
  // static final zImageTurboSha256 = '14b375ab4f226bc5378f68f37e899ef3c2242b8541e61e2bc1aff40976086fbd';

  static final zImageTurboUrl = 'https://huggingface.co/leejet/Z-Image-Turbo-GGUF/resolve/main/z_image_turbo-Q8_0.gguf';
  static final zImageTurboFileName = 'z_image_turbo-Q8_0.gguf';
  static final zImageTurboSha256 = 'df1c5baa86d1398c979495a6072dbcee79444fdb884a2445582ba0769c44e9a1';
}