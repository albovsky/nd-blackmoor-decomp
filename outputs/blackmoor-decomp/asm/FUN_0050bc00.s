# FUN_0050bc00
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050bc00
# extent:       0x0050bc00-0x0050bc1e (30 code bytes)
# span:         0x0050bc00-0x0050bc20 (code 30, tables 0, padding 2)
# sha256:       1ddb4a5ffbebfeed2cdef1df69fbc2c87dfb2a8aea3de557add2d7ce4b685f42
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050bc00
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4
# callees:      calls FUN_0050bc80
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050bc80, .text + (0x0050bc80 - 0x401000)

.org 0x0050bc00 - 0x401000
.globl FUN_0050bc00
FUN_0050bc00:
    # block 0x0050bc00: entry, 5 instruction(s), ends with jge to 0x0050bc1d (forward)
    mov ecx, dword ptr [esp + stk_4]             # 0050bc00
    mov eax, 0x8                                 # 0050bc04
    sub eax, dword ptr [ecx + field_4]           # 0050bc09
    cmp eax, 0x8                                 # 0050bc0c
    jge.d8 L_0050bc1d                            # 0050bc0f
    # block 0x0050bc11: entered by fall-through of jge at 0x0050bc0f, 5 instruction(s), calls FUN_0050bc80, falls into the block at 0x0050bc1d
    push eax                                     # 0050bc11
    push 0x0                                     # 0050bc12
    push ecx                                     # 0050bc14
    call FUN_0050bc80                            # 0050bc15
    add esp, 0xc                                 # 0050bc1a
L_0050bc1d:
    # block 0x0050bc1d: entered by jge at 0x0050bc0f, 1 instruction(s), ends with ret
    ret                                          # 0050bc1d

# --- data items (not part of the function) -------------------------
.org 0x0050bc1e - 0x401000
PAD_0050bc1e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

