# FUN_0051a3d4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a3d4
# extent:       0x0051a3d4-0x0051a3f4 (32 code bytes)
# span:         0x0051a3d4-0x0051a3f4 (code 32, tables 0, padding 0)
# sha256:       0cc8f87a625b97429e2bae375e9c262580b335cf7bc869e2d0f91cd5d7a92897
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a3d4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_c
# callees:      calls FUN_0051dc43
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0051a3d4 - 0x401000
.globl FUN_0051a3d4
FUN_0051a3d4:
    # block 0x0051a3d4: entry, 11 instruction(s), calls FUN_0051dc43, ends with ret 0xc
    mov eax, dword ptr [esp + stk_8]             # 0051a3d4
    imul eax, dword ptr [esp + stk_c]            # 0051a3d8
    add eax, 0x4                                 # 0051a3dd
    push eax                                     # 0051a3e0
    call FUN_0051dc43                            # 0051a3e1
    pop ecx                                      # 0051a3e6
    mov ecx, dword ptr [esp + stk_4]             # 0051a3e7
    mov edx, dword ptr [ecx]                     # 0051a3eb
    mov dword ptr [eax], edx                     # 0051a3ed
    mov dword ptr [ecx], eax                     # 0051a3ef
    ret 0xc                                      # 0051a3f1

