# FUN_00509d70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00509d70
# extent:       0x00509d70-0x00509d93 (35 code bytes)
# span:         0x00509d70-0x00509da0 (code 35, tables 0, padding 13)
# sha256:       e52e388379e0ca611db61d1796699fa9a13eee134043f5fa3931b2dbc22e628d
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00509d70
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00509d70 - 0x401000
.globl FUN_00509d70
FUN_00509d70:
    # block 0x00509d70: entry, 6 instruction(s), ends with jge to 0x00509d87 (forward)
    mov ecx, dword ptr [esp + stk_c]             # 00509d70
    mov eax, dword ptr [esp + stk_4]             # 00509d74
    mov edx, dword ptr [esp + stk_8]             # 00509d78
    mov eax, dword ptr [eax + 4*ecx]             # 00509d7c
    test eax, eax                                # 00509d7f
    jge.d8 L_00509d87                            # 00509d81
    # block 0x00509d83: entered by fall-through of jge at 0x00509d81, 2 instruction(s), ends with ret
    mov eax, dword ptr [edx + 4*ecx]             # 00509d83
    ret                                          # 00509d86
L_00509d87:
    # block 0x00509d87: entered by jge at 0x00509d81, 3 instruction(s), ends with jl to 0x00509d92 (forward)
    mov ecx, dword ptr [edx + 4*ecx]             # 00509d87
    test ecx, ecx                                # 00509d8a
    jl.d8 L_00509d92                             # 00509d8c
    # block 0x00509d8e: entered by fall-through of jl at 0x00509d8c, 2 instruction(s), falls into the block at 0x00509d92
    {load} add eax, ecx                          # 00509d8e
    sar eax                                      # 00509d90
L_00509d92:
    # block 0x00509d92: entered by jl at 0x00509d8c, 1 instruction(s), ends with ret
    ret                                          # 00509d92

# --- data items (not part of the function) -------------------------
.org 0x00509d93 - 0x401000
PAD_00509d93:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

