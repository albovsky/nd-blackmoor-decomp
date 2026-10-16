# FUN_0042e72c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042e72c
# extent:       0x0042e72c-0x0042e7b8 (140 code bytes)
# span:         0x0042e72c-0x0042e7b8 (code 140, tables 0, padding 0)
# sha256:       12413d5e0afa20a4f02e4c57cd50897b89999c0824ac418368dd2c10c38cca91
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042e72c
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7, FUN_0044c479, FUN_0044c4ab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 36 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_0044c479, .text + (0x0044c479 - 0x401000)
.set FUN_0044c4ab, .text + (0x0044c4ab - 0x401000)

.org 0x0042e72c - 0x401000
.globl FUN_0042e72c
FUN_0042e72c:
    # block 0x0042e72c: entry, 5 instruction(s), ends with jne to 0x0042e753 (forward)
    push ebp                                     # 0042e72c
    {load} mov ebp, esp                          # 0042e72d
    push ecx                                     # 0042e72f
    cmp dword ptr [0x5d03bf], 0x0                # 0042e730
    jne.d8 L_0042e753                            # 0042e737
    # block 0x0042e739: entered by fall-through of jne at 0x0042e737, 3 instruction(s), ends with je to 0x0042e751 (forward)
    movsx eax, word ptr [0x63a4cd]               # 0042e739
    test eax, eax                                # 0042e740
    je.d8 L_0042e751                             # 0042e742
    # block 0x0042e744: entered by fall-through of je at 0x0042e742, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0042e751
    push 0x545aac                                # 0042e744
    call FUN_0044a2b7                            # 0042e749
    add esp, 0x4                                 # 0042e74e
L_0042e751:
    # block 0x0042e751: entered by je at 0x0042e742, 1 instruction(s), ends with forward jump to 0x0042e7b4
    jmp.d8 L_0042e7b4                            # 0042e751
L_0042e753:
    # block 0x0042e753: entered by jne at 0x0042e737, 6 instruction(s), calls FUN_0044c479, ends with je to 0x0042e776 (forward)
    push 0x5b4c3a                                # 0042e753
    call FUN_0044c479                            # 0042e758
    add esp, 0x4                                 # 0042e75d
    movsx ecx, word ptr [0x5b4dc8]               # 0042e760
    test ecx, ecx                                # 0042e767
    je.d8 L_0042e776                             # 0042e769
    # block 0x0042e76b: entered by fall-through of je at 0x0042e769, 2 instruction(s), ends with forward jump to 0x0042e77f
    mov word ptr [0x5b4dc8], 0x0                 # 0042e76b
    jmp.d8 L_0042e77f                            # 0042e774
L_0042e776:
    # block 0x0042e776: entered by je at 0x0042e769, 1 instruction(s), falls into the block at 0x0042e77f
    mov word ptr [0x5b4dc8], 0x1                 # 0042e776
L_0042e77f:
    # block 0x0042e77f: entered by jmp at 0x0042e774, 4 instruction(s), ends with je to 0x0042e791 (forward)
    movsx edx, word ptr [0x5b4e04]               # 0042e77f
    mov dword ptr [ebp - local_4], edx           # 0042e786
    cmp dword ptr [ebp - local_4], 0x2           # 0042e789
    je.d8 L_0042e791                             # 0042e78d
    # block 0x0042e78f: entered by fall-through of je at 0x0042e78d, 1 instruction(s), ends with forward jump to 0x0042e7a7
    jmp.d8 L_0042e7a7                            # 0042e78f
L_0042e791:
    # block 0x0042e791: entered by je at 0x0042e78d, 4 instruction(s), falls into the block at 0x0042e7a7
    movsx eax, word ptr [0x5b4dc8]               # 0042e791
    mov ecx, dword ptr [0x5d03bf]                # 0042e798
    mov edx, dword ptr [4*eax + 0x5b4db8]        # 0042e79e
    mov dword ptr [ecx], edx                     # 0042e7a5
L_0042e7a7:
    # block 0x0042e7a7: entered by jmp at 0x0042e78f, 3 instruction(s), calls FUN_0044c4ab, falls into the block at 0x0042e7b4
    push 0x5b4c3a                                # 0042e7a7
    call FUN_0044c4ab                            # 0042e7ac
    add esp, 0x4                                 # 0042e7b1
L_0042e7b4:
    # block 0x0042e7b4: entered by jmp at 0x0042e751, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0042e7b4
    pop ebp                                      # 0042e7b6
    ret                                          # 0042e7b7

