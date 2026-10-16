# FUN_0050bc50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050bc50
# extent:       0x0050bc50-0x0050bc78 (40 code bytes)
# span:         0x0050bc50-0x0050bc80 (code 40, tables 0, padding 8)
# sha256:       a0a154dfa7722df06aa5cbe46c359fb08c587d9c1450c6ca0542ee778d4e4d47
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050bc50
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c, field_10; [edx + n] field_4, field_8, field_c, field_10; [esp + n] stk_4, stk_8, stk_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050bc50 - 0x401000
.globl FUN_0050bc50
FUN_0050bc50:
    # block 0x0050bc50: entry, 14 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050bc50
    {load} xor ecx, ecx                          # 0050bc54
    {load} mov edx, eax                          # 0050bc56
    mov dword ptr [edx], ecx                     # 0050bc58
    mov dword ptr [edx + field_4], ecx           # 0050bc5a
    mov dword ptr [edx + field_8], ecx           # 0050bc5d
    mov dword ptr [edx + field_c], ecx           # 0050bc60
    mov dword ptr [edx + field_10], ecx          # 0050bc63
    mov ecx, dword ptr [esp + stk_8]             # 0050bc66
    mov dword ptr [eax + field_c], ecx           # 0050bc6a
    mov dword ptr [eax + field_8], ecx           # 0050bc6d
    mov ecx, dword ptr [esp + stk_c]             # 0050bc70
    mov dword ptr [eax + field_10], ecx          # 0050bc74
    ret                                          # 0050bc77

# --- data items (not part of the function) -------------------------
.org 0x0050bc78 - 0x401000
PAD_0050bc78:  # 8 byte(s) of nop padding
    .fill 8, 1, 0x90

