# Universal LLM Studio

**A Professional, Feature-Rich Desktop Application for Working with Local LLM APIs**

Universal LLM Studio is a comprehensive Delphi 12 application that provides a unified interface for interacting with multiple local LLM providers including Ollama, LM Studio, and Jan. Built with professional UI design, extensive features, and powerful developer tools.

---

## 🌟 Features

### A. Advanced Chat Client
- **Multi-Model Support**: Switch between Ollama, LM Studio, and Jan APIs seamlessly
- **Model Comparison**: Run 2-3 models simultaneously to compare responses
- **Conversation Management**: Create, save, and manage multiple conversation threads
- **Streaming Responses**: Real-time token-by-token response streaming
- **Parameter Control**: Adjust temperature, top-p, and max tokens on-the-fly
- **Rich Text Display**: Syntax-highlighted, themed chat interface

### B. Model Management
- **Model Download**: Pull models directly from Ollama (llama2, mistral, etc.)
- **Model Deletion**: Remove unused models to save disk space
- **Model Information**: View model details, sizes, and metadata
- **Benchmark Testing**: Run performance benchmarks with various test types:
  - Quick tests (short prompts)
  - Medium tests (paragraphs)
  - Long tests (essays)
  - Code generation tests
  - Math/reasoning tests
- **Performance Metrics**: Track tokens/second, latency, and first-token time

### C. Developer Tools
- **API Playground**: Test raw API endpoints with custom JSON requests
- **Request Builder**: Build and test API calls interactively
- **Code Execution**: Run Python, JavaScript, PowerShell, and Batch scripts
- **Sandbox Mode**: Execute code safely with limited permissions
- **Prompt Library**: Create, save, and manage reusable prompt templates
- **Variable Support**: Use placeholders in prompts for dynamic content

### D. Advanced Features
- **RAG System**: Upload documents (TXT, PDF) for retrieval-augmented generation
  - Automatic text chunking
  - Embedding generation
  - Semantic search
  - Context injection
- **Workspace Integration**: Browse and edit files in designated folders
  - Permission-based access control
  - File tree navigation
  - Built-in text editor
- **Performance Monitoring**: Track all API requests with detailed metrics
  - Token usage statistics
  - Response time tracking
  - Provider/model filtering
  - CSV export for analysis
- **Theme System**: 15 professional themes (10 dark, 5 light)
  - VS Code Dark/Light
  - GitHub Dark/Light
  - Dracula, Monokai Pro, Nord
  - Gruvbox, Solarized, Tokyo Night
  - Material, One Dark Pro
- **Export/Import**: Backup and restore conversations as JSON
- **Plugin System**: Extensible architecture for custom plugins (DLL-based)

---

## 📋 System Requirements

