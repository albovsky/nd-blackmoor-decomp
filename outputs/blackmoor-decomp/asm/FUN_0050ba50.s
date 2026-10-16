# FUN_0050ba50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ba50
# extent:       0x0050ba50-0x0050ba6c (28 code bytes)
# span:         0x0050ba50-0x0050ba70 (code 28, tables 0, padding 4)
# sha256:       1b313ac8e8378cd7964e8d1ae7c30b98920df024e015ff685cf5b5023f8cdc7c
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ba50
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_14e; [esp + n] stk_8, stk_10
# callees:      calls FUN_0050ba00
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 10 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10
.equ field_14e, 0x14e  # offset +0x14e

# --- external targets -----------------------------------------------
.set FUN_0050ba00, .text + (0x0050ba00 - 0x401000)

.org 0x0050ba50 - 0x401000
.globl FUN_0050ba50
FUN_0050ba50:
    # block 0x0050ba50: entry, 10 instruction(s), calls FUN_0050ba00, ends with ret
    push esi                                     # 0050ba50
    mov esi, dword ptr [esp + stk_8]             # 0050ba51
    push esi                                     # 0050ba55
    call FUN_0050ba00                            # 0050ba56
    mov eax, dword ptr [esp + stk_10]            # 0050ba5b
    add esp, 0x4                                 # 0050ba5f
    mov dword ptr [esi + field_14e], eax         # 0050ba62
    {load} xor eax, eax                          # 0050ba68
    pop esi                                      # 0050ba6a
    ret                                          # 0050ba6b

# --- data items (not part of the function) -------------------------
.org 0x0050ba6c - 0x401000
PAD_0050ba6c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

