# FUN_0050d8bc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d8bc
# extent:       0x0050d8bc-0x0050d8d6 (26 code bytes)
# span:         0x0050d8bc-0x0050d8e0 (code 26, tables 0, padding 10)
# sha256:       614c2d6418a410ec481cd0421a3de459f2e61b3861c7e2b7906f555cc009c801
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d8bc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8, stk_c
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0050d8bc - 0x401000
.globl FUN_0050d8bc
FUN_0050d8bc:
    # block 0x0050d8bc: entry, 2 instruction(s), falls into the block at 0x0050d8c1
    push esi                                     # 0050d8bc
    mov esi, dword ptr [esp + stk_8]             # 0050d8bd
L_0050d8c1:
    # block 0x0050d8c1: entered by jmp at 0x0050d8d2, 2 instruction(s), ends with jae to 0x0050d8d4 (forward)
    cmp esi, dword ptr [esp + stk_c]             # 0050d8c1
    jae.d8 L_0050d8d4                            # 0050d8c5
    # block 0x0050d8c7: entered by fall-through of jae at 0x0050d8c5, 3 instruction(s), ends with je to 0x0050d8cf (forward)
    mov eax, dword ptr [esi]                     # 0050d8c7
    test eax, eax                                # 0050d8c9
    je.d8 L_0050d8cf                             # 0050d8cb
    # block 0x0050d8cd: entered by fall-through of je at 0x0050d8cb, 1 instruction(s), calls indirect eax, falls into the block at 0x0050d8cf
    call eax                                     # 0050d8cd
L_0050d8cf:
    # block 0x0050d8cf: entered by je at 0x0050d8cb, 2 instruction(s), ends with backward jump to 0x0050d8c1
    add esi, 0x4                                 # 0050d8cf
    jmp.d8 L_0050d8c1                            # 0050d8d2
L_0050d8d4:
    # block 0x0050d8d4: entered by jae at 0x0050d8c5, 2 instruction(s), ends with ret
    pop esi                                      # 0050d8d4
    ret                                          # 0050d8d5

# --- data items (not part of the function) -------------------------
.org 0x0050d8d6 - 0x401000
PAD_0050d8d6:  # 10 byte(s) of int3 padding
    .fill 10, 1, 0xcc

