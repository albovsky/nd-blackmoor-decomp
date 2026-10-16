# FUN_00522776
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522776
# extent:       0x00522776-0x005227c0 (74 code bytes)
# span:         0x00522776-0x005227c0 (code 74, tables 0, padding 0)
# sha256:       8facb339587a699ca6ff6a7f9890fa3291f6170bb2014aab91413ced11fb4ded
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005226e2 (+0x94)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522776
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls USER32.dll!RegisterWindowMessageA; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005227c0
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x00522776 - 0x401000
.globl FUN_00522776
FUN_00522776:
    # block 0x00522776: entry, 1 instruction(s), ends with forward jump to 0x0052277b
    jmp.d32 L_0052277b                           # 00522776
L_0052277b:
    # block 0x0052277b: entered by jmp at 0x00522776, 7 instruction(s), calls indirect esi, ends with je to 0x00522796 (forward)
    push esi                                     # 0052277b
    mov esi, dword ptr [0x52a224]                # 0052277c
    push edi                                     # 00522782
    call esi                                     # 00522783
    mov edi, 0x80000000                          # 00522785
    test edi, eax                                # 0052278a
    je.d8 L_00522796                             # 0052278c
    # block 0x0052278e: entered by fall-through of je at 0x0052278c, 3 instruction(s), calls indirect esi, ends with je to 0x005227a4 (forward)
    call esi                                     # 0052278e
    .insn 0x66, 0x3d, 0x0004{:u16}               # 00522790
    je.d8 L_005227a4                             # 00522794
L_00522796:
    # block 0x00522796: entered by je at 0x0052278c; fall-through of je at 0x00522794, 3 instruction(s), calls indirect esi, ends with jne to 0x005227b6 (forward)
    call esi                                     # 00522796
    test edi, eax                                # 00522798
    jne.d8 L_005227b6                            # 0052279a
    # block 0x0052279c: entered by fall-through of jne at 0x0052279a, 3 instruction(s), calls indirect esi, ends with jne to 0x005227b6 (forward)
    call esi                                     # 0052279c
    .insn 0x66, 0x3d, 0x0003{:u16}               # 0052279e
    jne.d8 L_005227b6                            # 005227a2
L_005227a4:
    # block 0x005227a4: entered by je at 0x00522794; fall-through of jne at 0x005227a2, 4 instruction(s), calls USER32.dll!RegisterWindowMessageA, ends with forward jump to 0x005227bd
    push 0x52fa48                                # 005227a4
    call dword ptr [0x52a460]                    # 005227a9
    mov dword ptr [0x63c428], eax                # 005227af
    jmp.d8 L_005227bd                            # 005227b4
L_005227b6:
    # block 0x005227b6: entered by jne at 0x0052279a; jne at 0x005227a2, 1 instruction(s), falls into the block at 0x005227bd
    and dword ptr [0x63c428], 0x0                # 005227b6
L_005227bd:
    # block 0x005227bd: entered by jmp at 0x005227b4, 3 instruction(s), ends with ret
    pop edi                                      # 005227bd
    pop esi                                      # 005227be
    ret                                          # 005227bf

