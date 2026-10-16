# FUN_0050ffb2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ffb2
# extent:       0x0050ffb2-0x0050ffdd (43 code bytes)
# span:         0x0050ffb2-0x0050ffdd (code 43, tables 0, padding 0)
# sha256:       1ed5ead150241d4e3568fc326c3a104cd9002ff3342ec12c4d2b969b26242738
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ffb2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00511f30, FUN_0050ea90, FUN_005128b0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)

.org 0x0050ffb2 - 0x401000
.globl FUN_0050ffb2
FUN_0050ffb2:
    # block 0x0050ffb2: entry, 4 instruction(s), ends with je to 0x0050ffd9 (forward)
    push esi                                     # 0050ffb2
    mov esi, dword ptr [esp + stk_8]             # 0050ffb3
    test esi, esi                                # 0050ffb7
    je.d8 L_0050ffd9                             # 0050ffb9
    # block 0x0050ffbb: entered by fall-through of je at 0x0050ffb9, 9 instruction(s), calls FUN_00511f30, FUN_0050ea90, ends with je to 0x0050ffd9 (forward)
    push esi                                     # 0050ffbb
    call FUN_00511f30                            # 0050ffbc
    inc eax                                      # 0050ffc1
    push eax                                     # 0050ffc2
    call FUN_0050ea90                            # 0050ffc3
    pop ecx                                      # 0050ffc8
    test eax, eax                                # 0050ffc9
    pop ecx                                      # 0050ffcb
    je.d8 L_0050ffd9                             # 0050ffcc
    # block 0x0050ffce: entered by fall-through of je at 0x0050ffcc, 7 instruction(s), calls FUN_005128b0, ends with ret
    push esi                                     # 0050ffce
    push eax                                     # 0050ffcf
    call FUN_005128b0                            # 0050ffd0
    pop ecx                                      # 0050ffd5
    pop ecx                                      # 0050ffd6
    pop esi                                      # 0050ffd7
    ret                                          # 0050ffd8
L_0050ffd9:
    # block 0x0050ffd9: entered by je at 0x0050ffb9; je at 0x0050ffcc, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050ffd9
    pop esi                                      # 0050ffdb
    ret                                          # 0050ffdc

