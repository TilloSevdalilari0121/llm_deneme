# Local Model Runner - Build Instructions

## Prerequisites

### Required Software
1. **Delphi 12 Athens** or later
2. **ROCm** (for AMD GPU support) - Download from: https://rocm.docs.amd.com
3. **llama.cpp** compiled with ROCm support
4. **SQLite3** DLL

## Step 1: Get Required DLLs

### A. Build llama.cpp with ROCm Support

```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp

# Build with ROCm (AMD GPU)
cmake -B build -DLLAMA_HIPBLAS=ON
cmake --build build --config Release

# The DLL will be in: build/bin/Release/llama.dll
```

### B. Get SQLite3 DLL

Download from: https://www.sqlite.org/download.html
- Get the "Precompiled Binaries for Windows" -> sqlite-dll-win64-x64
- Extract `sqlite3.dll`

### C. Place DLLs in Project Directory

Copy both DLLs to the project root:
```
/llm_deneme/
  ├── llama.dll        (ROCm version from llama.cpp)
  ├── sqlite3.dll      (from SQLite website)
  └── ...
```

## Step 2: Compile Resource File

The resource file embeds the DLLs into the executable.

### Option A: Using Delphi IDE
1. Open `LocalModelRunner.dpr` in Delphi 12
2. The IDE will automatically compile `EmbeddedResources.rc` if the DLLs are present

### Option B: Manual Compilation
```cmd
cd /llm_deneme
brcc32 EmbeddedResources.rc
```

This creates `EmbeddedResources.res` which is referenced in the main program.

## Step 3: Build the Application

### Using Delphi IDE:
1. Open `LocalModelRunner.dpr` in Delphi 12
2. Select **Project → Build LocalModelRunner**
3. The executable will be created in the output directory (usually `Win64\Release\`)

### Using Command Line:
```cmd
dcc64 LocalModelRunner.dpr
```

## Step 4: Verify Build

After building successfully:
1. Run `LocalModelRunner.exe`
2. The first-run wizard should appear
3. DLLs are automatically extracted to: `%LOCALAPPDATA%\LocalModelRunner\`

## Troubleshooting

### "Cannot find llama.dll"
- Ensure `llama.dll` is in the project directory before building
- Verify it was compiled with ROCm support (check file size - should be ~50MB+)

### "Cannot find sqlite3.dll"
- Download the correct version (64-bit) from sqlite.org
- Place it in the project root directory

### "Resource compiler error"
- Run `brcc32 EmbeddedResources.rc` manually
- Check that both DLLs exist in the project directory

### ROCm GPU Not Working
- Verify ROCm is installed: Check for `rocm` in your system PATH
- AMD GPU must be compatible: RX 6000/7000 series or MI series
- Update AMD drivers to the latest version

### Application Crashes on Startup
- Check Windows Event Viewer for detailed error
- Ensure all DLLs were extracted correctly to `%LOCALAPPDATA%\LocalModelRunner\`
- Try running as Administrator

## Running the Application

1. **First Run**: The wizard will guide you through initial setup
2. **Add Models**: Use Model Manager to add GGUF model files
3. **Configure GPU**: Set GPU layers in Settings (default: 32 layers)
4. **Start Chatting**: Load a model and start a conversation!

## Model Compatibility

Supported formats:
- **GGUF** (.gguf files) - Modern llama.cpp format
- **GGML** (.bin files) - Legacy format (some models)

Compatible with models from:
- Ollama
- LM Studio
- Jan
- HuggingFace (GGUF models)

## Performance Tips

1. **GPU Offload**: Higher layers = faster, but needs more VRAM
   - 7B models: 32 layers
   - 13B models: 40 layers
   - 30B+ models: Adjust based on VRAM

2. **Context Size**: Larger = more memory but better context
   - Default: 4096 tokens
   - Large: 8192 tokens
   - Extreme: 16384+ tokens

3. **Threads**: Set to your CPU core count for best CPU performance

## Additional Notes

- The executable is **fully standalone** - all DLLs are embedded
- No external dependencies at runtime (except ROCm drivers for GPU)
- Database and settings stored in: `%LOCALAPPDATA%\LocalModelRunner\`
- Models are NOT copied - they stay in their original locations

## Support

For issues related to:
- **llama.cpp**: https://github.com/ggerganov/llama.cpp/issues
- **ROCm**: https://github.com/RadeonOpenCompute/ROCm/issues
- **SQLite**: https://www.sqlite.org/forum/forumpost/forum

## License

This application uses:
- llama.cpp (MIT License)
- SQLite (Public Domain)
- ROCm (Various licenses - check AMD documentation)
