unit LlamaCppBindings;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, Winapi.Windows;

type
  // Opaque pointers
  llama_model = Pointer;
  llama_context = Pointer;
  llama_token = Int32;
  llama_pos = Int32;
  llama_seq_id = Int32;

  // Model parameters
  llama_model_params = record
    n_gpu_layers: Int32;          // Number of layers to offload to GPU
    split_mode: Int32;            // How to split model across GPUs
    main_gpu: Int32;              // Main GPU to use
    tensor_split: Pointer;        // Float array for tensor split
    progress_callback: Pointer;
    progress_callback_user_data: Pointer;
    kv_overrides: Pointer;
    vocab_only: Boolean;
    use_mmap: Boolean;
    use_mlock: Boolean;
  end;

  // Context parameters
  llama_context_params = record
    seed: UInt32;
    n_ctx: UInt32;                // Context size
    n_batch: UInt32;
    n_threads: UInt32;
    n_threads_batch: UInt32;
    rope_scaling_type: Int32;
    rope_freq_base: Single;
    rope_freq_scale: Single;
    yarn_ext_factor: Single;
    yarn_attn_factor: Single;
    yarn_beta_fast: Single;
    yarn_beta_slow: Single;
    yarn_orig_ctx: UInt32;
    defrag_thold: Single;
    cb_eval: Pointer;
    cb_eval_user_data: Pointer;
    type_k: Int32;
    type_v: Int32;
    logits_all: Boolean;
    embedding: Boolean;
    offload_kqv: Boolean;
  end;

  // Batch for processing
  llama_batch = record
    n_tokens: Int32;
    token: Pointer;               // llama_token*
    embd: PSingle;
    pos: Pointer;                 // llama_pos*
    n_seq_id: Pointer;            // Int32*
    seq_id: Pointer;              // llama_seq_id**
    logits: PByte;
    all_pos_0: llama_pos;
    all_pos_1: llama_pos;
    all_seq_id: llama_seq_id;
  end;

  // Token data for sampling
  llama_token_data = record
    id: llama_token;
    logit: Single;
    p: Single;
  end;

  llama_token_data_array = record
    data: Pointer;                // llama_token_data*
    size: NativeUInt;
    sorted: Boolean;
  end;

// Backend functions
procedure llama_backend_init(numa: Boolean); cdecl; external 'llama.dll';
procedure llama_backend_free; cdecl; external 'llama.dll';
function llama_supports_gpu_offload: Boolean; cdecl; external 'llama.dll';

// Model functions
function llama_model_default_params: llama_model_params; cdecl; external 'llama.dll';
function llama_load_model_from_file(path_model: PAnsiChar; params: llama_model_params): llama_model; cdecl; external 'llama.dll';
procedure llama_free_model(model: llama_model); cdecl; external 'llama.dll';

// Context functions
function llama_context_default_params: llama_context_params; cdecl; external 'llama.dll';
function llama_new_context_with_model(model: llama_model; params: llama_context_params): llama_context; cdecl; external 'llama.dll';
procedure llama_free(ctx: llama_context); cdecl; external 'llama.dll';

// Tokenization
function llama_tokenize(model: llama_model; text: PAnsiChar; text_len: Int32;
  tokens: Pointer; n_max_tokens: Int32; add_bos: Boolean; special: Boolean): Int32; cdecl; external 'llama.dll';

function llama_token_to_piece(model: llama_model; token: llama_token;
  buf: PAnsiChar; length: Int32): Int32; cdecl; external 'llama.dll';

// Special tokens
function llama_token_bos(model: llama_model): llama_token; cdecl; external 'llama.dll';
function llama_token_eos(model: llama_model): llama_token; cdecl; external 'llama.dll';
function llama_token_nl(model: llama_model): llama_token; cdecl; external 'llama.dll';

// Batch functions
function llama_batch_init(n_tokens: Int32; embd: Int32; n_seq_max: Int32): llama_batch; cdecl; external 'llama.dll';
procedure llama_batch_free(batch: llama_batch); cdecl; external 'llama.dll';

// Decoding
function llama_decode(ctx: llama_context; batch: llama_batch): Int32; cdecl; external 'llama.dll';

// Logits
function llama_get_logits(ctx: llama_context): PSingle; cdecl; external 'llama.dll';
function llama_get_logits_ith(ctx: llama_context; i: Int32): PSingle; cdecl; external 'llama.dll';

// Model info
function llama_n_vocab(model: llama_model): Int32; cdecl; external 'llama.dll';
function llama_n_ctx(ctx: llama_context): Int32; cdecl; external 'llama.dll';
function llama_n_ctx_train(model: llama_model): Int32; cdecl; external 'llama.dll';
function llama_n_embd(model: llama_model): Int32; cdecl; external 'llama.dll';

// Sampling functions
procedure llama_sample_softmax(ctx: llama_context; var candidates: llama_token_data_array); cdecl; external 'llama.dll';
procedure llama_sample_top_k(ctx: llama_context; var candidates: llama_token_data_array;
  k: Int32; min_keep: NativeUInt); cdecl; external 'llama.dll';
procedure llama_sample_top_p(ctx: llama_context; var candidates: llama_token_data_array;
  p: Single; min_keep: NativeUInt); cdecl; external 'llama.dll';
procedure llama_sample_temp(ctx: llama_context; var candidates: llama_token_data_array;
  temp: Single); cdecl; external 'llama.dll';
function llama_sample_token(ctx: llama_context; var candidates: llama_token_data_array): llama_token; cdecl; external 'llama.dll';

// KV cache
procedure llama_kv_cache_clear(ctx: llama_context); cdecl; external 'llama.dll';

implementation

end.
