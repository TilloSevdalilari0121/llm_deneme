# Local Model Runner - Build Instructions

## AUTOMATED SETUP (RECOMMENDED)

### Just run this:

```cmd
setup_dependencies.bat
```

The script will:
1. Download SQLite3 DLL automatically
2. Clone and build llama.cpp with your choice of:
   - ROCm (AMD GPU acceleration)
   - CPU-only (slower but works everywhere)
3. Place DLLs in the project directory

**Then open `LocalModelRunner.dpr` in Delphi 12 and build!**

---

## Prerequisites

### Required Software
1. **Delphi 12 Athens** or later
2. **CMake** - https://cmake.org/download/
3. **Git** - https://git-scm.com/download/win
4. **Visual Studio 2022** with C++ tools
5. **ROCm** (optional, for AMD GPU) - https://rocm.docs.amd.com

### Optional for GPU Acceleration
- **ROCm for Windows** (AMD GPUs: RX 6000/7000, MI series)
  - Download: https://rocm.docs.amd.com
  - Only needed if you want GPU acceleration

---

## MANUAL SETUP (if automated script fails)

### Step 1: Get SQLite3 DLL

#### Option A: Run download script
```cmd
cd build_tools
download_sqlite3.bat
```

#### Option B: Manual download
1. Go to: https://www.sqlite.org/download.html
2. Download: "Precompiled Binaries for Windows" → **sqlite-dll-win-x64**
3. Extract `sqlite3.dll` to project root

### Step 2: Build llama.cpp

#### Option A: ROCm Build (AMD GPU)

**Requirements:**
- ROCm installed and configured
- AMD GPU: RX 6000/7000 series or MI series

```cmd
cd build_tools
build_llama_rocm.bat
```

This will:
- Clone llama.cpp repository
- Build with ROCm/HIP support
- Copy `llama.dll` to project root

#### Option B: CPU-Only Build

**No GPU required:**

```cmd
cd build_tools
build_llama_cpu.bat
```

This will:
- Clone llama.cpp repository
- Build CPU-only version (slower)
- Copy `llama.dll` to project root

**IMPORTANT:** If using CPU-only build, set **GPU Layers = 0** in application settings!

---

## Step 3: Verify DLLs

Check that these files exist in project root:
```
/llm_deneme/
  ├── sqlite3.dll   ✓
  ├── llama.dll     ✓
  └── ...
```

---

## Step 4: Build Application

### Using Delphi IDE:
1. Open `LocalModelRunner.dpr` in Delphi 12
2. **Project → Build LocalModelRunner**
3. Executable created in: `Win64\Release\LocalModelRunner.exe`

### Using Command Line:
```cmd
dcc64 LocalModelRunner.dpr
```

---

## Step 5: Run Application

1. Run `LocalModelRunner.exe`
2. First-run wizard will appear
3. DLLs and database are stored in **same folder as EXE** (portable!)

---

## Troubleshooting

### "Cannot find llama.dll"
- Run `setup_dependencies.bat` again
- OR manually build llama.cpp (see Step 2)
- Verify `llama.dll` exists in project root

### "Cannot find sqlite3.dll"
- Run `build_tools\download_sqlite3.bat`
- OR download manually from sqlite.org (64-bit version)

### ROCm Build Fails
- Verify ROCm is installed: `where hipcc` should return a path
- Check AMD GPU compatibility: RX 6000/7000 or MI series
- Try CPU-only build instead: `build_llama_cpu.bat`

### Application Crashes on Startup
- **Check DLL locations:** Must be in same folder as EXE
- **Try running as Administrator**
- Check Windows Event Viewer for detailed errors

### GPU Not Detected (ROCm)
- Verify ROCm drivers installed correctly
- Update AMD drivers to latest version
- Check GPU compatibility: https://rocm.docs.amd.com
- Set **GPU Layers = 0** if GPU not working (use CPU instead)

---

## Build Scripts Reference

| Script | Purpose |
|--------|---------|
| `setup_dependencies.bat` | **Main script** - Interactive setup |
| `build_tools/download_sqlite3.bat` | Download SQLite3 DLL |
| `build_tools/build_llama_rocm.bat` | Build llama.cpp with ROCm |
| `build_tools/build_llama_cpu.bat` | Build llama.cpp CPU-only |

---

## Model Compatibility

### Supported Formats:
- **GGUF** (.gguf) - Modern llama.cpp format ✓
- **GGML** (.bin) - Legacy format (some models) ✓

### Compatible With:
- Ollama models
- LM Studio models
- Jan models
- HuggingFace GGUF models

### Where to Find Models:
- https://huggingface.co (search for "GGUF")
- Ollama: `~/.ollama/models`
- LM Studio: `~/.cache/lm-studio/models`
- Jan: `~/jan/models`

---

## Performance Tips

### GPU Offload (ROCm Build)
- **7B models:** 32 layers
- **13B models:** 40 layers
- **30B+ models:** Adjust based on VRAM
- **CPU-only build:** Set to 0

### Context Size
- **Default:** 4096 tokens (good balance)
- **Large:** 8192 tokens (more memory)
- **Extreme:** 16384+ tokens (needs lots of RAM/VRAM)

### CPU Threads
- Set to your CPU core count
- Default: 8 threads

---

## File Locations (Portable!)

All files stored in **same directory as EXE:**

```
LocalModelRunner.exe  ← Your executable
llama.dll             ← Extracted from EXE resources
sqlite3.dll           ← Extracted from EXE resources
localmodel.db         ← Database (chat history, settings)
```

**Models stay in their original locations** (not copied)

---

## Additional Information

### License
This application uses:
- **llama.cpp** - MIT License
- **SQLite** - Public Domain
- **ROCm** - Various licenses (check AMD docs)

### Support
- llama.cpp issues: https://github.com/ggerganov/llama.cpp/issues
- ROCm issues: https://github.com/RadeonOpenCompute/ROCm/issues

---

## Quick Start Summary

```cmd
# 1. Run automated setup
setup_dependencies.bat

# 2. Choose ROCm (GPU) or CPU-only build

# 3. Open in Delphi 12 and build
# (or use: dcc64 LocalModelRunner.dpr)

# 4. Run LocalModelRunner.exe

# 5. Add models and start chatting!
```

**That's it! Everything is automated.**
