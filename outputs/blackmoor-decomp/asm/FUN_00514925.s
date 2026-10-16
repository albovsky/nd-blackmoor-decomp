# FUN_00514925
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514925
# extent:       0x00514925-0x005149de (185 code bytes)
# span:         0x00514925-0x005149de (code 185, tables 0, padding 0)
# sha256:       733363c337ad686a565bc0b359e0860a0eaa6844df4284ff98aa2ab06b35b80b
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514925
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1; [scaled index + n] field_4
# callees:      calls FUN_005104fa, FUN_00511f30, FUN_0050ea90, FUN_0050e8ed, FUN_005128b0, FUN_0050e936
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 71 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)
.set FUN_005104fa, .text + (0x005104fa - 0x401000)
.set FUN_00511f30, .text + (0x00511f30 - 0x401000)
.set FUN_005128b0, .text + (0x005128b0 - 0x401000)

.org 0x00514925 - 0x401000
.globl FUN_00514925
FUN_00514925:
    # block 0x00514925: entry, 6 instruction(s), ends with jne to 0x00514937 (forward)
    push ebx                                     # 00514925
    {load} xor ebx, ebx                          # 00514926
    cmp dword ptr [0x63e130], ebx                # 00514928
    push esi                                     # 0051492e
    push edi                                     # 0051492f
    jne.d8 L_00514937                            # 00514930
    # block 0x00514932: entered by fall-through of jne at 0x00514930, 1 instruction(s), calls FUN_005104fa, falls into the block at 0x00514937
    call FUN_005104fa                            # 00514932
L_00514937:
    # block 0x00514937: entered by jne at 0x00514930, 2 instruction(s), falls into the block at 0x0051493f
    mov esi, dword ptr [0x63ca68]                # 00514937
    {load} xor edi, edi                          # 0051493d
L_0051493f:
    # block 0x0051493f: entered by jmp at 0x00514955, 3 instruction(s), ends with je to 0x00514957 (forward)
    mov al, byte ptr [esi]                       # 0051493f
    {load} cmp al, bl                            # 00514941
    je.d8 L_00514957                             # 00514943
    # block 0x00514945: entered by fall-through of je at 0x00514943, 2 instruction(s), ends with je to 0x0051494a (forward)
    cmp al, 0x3d                                 # 00514945
    je.d8 L_0051494a                             # 00514947
    # block 0x00514949: entered by fall-through of je at 0x00514947, 1 instruction(s), falls into the block at 0x0051494a
    inc edi                                      # 00514949
L_0051494a:
    # block 0x0051494a: entered by je at 0x00514947, 5 instruction(s), calls FUN_00511f30, ends with backward jump to 0x0051493f
    push esi                                     # 0051494a
    call FUN_00511f30                            # 0051494b
    pop ecx                                      # 00514950
    lea esi, [esi + eax + field_1]               # 00514951
    jmp.d8 L_0051493f                            # 00514955
L_00514957:
    # block 0x00514957: entered by je at 0x00514943, 8 instruction(s), calls FUN_0050ea90, ends with jne to 0x00514979 (forward)
    lea eax, [4*edi + field_4]                   # 00514957
    push eax                                     # 0051495e
    call FUN_0050ea90                            # 0051495f
    {load} mov esi, eax                          # 00514964
    pop ecx                                      # 00514966
    {load} cmp esi, ebx                          # 00514967
    mov dword ptr [0x63ca2c], esi                # 00514969
    jne.d8 L_00514979                            # 0051496f
    # block 0x00514971: entered by fall-through of jne at 0x0051496f, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x00514979
    push 0x9                                     # 00514971
    call FUN_0050e8ed                            # 00514973
    pop ecx                                      # 00514978
L_00514979:
    # block 0x00514979: entered by jne at 0x0051496f, 3 instruction(s), ends with je to 0x005149bc (forward)
    mov edi, dword ptr [0x63ca68]                # 00514979
    cmp byte ptr [edi], bl                       # 0051497f
    je.d8 L_005149bc                             # 00514981
    # block 0x00514983: entered by fall-through of je at 0x00514981, 1 instruction(s), falls into the block at 0x00514984
    push ebp                                     # 00514983
L_00514984:
    # block 0x00514984: entered by jne at 0x005149b9, 7 instruction(s), calls FUN_00511f30, ends with je to 0x005149b5 (forward)
    push edi                                     # 00514984
    call FUN_00511f30                            # 00514985
    {load} mov ebp, eax                          # 0051498a
    pop ecx                                      # 0051498c
    inc ebp                                      # 0051498d
    cmp byte ptr [edi], 0x3d                     # 0051498e
    je.d8 L_005149b5                             # 00514991
    # block 0x00514993: entered by fall-through of je at 0x00514991, 6 instruction(s), calls FUN_0050ea90, ends with jne to 0x005149a8 (forward)
    push ebp                                     # 00514993
    call FUN_0050ea90                            # 00514994
    {load} cmp eax, ebx                          # 00514999
    pop ecx                                      # 0051499b
    mov dword ptr [esi], eax                     # 0051499c
    jne.d8 L_005149a8                            # 0051499e
    # block 0x005149a0: entered by fall-through of jne at 0x0051499e, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x005149a8
    push 0x9                                     # 005149a0
    call FUN_0050e8ed                            # 005149a2
    pop ecx                                      # 005149a7
L_005149a8:
    # block 0x005149a8: entered by jne at 0x0051499e, 6 instruction(s), calls FUN_005128b0, falls into the block at 0x005149b5
    push edi                                     # 005149a8
    push dword ptr [esi]                         # 005149a9
    call FUN_005128b0                            # 005149ab
    pop ecx                                      # 005149b0
    add esi, 0x4                                 # 005149b1
    pop ecx                                      # 005149b4
L_005149b5:
    # block 0x005149b5: entered by je at 0x00514991, 3 instruction(s), ends with jne to 0x00514984 (backward)
    {load} add edi, ebp                          # 005149b5
    cmp byte ptr [edi], bl                       # 005149b7
    jne.d8 L_00514984                            # 005149b9
    # block 0x005149bb: entered by fall-through of jne at 0x005149b9, 1 instruction(s), falls into the block at 0x005149bc
    pop ebp                                      # 005149bb
L_005149bc:
    # block 0x005149bc: entered by je at 0x00514981, 10 instruction(s), calls FUN_0050e936, ends with ret
    push dword ptr [0x63ca68]                    # 005149bc
    call FUN_0050e936                            # 005149c2
    pop ecx                                      # 005149c7
    mov dword ptr [0x63ca68], ebx                # 005149c8
    mov dword ptr [esi], ebx                     # 005149ce
    pop edi                                      # 005149d0
    pop esi                                      # 005149d1
    mov dword ptr [0x63e12c], 0x1                # 005149d2
    pop ebx                                      # 005149dc
    ret                                          # 005149dd

