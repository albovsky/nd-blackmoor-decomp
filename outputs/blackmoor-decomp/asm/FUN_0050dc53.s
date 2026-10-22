# FUN_0050dc53
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050dc53
# extent:       0x0050dc53-0x0050dc82 (47 code bytes)
# span:         0x0050dc53-0x0050dc82 (code 47, tables 0, padding 0)
# sha256:       af5393c41428ae7a513daf314e0563ce7942994506dd84ed7013407bb64df227
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050dc53
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_0050dd15, FUN_005120d4, FUN_0050dc82, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050dc82, .text + (0x0050dc82 - 0x401000)
.set FUN_0050dd15, .text + (0x0050dd15 - 0x401000)
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)

.org 0x0050dc53 - 0x401000
.globl FUN_0050dc53
FUN_0050dc53:
    # block 0x0050dc53: entry, 4 instruction(s), ends with jne to 0x0050dc65 (forward)
    push esi                                     # 0050dc53
    mov esi, dword ptr [esp + stk_8]             # 0050dc54
    test esi, esi                                # 0050dc58
    jne.d8 L_0050dc65                            # 0050dc5a
    # block 0x0050dc5c: entered by fall-through of jne at 0x0050dc5a, 5 instruction(s), calls FUN_0050dd15, ends with ret
    push esi                                     # 0050dc5c
    call FUN_0050dd15                            # 0050dc5d
    pop ecx                                      # 0050dc62
    pop esi                                      # 0050dc63
    ret                                          # 0050dc64
L_0050dc65:
    # block 0x0050dc65: entered by jne at 0x0050dc5a, 13 instruction(s), calls FUN_005120d4, FUN_0050dc82, FUN_00512126, ends with ret
    push edi                                     # 0050dc65
    push esi                                     # 0050dc66
    call FUN_005120d4                            # 0050dc67
    push esi                                     # 0050dc6c
    call FUN_0050dc82                            # 0050dc6d
    push esi                                     # 0050dc72
    {load} mov edi, eax                          # 0050dc73
    call FUN_00512126                            # 0050dc75
    add esp, 0xc                                 # 0050dc7a
    {load} mov eax, edi                          # 0050dc7d
    pop edi                                      # 0050dc7f
    pop esi                                      # 0050dc80
    ret                                          # 0050dc81

