# FUN_004e78c2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e78c2
# extent:       0x004e78c2-0x004e7970 (174 code bytes)
# span:         0x004e78c2-0x004e7970 (code 174, tables 0, padding 0)
# sha256:       49a173785aa66945808ce7666688d884c0bf95e03a8e773760151962b75e7a05
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e78c2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_991; [ecx + n] field_991
# callees:      calls FUN_004ee517, FUN_004d31ef
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 45 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_991, 0x991  # offset +0x991

# --- external targets -----------------------------------------------
.set FUN_004d31ef, .text + (0x004d31ef - 0x401000)
.set FUN_004ee517, .text + (0x004ee517 - 0x401000)

.org 0x004e78c2 - 0x401000
.globl FUN_004e78c2
FUN_004e78c2:
    # block 0x004e78c2: entry, 7 instruction(s), ends with je to 0x004e78e3 (forward)
    push ebp                                     # 004e78c2
    {load} mov ebp, esp                          # 004e78c3
    sub esp, 0x8                                 # 004e78c5
    mov dword ptr [ebp - local_8], ecx           # 004e78c8
    mov eax, dword ptr [ebp - local_8]           # 004e78cb
    cmp dword ptr [eax + field_991], 0x0         # 004e78ce
    je.d8 L_004e78e3                             # 004e78d5
    # block 0x004e78d7: entered by fall-through of je at 0x004e78d5, 3 instruction(s), ends with jne to 0x004e78e8 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e78d7
    cmp dword ptr [ecx + field_991], 0x1         # 004e78da
    jne.d8 L_004e78e8                            # 004e78e1
L_004e78e3:
    # block 0x004e78e3: entered by je at 0x004e78d5; fall-through of jne at 0x004e78e1, 1 instruction(s), ends with forward jump to 0x004e796c
    jmp.d32 L_004e796c                           # 004e78e3
L_004e78e8:
    # block 0x004e78e8: entered by jne at 0x004e78e1, 4 instruction(s), calls FUN_004ee517, ends with je to 0x004e78f6 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e78e8
    call FUN_004ee517                            # 004e78eb
    test eax, eax                                # 004e78f0
    je.d8 L_004e78f6                             # 004e78f2
    # block 0x004e78f4: entered by fall-through of je at 0x004e78f2, 1 instruction(s), ends with forward jump to 0x004e796c
    jmp.d8 L_004e796c                            # 004e78f4
L_004e78f6:
    # block 0x004e78f6: entered by je at 0x004e78f2, 2 instruction(s), ends with jne to 0x004e794a (forward)
    cmp dword ptr [0x5c39e5], 0x2712             # 004e78f6
    jne.d8 L_004e794a                            # 004e7900
    # block 0x004e7902: entered by fall-through of jne at 0x004e7900, 3 instruction(s), ends with je to 0x004e794a (forward)
    movsx edx, word ptr [0x5b15cc]               # 004e7902
    cmp edx, -0x1                                # 004e7909
    je.d8 L_004e794a                             # 004e790c
    # block 0x004e790e: entered by fall-through of je at 0x004e790c, 2 instruction(s), ends with forward jump to 0x004e7920
    mov dword ptr [ebp - local_4], 0x0           # 004e790e
    jmp.d8 L_004e7920                            # 004e7915
L_004e7917:
    # block 0x004e7917: entered by jmp at 0x004e7934, 3 instruction(s), falls into the block at 0x004e7920
    mov eax, dword ptr [ebp - local_4]           # 004e7917
    add eax, 0x1                                 # 004e791a
    mov dword ptr [ebp - local_4], eax           # 004e791d
L_004e7920:
    # block 0x004e7920: entered by jmp at 0x004e7915, 2 instruction(s), ends with jge to 0x004e7936 (forward)
    cmp dword ptr [ebp - local_4], 0x1e          # 004e7920
    jge.d8 L_004e7936                            # 004e7924
    # block 0x004e7926: entered by fall-through of jge at 0x004e7924, 3 instruction(s), ends with backward jump to 0x004e7917
    mov ecx, dword ptr [ebp - local_4]           # 004e7926
    mov dword ptr [4*ecx + 0x5839b1], 0x0        # 004e7929
    jmp.d8 L_004e7917                            # 004e7934
L_004e7936:
    # block 0x004e7936: entered by jge at 0x004e7924, 3 instruction(s), ends with forward jump to 0x004e796c
    movsx edx, word ptr [0x5b15cc]               # 004e7936
    mov dword ptr [4*edx + 0x5839b1], 0x1        # 004e793d
    jmp.d8 L_004e796c                            # 004e7948
L_004e794a:
    # block 0x004e794a: entered by jne at 0x004e7900; je at 0x004e790c, 2 instruction(s), ends with jne to 0x004e796c (forward)
    cmp dword ptr [0x5c39e5], 0x2712             # 004e794a
    jne.d8 L_004e796c                            # 004e7954
    # block 0x004e7956: entered by fall-through of jne at 0x004e7954, 3 instruction(s), ends with je to 0x004e796c (forward)
    movsx eax, word ptr [0x5b15ce]               # 004e7956
    cmp eax, -0x1                                # 004e795d
    je.d8 L_004e796c                             # 004e7960
    # block 0x004e7962: entered by fall-through of je at 0x004e7960, 3 instruction(s), calls FUN_004d31ef, falls into the block at 0x004e796c
    push 0x2                                     # 004e7962
    call FUN_004d31ef                            # 004e7964
    add esp, 0x4                                 # 004e7969
L_004e796c:
    # block 0x004e796c: entered by jmp at 0x004e78e3; jmp at 0x004e78f4; jmp at 0x004e7948; jne at 0x004e7954; more, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e796c
    pop ebp                                      # 004e796e
    ret                                          # 004e796f

