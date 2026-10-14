# FUN_0044aff2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044aff2
# extent:       0x0044aff2-0x0044b05a (104 code bytes)
# span:         0x0044aff2-0x0044b05a (code 104, tables 0, padding 0)
# sha256:       f030cbb26d5dd17c35cc5f9cdc0ca2b8ca447ae2e0c387682b16d0c7fd6e0489
# evidence:     ev_f3b444d1f980f96ceffd70dc3b45d7531f1aac7d9be5a687ffea9f3ee5b15a33
# region:       game
# frame:        ebp
# name:         action_values_init_sentinels
# arguments:    no stack arguments, plain ret; ecx is spilled to a frame slot but never read, so the routine behaves as a no-argument void function (possibly a thiscall-shaped member whose this is unused; eax/ecx/edx are scratch)
# locals:       [ebp-local_index] = 16-bit loop index (word store, sign-extended with movsx for comparison and addressing); [ebp-local_saved_ecx] = incoming ecx (dword), written once and never read; frame is 8 bytes (sub esp, 8)
# fields:       absolute globals: 30 words at 0x0058c959 + 2*i for i = 0..29 (signed compare i <= 0x1d) each set to 0x270f (9999); then 10 dwords at 0x0058c91d + 4*i for i = 0x1e..0x27 (signed compare i <= 0x27), i.e. 0x0058c995..0x0058c9bc, each set to 0x461c3c00 (the IEEE-754 single 9999.0f); nothing else is read or written
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/action_core.c:action_core_initialize_values
# unverified:   The base 0x58c91d is the original displacement used with index 30..39 (4*30 = 0x78 gives 0x58c995): the bytes prove the stores, not that 0x58c91d is a real object base. The semantic labels 'short values' / 'float values' come from action-values-init-validation.md and s0-action-runtime-trace.md, not from these bytes. The 0x461c3c00 = 9999.0f reading is IEEE-754 arithmetic, not verified against a consumer here. Purpose of the spilled ecx and the calling convention (cdecl vs thiscall) cannot be told from the bytes; callers were not traced. Only the index low word is kept (16-bit add), harmless here because the bounds are 0x1d and 0x27.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_index, 0x4  # [ebp - 0x4]
.equ local_saved_ecx, 0x8  # [ebp - 0x8]

# --- external targets -----------------------------------------------

.org 0x0044aff2 - 0x401000
.globl FUN_0044aff2
FUN_0044aff2:
    # block 0x0044aff2: entry: allocate 8 bytes, spill ecx (unused), set local_index = 0 (word), jump to the short-loop test
    push ebp                                     # 0044aff2
    {load} mov ebp, esp                          # 0044aff3
    sub esp, 0x8                                 # 0044aff5
    mov dword ptr [ebp - local_saved_ecx], ecx           # 0044aff8
    mov word ptr [ebp - local_index], 0x0            # 0044affb
    jmp.d8 L_test_short                            # 0044b001
L_next_short:
    # block 0x0044b003: short loop step: local_index = local_index + 1 (16-bit add in ax, stored back as a word)
    mov ax, word ptr [ebp - local_index]             # 0044b003
    .insn 0x66, 0x05, 0x0001{:u16}               # 0044b007
    mov word ptr [ebp - local_index], ax             # 0044b00b
L_test_short:
    # block 0x0044b00f: short loop test: ecx = sign-extended local_index; if ecx > 0x1d (signed jg) exit to L_start_floats
    movsx ecx, word ptr [ebp - local_index]          # 0044b00f
    cmp ecx, 0x1d                                # 0044b013
    jg.d8 L_start_floats                             # 0044b016
    # block 0x0044b018: short loop body: word [0x58c959 + 2*local_index] = 0x270f (9999), jump back to the step
    movsx edx, word ptr [ebp - local_index]          # 0044b018
    mov word ptr [2*edx + 0x58c959], 0x270f      # 0044b01c
    jmp.d8 L_next_short                            # 0044b026
L_start_floats:
    # block 0x0044b028: float loop init: local_index = 0x1e (word), jump to the float-loop test
    mov word ptr [ebp - local_index], 0x1e           # 0044b028
    jmp.d8 L_test_float                            # 0044b02e
L_next_float:
    # block 0x0044b030: float loop step: local_index = local_index + 1 (16-bit add in ax, stored back as a word)
    mov ax, word ptr [ebp - local_index]             # 0044b030
    .insn 0x66, 0x05, 0x0001{:u16}               # 0044b034
    mov word ptr [ebp - local_index], ax             # 0044b038
L_test_float:
    # block 0x0044b03c: float loop test: ecx = sign-extended local_index; if ecx > 0x27 (signed jg) exit to L_done
    movsx ecx, word ptr [ebp - local_index]          # 0044b03c
    cmp ecx, 0x27                                # 0044b040
    jg.d8 L_done                             # 0044b043
    # block 0x0044b045: float loop body: dword [0x58c91d + 4*local_index] = 0x461c3c00 (9999.0f), jump back to the step
    movsx edx, word ptr [ebp - local_index]          # 0044b045
    mov dword ptr [4*edx + 0x58c91d], 0x461c3c00 # 0044b049
    jmp.d8 L_next_float                            # 0044b054
L_done:
    # block 0x0044b056: epilogue: restore the frame and return with a plain ret
    {load} mov esp, ebp                          # 0044b056
    pop ebp                                      # 0044b058
    ret                                          # 0044b059
