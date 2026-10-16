# FUN_0050b260
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b260
# extent:       0x0050b260-0x0050b285 (37 code bytes)
# span:         0x0050b260-0x0050b290 (code 37, tables 0, padding 11)
# sha256:       ab7af329f3e629490bc34aba4de5b09a097443bf6b6fa3b17527ae77b56d4f65
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b260
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_e, field_f, field_10, field_11; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_e, 0xe  # offset +0xe
.equ field_f, 0xf  # offset +0xf
.equ field_10, 0x10  # offset +0x10
.equ field_11, 0x11  # offset +0x11

# --- external targets -----------------------------------------------

.org 0x0050b260 - 0x401000
.globl FUN_0050b260
FUN_0050b260:
    # block 0x0050b260: entry, 15 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050b260
    {load} xor ecx, ecx                          # 0050b264
    {load} xor edx, edx                          # 0050b266
    mov eax, dword ptr [eax]                     # 0050b268
    mov ch, byte ptr [eax + field_11]            # 0050b26a
    mov dl, byte ptr [eax + field_f]             # 0050b26d
    mov cl, byte ptr [eax + field_10]            # 0050b270
    shl ecx, 0x8                                 # 0050b273
    {load} or ecx, edx                           # 0050b276
    {load} xor edx, edx                          # 0050b278
    mov dl, byte ptr [eax + field_e]             # 0050b27a
    shl ecx, 0x8                                 # 0050b27d
    {load} or ecx, edx                           # 0050b280
    {load} mov eax, ecx                          # 0050b282
    ret                                          # 0050b284

# --- data items (not part of the function) -------------------------
.org 0x0050b285 - 0x401000
PAD_0050b285:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