- **Operating System**: Windows 10/11 (64-bit recommended)
- **Memory**: 4 GB RAM minimum (8 GB+ recommended for large models)
- **Disk Space**: 500 MB for application + space for models
- **Local LLM Provider**: At least one of the following:
  - [Ollama](https://ollama.ai) (recommended)
  - [LM Studio](https://lmstudio.ai)
  - [Jan](https://jan.ai)

### Optional Dependencies
- **Python**: For code execution features (Python 3.7+)
- **Node.js**: For JavaScript code execution (Node 14+)
- **PowerShell**: Pre-installed on Windows

---

## 🚀 Installation

### Step 1: Install a Local LLM Provider

Choose one or more providers:

#### Ollama (Recommended)
```bash
# Download from https://ollama.ai
# Install and run
ollama pull llama2
ollama serve
```

#### LM Studio
1. Download from https://lmstudio.ai
2. Install and launch
3. Download a model from the UI
4. Start local server (default: http://localhost:1234)

#### Jan
1. Download from https://jan.ai
2. Install and configure
3. Start local server (default: http://localhost:1337)

### Step 2: Build Universal LLM Studio

1. **Clone or Download** this repository
2. **Open** `UniversalLLMStudio.dpr` in Delphi 12
3. **Build** the project (Shift+F9)
4. The executable will be created in the same directory

### Step 3: First Run

1. Launch `UniversalLLMStudio.exe`
2. The application will create `llmstudio.db` in the same directory
3. Default API endpoints will be configured automatically:
   - Ollama: `http://localhost:11434`
   - LM Studio: `http://localhost:1234`
   - Jan: `http://localhost:1337`

---

## 🎯 Quick Start Guide

### 1. Basic Chat

1. **Select Provider**: Use the dropdown in the top panel to choose Ollama, LM Studio, or Jan
2. **Select Model**: Choose a model from the available models
3. **Start Chatting**:
   - Click "Chat" from the sidebar
   - Type your message in the input box
   - Click "Send" or press Ctrl+Enter
4. **Conversation Management**:
   - Click "New Chat" to start a fresh conversation
   - Previous conversations are saved automatically
   - Click any conversation in the sidebar to load it

### 2. Compare Models

1. Click "Model Compare" from the sidebar
2. Select 2-3 models from the dropdowns
3. Enter a prompt to test
4. Click "Compare" to run all models simultaneously
5. View side-by-side responses with performance metrics

### 3. Download Models (Ollama)

1. Ensure Ollama is running
2. Select "Ollama" as your provider
3. Click "Model Manager" from the sidebar
4. Enter a model name (e.g., `llama2:7b`, `mistral`, `codellama`)
5. Click "Pull Model"
6. Wait for download to complete

### 4. Use RAG (Document Search)

1. Click "RAG Manager" from the sidebar
2. Click "Upload Document"
3. Select a TXT or PDF file
4. Wait for processing (chunking + embedding)
5. Enter a search query
6. Click "Search Documents"
7. View relevant excerpts from your documents

### 5. Create Prompt Templates

1. Click "Prompt Library" from the sidebar
2. Click "New"
3. Fill in:
   - **Name**: Template name
   - **Category**: General, Coding, Writing, etc.
   - **Description**: What this prompt does
   - **Template**: Your prompt with {variables}
   - **Variables**: List variable names (one per line)
4. Click "Save"
5. To use: Select template, click "Apply to Chat"

---

## ⚙️ Configuration

### API Endpoints

Go to **Settings** → **API Endpoints** tab:

- **Ollama URL**: Default `http://localhost:11434`
- **LM Studio URL**: Default `http://localhost:1234`
- **Jan URL**: Default `http://localhost:1337`

Change these if your providers run on different ports or remote machines.

### Default Parameters

Go to **Settings** → **General** tab:

- **Temperature**: 0.0 to 2.0 (default: 0.7)
  - Lower = more deterministic
  - Higher = more creative/random
- **Top-P**: 0.0 to 1.0 (default: 0.9)
  - Controls diversity of word selection
- **Max Tokens**: Maximum response length (default: 2048)
- **Auto-save**: Automatically save conversations
- **Streaming**: Enable real-time token streaming

### Workspace

Go to **Settings** → **Advanced** tab:

- **Workspace Path**: Set your default working directory
- Files in this folder will be accessible via the Workspace Manager
- Permissions are checked before read/write/delete operations

### Themes

Go to **Theme Manager**:

1. Browse 15 available themes
2. Preview theme colors
3. Click "Apply Theme" to change
4. Restart may be required for full effect

---

## 📚 Module Reference

### 1. Chat
Main conversation interface with streaming support, parameter controls, and conversation history.

**Key Features:**
- Real-time streaming responses
- Adjustable temperature, top-p, max tokens
- Auto-save conversations
- Syntax-highlighted display

### 2. Model Compare
Compare responses from 2-3 models simultaneously.

**Use Cases:**
- Model evaluation
- Quality comparison
- Performance benchmarking
- A/B testing prompts

### 3. Model Manager
Download, view, and delete models (Ollama only).

**Supported Operations:**
- Pull models from Ollama library
- View installed models
- Delete unused models
- View model metadata

### 4. Benchmark
Run standardized performance tests.

**Test Types:**
- Quick (short prompts)
- Medium (paragraphs)
- Long (essays)
- Code generation
- Math/reasoning

**Metrics:**
- Total response time
- Tokens per second
- First token latency
- Total tokens generated

### 5. RAG Manager
Upload documents and perform semantic search.

**Workflow:**
1. Upload TXT/PDF files
2. Documents are chunked (500 chars)
3. Embeddings are generated
4. Search with natural language queries
5. Get relevant excerpts

### 6. Prompt Library
Create and manage reusable prompt templates.

**Features:**
- Categorization (General, Coding, Writing, etc.)
- Variable substitution with `{variable}` syntax
- One-click application to chat
- Import/export templates

### 7. API Playground
Test raw API endpoints with custom requests.

**Capabilities:**
- GET, POST, DELETE methods
- JSON request builder
- Response viewer
- Pretty-print JSON
- Pre-built templates

### 8. Code Execution
Run code in multiple languages with sandbox support.

**Supported Languages:**
- Python
- JavaScript (Node.js)
- PowerShell
- Batch/CMD

**Safety:**
- Sandbox mode (recommended)
- Confirmation dialogs
- Output capture

### 9. Workspace
Browse and edit files in your workspace directory.

**Features:**
- File tree navigation
- Built-in text editor
- Permission checks (read/write/delete)
- Create new files
- Syntax highlighting (basic)

### 10. Performance Monitor
Track all API requests and analyze usage.

**Metrics:**
- Total requests
- Total tokens consumed
- Average tokens per request
- Average response duration
- Provider/model filtering
- CSV export

### 11. Settings
Configure all application settings.

**Sections:**
- General: Default parameters, auto-save, streaming
- API Endpoints: Provider URLs
- Advanced: Workspace, timeout, debug mode

### 12. Theme Manager
Choose from 15 professional themes.

**Theme Categories:**
- Dark themes (10): VS Code Dark, GitHub Dark, Dracula, etc.
- Light themes (5): VS Code Light, GitHub Light, Material Light, etc.

### 13. Plugin Manager
Load and manage plugins (extensibility).

**Plugin Types:**
- Custom API providers
- Processing modules
- UI extensions
- Export/import formats

**Note:** Plugin development requires DLL creation with specific interface.

### 14. Export/Import
Backup and restore conversations.

**Export:**
- Single conversation to JSON
- All conversations to JSON
- Preserves messages, metadata, timestamps

**Import:**
- Restore from JSON
- Creates new conversation in database
- Validates JSON structure

---

## 🗄️ Database

Universal LLM Studio uses SQLite for local data storage.

**Database Location:** `llmstudio.db` (same directory as executable)

**Tables:**
- `conversations`: Conversation metadata
- `messages`: Chat messages with roles and content
- `settings`: User preferences
- `prompts`: Saved prompt templates
- `documents`: Uploaded RAG documents
- `chunks`: Document chunks with embeddings
- `performance_logs`: API request metrics

**Backup:** Simply copy `llmstudio.db` to backup all data.

---

## 🔧 Troubleshooting

### "No API selected" Error
**Solution:** Select a provider (Ollama/LM Studio/Jan) from the top dropdown.

### "Failed to connect to API"
**Possible causes:**
1. Provider not running → Start Ollama/LM Studio/Jan
2. Wrong port → Check Settings → API Endpoints
3. Firewall blocking → Allow application through firewall

### "No models available"
**For Ollama:**
```bash
ollama pull llama2
```

**For LM Studio/Jan:**
Download a model through their UI first.

### Streaming not working
1. Check Settings → Enable streaming responses
2. Some providers may not support streaming
3. Try disabling and re-enabling streaming

### RAG upload fails
**Check:**
1. File format (TXT and PDF supported)
2. File permissions (read access)
3. File encoding (UTF-8 recommended)

### Code execution fails
**For Python:**
```bash
python --version  # Ensure Python is installed and in PATH
```

**For Node.js:**
```bash
node --version  # Ensure Node is installed and in PATH
```

### Database errors
1. Close all instances of the application
2. Check `llmstudio.db` is not read-only
3. If corrupted, delete `llmstudio.db` (will lose data)

---

## 🏗️ Architecture

### Core Units
- **APIBase.pas**: Abstract base class for all API providers
- **OllamaAPI.pas**, **LMStudioAPI.pas**, **JanAPI.pas**: Provider implementations
- **HTTPClient.pas**: HTTP wrapper for REST calls
- **DatabaseManager.pas**: SQLite database operations (FireDAC)
- **SettingsManager.pas**: Application settings persistence
- **ThemeManager.pas**: Theme definitions and application

### Feature Units
- **PromptManager.pas**: Prompt template CRUD
- **RAGEngine.pas**: Document chunking, embedding, search
- **CodeExecutor.pas**: Multi-language code execution
- **WorkspaceManager.pas**: File system operations with permissions
- **PerformanceTracker.pas**: Metrics collection and analysis
- **ExportImport.pas**: JSON serialization/deserialization
- **PluginSystem.pas**: Plugin loading framework
- **WebScraper.pas**: HTTP fetching utilities
- **AgentSystem.pas**: Autonomous task execution (placeholder)

### Forms (15 Total)
- **MainForm**: Hub with sidebar navigation
- **ChatForm**: Conversation interface
- **ModelCompareForm**: Side-by-side comparison
- **ModelManagerForm**: Download/delete models
- **BenchmarkForm**: Performance testing
- **RAGManagerForm**: Document upload/search
- **PromptLibraryForm**: Template management
- **APIPlaygroundForm**: Raw API testing
- **CodeExecutionForm**: Code runner
- **WorkspaceForm**: File browser/editor
- **PerformanceMonitorForm**: Metrics dashboard
- **SettingsForm**: Configuration
- **ThemeManagerForm**: Theme selector
- **PluginManagerForm**: Plugin loader
- **ExportImportForm**: Backup/restore

---

## 🎨 Themes

### Dark Themes
1. **VS Code Dark**: Classic VS Code dark theme
2. **GitHub Dark**: GitHub's dark mode
3. **Dracula**: Popular purple-accented theme
4. **Monokai Pro**: Warm, professional dark theme
5. **Nord**: Arctic, bluish dark theme
6. **Gruvbox Dark**: Retro, warm dark theme
7. **Solarized Dark**: Scientifically designed dark mode
8. **Tokyo Night**: Vibrant night theme
9. **One Dark Pro**: Atom's iconic dark theme
10. **Material Dark**: Google Material Design dark

### Light Themes
1. **GitHub Light**: Clean, minimal light theme
2. **VS Code Light**: Classic VS Code light
3. **Solarized Light**: Scientifically designed light mode
4. **Gruvbox Light**: Retro, warm light theme
5. **Material Light**: Google Material Design light

---

## 📝 Keyboard Shortcuts

### Global
- **Ctrl+N**: New chat
- **Ctrl+S**: Save (context-dependent)
- **Ctrl+O**: Open/Load (context-dependent)
- **F5**: Refresh current view

### Chat
- **Ctrl+Enter**: Send message
- **Ctrl+Shift+N**: New conversation
- **Ctrl+Shift+D**: Delete conversation

### Code Execution
- **F5**: Run code
- **Shift+F5**: Stop execution

---

## 🔐 Security Considerations

### Code Execution
- **Always use Sandbox Mode** when running untrusted code
- Code execution has full system access in non-sandbox mode
- Review code before running
- Limit workspace permissions

### API Keys
- This application connects to **local** APIs only
- No external API keys required
- No data sent to external servers
- All processing happens locally

### Plugins
- Only load plugins from trusted sources
- Plugins have full application access
- Verify plugin origin before loading

---

## 🤝 Contributing

This is a complete, production-ready application. If you'd like to extend it:

1. **Fork** the repository
2. **Create** a feature branch
3. **Implement** your changes
4. **Test** thoroughly
5. **Submit** a pull request

### Areas for Enhancement
- Additional API providers (OpenAI-compatible endpoints)
- Image generation (DALL-E, Stable Diffusion)
- Voice input/output (Whisper, TTS)
- Advanced RAG with vector databases
- Multi-language plugin API
- Cloud sync for conversations

---

## 📄 License

This project is provided as-is for educational and personal use.

**Libraries Used:**
- Delphi 12 VCL Framework
- FireDAC (SQLite)
- Indy HTTP Components
- System.Net.HTTPClient

---

## 🙏 Credits

**Developed with:**
- Delphi 12 Athens
- SQLite 3
- JSON parsing via System.JSON

**Inspired by:**
- Ollama
- LM Studio
- Jan
- ChatGPT Desktop
- Continue.dev

---

## 📞 Support

For issues, questions, or feature requests:

1. Check the **Troubleshooting** section above
2. Review the **Module Reference** for usage details
3. Ensure all system requirements are met
4. Verify your local LLM provider is running

---

## 🚀 Roadmap

### Completed Features ✅
- Multi-provider support (Ollama, LM Studio, Jan)
- Conversation management with SQLite
- Model comparison (2-3 simultaneous)
- RAG document upload and search
- Prompt template library
- Code execution (Python, JS, PowerShell, Batch)
- Workspace file management
- Performance monitoring
- 15 professional themes
- Export/Import conversations
- API playground
- Model benchmarking
- Plugin system foundation

### Future Enhancements 🔮
- Image generation integration
- Voice input/output
- Advanced embedding models
- Cloud sync (optional)
- Collaboration features
- Mobile companion app
- Advanced plugin marketplace
- Real-time collaboration
- Version control integration

---

**Universal LLM Studio** - Your complete desktop solution for local LLM interaction.

*Built with ❤️ using Delphi 12*
