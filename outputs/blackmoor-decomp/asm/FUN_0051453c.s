# FUN_0051453c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051453c
# extent:       0x0051453c-0x00514569 (45 code bytes)
# span:         0x0051453c-0x00514569 (code 45, tables 0, padding 0)
# sha256:       a7dd9b4c8431328111f9620a81e6279119bcd89584a06f8b875107e8c5f66283
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051453c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0051453c - 0x401000
.globl FUN_0051453c
FUN_0051453c:
    # block 0x0051453c: entry, 3 instruction(s), ends with je to 0x00514548 (forward)
    mov al, byte ptr [esp + stk_4]               # 0051453c
    test al, 0x20                                # 00514540
    je.d8 L_00514548                             # 00514542
    # block 0x00514544: entered by fall-through of je at 0x00514542, 2 instruction(s), ends with forward jump to 0x0051455e
    push 0x5                                     # 00514544
    jmp.d8 L_0051455e                            # 00514546
L_00514548:
    # block 0x00514548: entered by je at 0x00514542, 2 instruction(s), ends with je to 0x00514550 (forward)
    test al, 0x8                                 # 00514548
    je.d8 L_00514550                             # 0051454a
    # block 0x0051454c: entered by fall-through of je at 0x0051454a, 2 instruction(s), ends with forward jump to 0x0051455e
    push 0x1                                     # 0051454c
    jmp.d8 L_0051455e                            # 0051454e
L_00514550:
    # block 0x00514550: entered by je at 0x0051454a, 2 instruction(s), ends with je to 0x00514558 (forward)
    test al, 0x4                                 # 00514550
    je.d8 L_00514558                             # 00514552
    # block 0x00514554: entered by fall-through of je at 0x00514552, 2 instruction(s), ends with forward jump to 0x0051455e
    push 0x2                                     # 00514554
    jmp.d8 L_0051455e                            # 00514556
L_00514558:
    # block 0x00514558: entered by je at 0x00514552, 2 instruction(s), ends with je to 0x00514560 (forward)
    test al, 0x1                                 # 00514558
    je.d8 L_00514560                             # 0051455a
    # block 0x0051455c: entered by fall-through of je at 0x0051455a, 1 instruction(s), falls into the block at 0x0051455e
    push 0x3                                     # 0051455c
L_0051455e:
    # block 0x0051455e: entered by jmp at 0x00514546; jmp at 0x0051454e; jmp at 0x00514556, 2 instruction(s), ends with ret
    pop eax                                      # 0051455e
    ret                                          # 0051455f
L_00514560:
    # block 0x00514560: entered by je at 0x0051455a, 4 instruction(s), ends with ret
    movzx eax, al                                # 00514560
    and eax, 0x2                                 # 00514563
    shl eax                                      # 00514566
    ret                                          # 00514568

