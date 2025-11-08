unit LlamaCppBindings;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

interface

uses
  System.SysUtils, Winapi.Windows;

type
  // llama.cpp opaque pointers
  llama_model_ptr = Pointer;
  llama_context_ptr = Pointer;
  llama_token = Int32;

  // Model parameters
  llama_model_params = record
    n_gpu_layers: Int32;        // GPU layers to offload
    main_gpu: Int32;            // Main GPU to use
    tensor_split: array[0..15] of Single;
    progress_callback: Pointer;
    progress_callback_user_data: Pointer;
    vocab_only: Boolean;
    use_mmap: Boolean;
    use_mlock: Boolean;
  end;

  // Context parameters
  llama_context_params = record
    seed: UInt32;
    n_ctx: Int32;               // Context size
    n_batch: Int32;
    n_threads: Int32;
    n_threads_batch: Int32;
    rope_scaling_type: Int32;
    rope_freq_base: Single;
    rope_freq_scale: Single;
    yarn_ext_factor: Single;
    yarn_attn_factor: Single;
    yarn_beta_fast: Single;
    yarn_beta_slow: Single;
    yarn_orig_ctx: Int32;
    embedding: Boolean;
    offload_kqv: Boolean;
  end;

  // Sampling parameters
  llama_token_data = record
    id: llama_token;
    logit: Single;
    p: Single;
  end;

  llama_token_data_array = record
    data: Pointer;
    size: NativeUInt;
    sorted: Boolean;
  end;

// llama.cpp DLL functions
function llama_backend_init(numa: Boolean): Boolean; cdecl; external 'llama.dll';
procedure llama_backend_free; cdecl; external 'llama.dll';

function llama_model_default_params: llama_model_params; cdecl; external 'llama.dll';
function llama_context_default_params: llama_context_params; cdecl; external 'llama.dll';

function llama_load_model_from_file(path_model: PAnsiChar; params: llama_model_params): llama_model_ptr; cdecl; external 'llama.dll';
procedure llama_free_model(model: llama_model_ptr); cdecl; external 'llama.dll';

function llama_new_context_with_model(model: llama_model_ptr; params: llama_context_params): llama_context_ptr; cdecl; external 'llama.dll';
procedure llama_free(ctx: llama_context_ptr); cdecl; external 'llama.dll';

function llama_tokenize(ctx: llama_context_ptr; text: PAnsiChar; text_len: Int32;
  tokens: Pointer; n_max_tokens: Int32; add_bos: Boolean; special: Boolean): Int32; cdecl; external 'llama.dll';

function llama_decode(ctx: llama_context_ptr; batch: Pointer): Int32; cdecl; external 'llama.dll';

function llama_get_logits(ctx: llama_context_ptr): PSingle; cdecl; external 'llama.dll';
function llama_get_logits_ith(ctx: llama_context_ptr; i: Int32): PSingle; cdecl; external 'llama.dll';

function llama_n_vocab(model: llama_model_ptr): Int32; cdecl; external 'llama.dll';
function llama_n_ctx(ctx: llama_context_ptr): Int32; cdecl; external 'llama.dll';
function llama_n_ctx_train(model: llama_model_ptr): Int32; cdecl; external 'llama.dll';

function llama_token_to_piece(model: llama_model_ptr; token: llama_token; buf: PAnsiChar; length: Int32): Int32; cdecl; external 'llama.dll';

function llama_token_bos(model: llama_model_ptr): llama_token; cdecl; external 'llama.dll';
function llama_token_eos(model: llama_model_ptr): llama_token; cdecl; external 'llama.dll';
function llama_token_nl(model: llama_model_ptr): llama_token; cdecl; external 'llama.dll';

// Sampling functions
procedure llama_sample_softmax(ctx: llama_context_ptr; var candidates: llama_token_data_array); cdecl; external 'llama.dll';
procedure llama_sample_top_k(ctx: llama_context_ptr; var candidates: llama_token_data_array; k: Int32; min_keep: NativeUInt); cdecl; external 'llama.dll';
procedure llama_sample_top_p(ctx: llama_context_ptr; var candidates: llama_token_data_array; p: Single; min_keep: NativeUInt); cdecl; external 'llama.dll';
procedure llama_sample_temp(ctx: llama_context_ptr; var candidates: llama_token_data_array; temp: Single); cdecl; external 'llama.dll';
function llama_sample_token(ctx: llama_context_ptr; var candidates: llama_token_data_array): llama_token; cdecl; external 'llama.dll';

// Batch processing
type
  llama_batch = record
    n_tokens: Int32;
    token: Pointer;      // llama_token*
    embd: PSingle;
    pos: PInt32;
    n_seq_id: PInt32;
    seq_id: Pointer;     // llama_seq_id**
    logits: PByte;
    all_pos_0: llama_token;
    all_pos_1: llama_token;
    all_seq_id: Int32;
  end;

function llama_batch_init(n_tokens: Int32; embd: Int32; n_seq_max: Int32): llama_batch; cdecl; external 'llama.dll';
procedure llama_batch_free(batch: llama_batch); cdecl; external 'llama.dll';

implementation

end.
