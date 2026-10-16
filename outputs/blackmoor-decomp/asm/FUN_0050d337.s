# FUN_0050d337
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d337
# extent:       0x0050d337-0x0050d359 (34 code bytes)
# span:         0x0050d337-0x0050d359 (code 34, tables 0, padding 0)
# sha256:       aa77884558e07abefd99170d46082493d6a1405d74bd857545a0639c092f64a2
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d337
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_005120d4, FUN_0050d359, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050d359, .text + (0x0050d359 - 0x401000)
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)

.org 0x0050d337 - 0x401000
.globl FUN_0050d337
FUN_0050d337:
    # block 0x0050d337: entry, 15 instruction(s), calls FUN_005120d4, FUN_0050d359, FUN_00512126, ends with ret
    push esi                                     # 0050d337
    mov esi, dword ptr [esp + stk_8]             # 0050d338
    push edi                                     # 0050d33c
    push esi                                     # 0050d33d
    call FUN_005120d4                            # 0050d33e
    push esi                                     # 0050d343
    call FUN_0050d359                            # 0050d344
    push esi                                     # 0050d349
    {load} mov edi, eax                          # 0050d34a
    call FUN_00512126                            # 0050d34c
    add esp, 0xc                                 # 0050d351
    {load} mov eax, edi                          # 0050d354
    pop edi                                      # 0050d356
    pop esi                                      # 0050d357
    ret                                          # 0050d358

