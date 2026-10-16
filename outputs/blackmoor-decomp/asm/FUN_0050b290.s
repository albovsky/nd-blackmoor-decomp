# FUN_0050b290
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b290
# extent:       0x0050b290-0x0050b2b5 (37 code bytes)
# span:         0x0050b290-0x0050b2c0 (code 37, tables 0, padding 11)
# sha256:       67d54993f5ce4e1730a584c97e1dadb6441d2324c3e736df9f15806cda4c6946
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b290
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_12, field_13, field_14, field_15; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_12, 0x12  # offset +0x12
.equ field_13, 0x13  # offset +0x13
.equ field_14, 0x14  # offset +0x14
.equ field_15, 0x15  # offset +0x15

# --- external targets -----------------------------------------------

.org 0x0050b290 - 0x401000
.globl FUN_0050b290
FUN_0050b290:
    # block 0x0050b290: entry, 15 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050b290
    {load} xor ecx, ecx                          # 0050b294
    {load} xor edx, edx                          # 0050b296
    mov eax, dword ptr [eax]                     # 0050b298
    mov ch, byte ptr [eax + field_15]            # 0050b29a
    mov dl, byte ptr [eax + field_13]            # 0050b29d
    mov cl, byte ptr [eax + field_14]            # 0050b2a0
    shl ecx, 0x8                                 # 0050b2a3
    {load} or ecx, edx                           # 0050b2a6
    {load} xor edx, edx                          # 0050b2a8
    mov dl, byte ptr [eax + field_12]            # 0050b2aa
    shl ecx, 0x8                                 # 0050b2ad
    {load} or ecx, edx                           # 0050b2b0
    {load} mov eax, ecx                          # 0050b2b2
    ret                                          # 0050b2b4

# --- data items (not part of the function) -------------------------
.org 0x0050b2b5 - 0x401000
PAD_0050b2b5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

