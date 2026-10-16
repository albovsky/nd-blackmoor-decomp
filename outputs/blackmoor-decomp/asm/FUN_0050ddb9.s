# FUN_0050ddb9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ddb9
# extent:       0x0050ddb9-0x0050ddf5 (60 code bytes)
# span:         0x0050ddb9-0x0050de00 (code 60, tables 0, padding 11)
# sha256:       28b65cf550db67800d073bdd93bbc9b9bfd4e92e892ea6392a0b9172447516dd
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ddb9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c, stk_20
# callees:      calls FUN_005120d4, FUN_005134b9, FUN_005110a9, FUN_00513546, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ stk_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_005110a9, .text + (0x005110a9 - 0x401000)
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)
.set FUN_005134b9, .text + (0x005134b9 - 0x401000)
.set FUN_00513546, .text + (0x00513546 - 0x401000)

.org 0x0050ddb9 - 0x401000
.globl FUN_0050ddb9
FUN_0050ddb9:
    # block 0x0050ddb9: entry, 26 instruction(s), calls FUN_005120d4, FUN_005134b9, FUN_005110a9, FUN_00513546, FUN_00512126, ends with ret
    push ebx                                     # 0050ddb9
    push esi                                     # 0050ddba
    mov esi, dword ptr [esp + stk_c]             # 0050ddbb
    push edi                                     # 0050ddbf
    push esi                                     # 0050ddc0
    call FUN_005120d4                            # 0050ddc1
    push esi                                     # 0050ddc6
    call FUN_005134b9                            # 0050ddc7
    {load} mov edi, eax                          # 0050ddcc
    lea eax, [esp + stk_20]                      # 0050ddce
    push eax                                     # 0050ddd2
    push dword ptr [esp + stk_20]                # 0050ddd3
    push esi                                     # 0050ddd7
    call FUN_005110a9                            # 0050ddd8
    push esi                                     # 0050dddd
    push edi                                     # 0050ddde
    {load} mov ebx, eax                          # 0050dddf
    call FUN_00513546                            # 0050dde1
    push esi                                     # 0050dde6
    call FUN_00512126                            # 0050dde7
    add esp, 0x20                                # 0050ddec
    {load} mov eax, ebx                          # 0050ddef
    pop edi                                      # 0050ddf1
    pop esi                                      # 0050ddf2
    pop ebx                                      # 0050ddf3
    ret                                          # 0050ddf4

# --- data items (not part of the function) -------------------------
.org 0x0050ddf5 - 0x401000
PAD_0050ddf5:  # 11 byte(s) of int3 padding
    .fill 11, 1, 0xcc

