# FUN_00513c65
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513c65
# extent:       0x00513c65-0x00513ca8 (67 code bytes)
# span:         0x00513c65-0x00513ca8 (code 67, tables 0, padding 0)
# sha256:       49756c88592603c59a91d5ecf8589dab665fc8a2ad0f138e5d6e3c3b05c21169
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __fload_withFB
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edx + n] field_4; [esp + n] stk_4, stk_6
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_4, 0x4  # offset +0x4
.equ stk_6, 0x6  # offset +0x6

# --- external targets -----------------------------------------------

.org 0x00513c65 - 0x401000
.globl FUN_00513c65
FUN_00513c65:
    # block 0x00513c65: entry, 4 instruction(s), ends with je to 0x00513c77 (forward)
    mov eax, dword ptr [edx + field_4]           # 00513c65
    and eax, 0x7ff00000                          # 00513c68
    cmp eax, 0x7ff00000                          # 00513c6d
    je.d8 L_00513c77                             # 00513c72
    # block 0x00513c74: entered by fall-through of je at 0x00513c72, 2 instruction(s), ends with ret
    fld qword ptr [edx]                          # 00513c74
    ret                                          # 00513c76
L_00513c77:
    # block 0x00513c77: entered by je at 0x00513c72, 15 instruction(s), ends with ret
    mov eax, dword ptr [edx + field_4]           # 00513c77
    sub esp, 0xa                                 # 00513c7a
    or eax, 0x7fff0000                           # 00513c7d
    mov dword ptr [esp + stk_6], eax             # 00513c82
    mov eax, dword ptr [edx + field_4]           # 00513c86
    mov ecx, dword ptr [edx]                     # 00513c89
    shld eax, ecx, 0xb                           # 00513c8b
    shl ecx, 0xb                                 # 00513c8f
    mov dword ptr [esp + stk_4], eax             # 00513c92
    mov dword ptr [esp], ecx                     # 00513c96
    fld tbyte ptr [esp]                          # 00513c99
    add esp, 0xa                                 # 00513c9c
    test eax, 0x0                                # 00513c9f
    mov eax, dword ptr [edx + field_4]           # 00513ca4
    ret                                          # 00513ca7

