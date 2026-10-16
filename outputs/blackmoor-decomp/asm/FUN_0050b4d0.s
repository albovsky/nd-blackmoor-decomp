# FUN_0050b4d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b4d0
# extent:       0x0050b4d0-0x0050b4f5 (37 code bytes)
# span:         0x0050b4d0-0x0050b500 (code 37, tables 0, padding 11)
# sha256:       927f3cdb00b8ee9398c3bc2555283210593c69393ab76e05f19b27dc75c4d38a
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b4d0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050e936, FUN_0050b4b0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 16 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050b4b0, .text + (0x0050b4b0 - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x0050b4d0 - 0x401000
.globl FUN_0050b4d0
FUN_0050b4d0:
    # block 0x0050b4d0: entry, 4 instruction(s), ends with je to 0x0050b4f1 (forward)
    push esi                                     # 0050b4d0
    mov esi, dword ptr [esp + stk_8]             # 0050b4d1
    test esi, esi                                # 0050b4d5
    je.d8 L_0050b4f1                             # 0050b4d7
    # block 0x0050b4d9: entered by fall-through of je at 0x0050b4d7, 3 instruction(s), ends with je to 0x0050b4e8 (forward)
    mov eax, dword ptr [esi]                     # 0050b4d9
    test eax, eax                                # 0050b4db
    je.d8 L_0050b4e8                             # 0050b4dd
    # block 0x0050b4df: entered by fall-through of je at 0x0050b4dd, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x0050b4e8
    push eax                                     # 0050b4df
    call FUN_0050e936                            # 0050b4e0
    add esp, 0x4                                 # 0050b4e5
L_0050b4e8:
    # block 0x0050b4e8: entered by je at 0x0050b4dd, 3 instruction(s), calls FUN_0050b4b0, falls into the block at 0x0050b4f1
    push esi                                     # 0050b4e8
    call FUN_0050b4b0                            # 0050b4e9
    add esp, 0x4                                 # 0050b4ee
L_0050b4f1:
    # block 0x0050b4f1: entered by je at 0x0050b4d7, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050b4f1
    pop esi                                      # 0050b4f3
    ret                                          # 0050b4f4

# --- data items (not part of the function) -------------------------
.org 0x0050b4f5 - 0x401000
PAD_0050b4f5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

