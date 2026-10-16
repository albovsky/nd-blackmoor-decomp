# FUN_0050ed10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ed10
# extent:       0x0050ed10-0x0050ed44 (52 code bytes)
# span:         0x0050ed10-0x0050ed50 (code 52, tables 0, padding 12)
# sha256:       3d0898d998acc8af3ea17032ff56fd1b963c685b072f669c52d4b8267f9d0a78
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050ebca (+0x146)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ed10
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x10 (callee pops 16 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_c, stk_10, stk_14
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------

.org 0x0050ed10 - 0x401000
.globl FUN_0050ed10
FUN_0050ed10:
    # block 0x0050ed10: entry, 5 instruction(s), ends with jne to 0x0050ed29 (forward)
    mov eax, dword ptr [esp + stk_8]             # 0050ed10
    mov ecx, dword ptr [esp + stk_10]            # 0050ed14
    {load} or ecx, eax                           # 0050ed18
    mov ecx, dword ptr [esp + stk_c]             # 0050ed1a
    jne.d8 L_0050ed29                            # 0050ed1e
    # block 0x0050ed20: entered by fall-through of jne at 0x0050ed1e, 3 instruction(s), ends with ret 0x10
    mov eax, dword ptr [esp + stk_4]             # 0050ed20
    mul ecx                                      # 0050ed24
    ret 0x10                                     # 0050ed26
L_0050ed29:
    # block 0x0050ed29: entered by jne at 0x0050ed1e, 11 instruction(s), ends with ret 0x10
    push ebx                                     # 0050ed29
    mul ecx                                      # 0050ed2a
    {load} mov ebx, eax                          # 0050ed2c
    mov eax, dword ptr [esp + stk_8]             # 0050ed2e
    mul dword ptr [esp + stk_14]                 # 0050ed32
    {load} add ebx, eax                          # 0050ed36
    mov eax, dword ptr [esp + stk_8]             # 0050ed38
    mul ecx                                      # 0050ed3c
    {load} add edx, ebx                          # 0050ed3e
    pop ebx                                      # 0050ed40
    ret 0x10                                     # 0050ed41

# --- data items (not part of the function) -------------------------
.org 0x0050ed44 - 0x401000
PAD_0050ed44:  # 12 byte(s) of int3 padding
    .fill 12, 1, 0xcc

