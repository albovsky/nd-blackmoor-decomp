# FUN_0050b9e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b9e0
# extent:       0x0050b9e0-0x0050b9f8 (24 code bytes)
# span:         0x0050b9e0-0x0050ba00 (code 24, tables 0, padding 8)
# sha256:       a3bed21f3bddda2cbb3349a90cf2cba646aa90b67ba6da91f5b83b000c1c0c01
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b9e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c, field_10, field_14, field_18; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x0050b9e0 - 0x401000
.globl FUN_0050b9e0
FUN_0050b9e0:
    # block 0x0050b9e0: entry, 9 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050b9e0
    {load} xor ecx, ecx                          # 0050b9e4
    mov dword ptr [eax + field_8], ecx           # 0050b9e6
    mov dword ptr [eax + field_c], ecx           # 0050b9e9
    mov dword ptr [eax + field_10], ecx          # 0050b9ec
    mov dword ptr [eax + field_14], ecx          # 0050b9ef
    mov dword ptr [eax + field_18], ecx          # 0050b9f2
    {load} xor eax, eax                          # 0050b9f5
    ret                                          # 0050b9f7

# --- data items (not part of the function) -------------------------
.org 0x0050b9f8 - 0x401000
PAD_0050b9f8:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

