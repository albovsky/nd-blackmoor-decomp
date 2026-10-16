# FUN_0042e7b8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042e7b8
# extent:       0x0042e7b8-0x0042e844 (140 code bytes)
# span:         0x0042e7b8-0x0042e844 (code 140, tables 0, padding 0)
# sha256:       4165035517c8bbbfaa090e6bfa47d06345bb417c85ad234dd3ed240acb164355
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042e7b8
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_0044c479, FUN_0044c4ab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)

.org 0x0042e7b8 - 0x401000
.globl FUN_0042e7b8
FUN_0042e7b8:
    # block 0x0042e7b8: entry, 5 instruction(s), ends with jne to 0x0042e7df (forward)
    push ebp                                     # 0042e7b8
    {load} mov ebp, esp                          # 0042e7b9
    push ecx                                     # 0042e7bb
    cmp dword ptr [0x5d03c3], 0x0                # 0042e7bc
    jne.d8 L_0042e7df                            # 0042e7c3
    # block 0x0042e7c5: entered by fall-through of jne at 0x0042e7c3, 3 instruction(s), ends with je to 0x0042e7dd (forward)
    movsx eax, word ptr [0x63a4cd]               # 0042e7c5
    test eax, eax                                # 0042e7cc
    je.d8 L_0042e7dd                             # 0042e7ce
    # block 0x0042e7d0: entered by fall-through of je at 0x0042e7ce, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0042e7dd
    push 0x545ae8                                # 0042e7d0
    call FUN_0044a2b7                            # 0042e7d5
    add esp, 0x4                                 # 0042e7da
L_0042e7dd:
    # block 0x0042e7dd: entered by je at 0x0042e7ce, 1 instruction(s), ends with forward jump to 0x0042e840
    jmp.d8 L_0042e840                            # 0042e7dd
L_0042e7df:
    # block 0x0042e7df: entered by jne at 0x0042e7c3, 6 instruction(s), calls FUN_0044c479, ends with je to 0x0042e802 (forward)
    push 0x5b4eb1                                # 0042e7df
    call FUN_0044c479                            # 0042e7e4
    add esp, 0x4                                 # 0042e7e9
    movsx ecx, word ptr [0x5b503f]               # 0042e7ec
    test ecx, ecx                                # 0042e7f3
    je.d8 L_0042e802                             # 0042e7f5
    # block 0x0042e7f7: entered by fall-through of je at 0x0042e7f5, 2 instruction(s), ends with forward jump to 0x0042e80b
    mov word ptr [0x5b503f], 0x0                 # 0042e7f7
    jmp.d8 L_0042e80b                            # 0042e800
L_0042e802:
    # block 0x0042e802: entered by je at 0x0042e7f5, 1 instruction(s), falls into the block at 0x0042e80b
    mov word ptr [0x5b503f], 0x1                 # 0042e802
L_0042e80b:
    # block 0x0042e80b: entered by jmp at 0x0042e800, 4 instruction(s), ends with je to 0x0042e81d (forward)
    movsx edx, word ptr [0x5b507b]               # 0042e80b
    mov dword ptr [ebp - local_4], edx           # 0042e812
    cmp dword ptr [ebp - local_4], 0x2           # 0042e815
    je.d8 L_0042e81d                             # 0042e819
    # block 0x0042e81b: entered by fall-through of je at 0x0042e819, 1 instruction(s), ends with forward jump to 0x0042e833
    jmp.d8 L_0042e833                            # 0042e81b
L_0042e81d:
    # block 0x0042e81d: entered by je at 0x0042e819, 4 instruction(s), falls into the block at 0x0042e833
    movsx eax, word ptr [0x5b503f]               # 0042e81d
    mov ecx, dword ptr [0x5d03c3]                # 0042e824
    mov edx, dword ptr [4*eax + 0x5b502f]        # 0042e82a
    mov dword ptr [ecx], edx                     # 0042e831
L_0042e833:
    # block 0x0042e833: entered by jmp at 0x0042e81b, 3 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0042e840
    push 0x5b4eb1                                # 0042e833
    call FUN_0044c4ab                            # 0042e838
    add esp, 0x4                                 # 0042e83d
L_0042e840:
    # block 0x0042e840: entered by jmp at 0x0042e7dd, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042e840
    pop ebp                                      # 0042e842
    ret                                          # 0042e843

