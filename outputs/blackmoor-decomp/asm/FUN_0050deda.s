# FUN_0050deda
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050deda
# extent:       0x0050deda-0x0050df7e (164 code bytes)
# span:         0x0050deda-0x0050df80 (code 164, tables 0, padding 2)
# sha256:       4a2783a1d0b5a8e8119fffbc204b52e55a81fdcf083b1b4c06993795743d86b2
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050deda
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       1 ebp-relative slot(s): local_20
# fields:       [eax + n] field_18
# callees:      calls FUN_00510dd3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 78 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_20, 0x20  # offset -0x20
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)

.org 0x0050deda - 0x401000
.globl FUN_0050deda
FUN_0050deda:
    # block 0x0050deda: entry, 16 instruction(s), calls FUN_00510dd3, falls into the block at 0x0050defb
    push ebp                                     # 0050deda
    {load} mov ebp, esp                          # 0050dedb
    sub esp, 0x20                                # 0050dedd
    push ebx                                     # 0050dee0
    push esi                                     # 0050dee1
    mov esi, dword ptr [ebp + arg_c]             # 0050dee2
    push edi                                     # 0050dee5
    call FUN_00510dd3                            # 0050dee6
    push 0x8                                     # 0050deeb
    mov dword ptr [ebp + arg_c], eax             # 0050deed
    pop ecx                                      # 0050def0
    {load} xor eax, eax                          # 0050def1
    lea edi, [ebp - local_20]                    # 0050def3
    push 0x7                                     # 0050def6
    rep stosd dword ptr es:[edi], eax            # 0050def8
    pop edi                                      # 0050defa
L_0050defb:
    # block 0x0050defb: entered by jne at 0x0050df14, 12 instruction(s), ends with jne to 0x0050defb (backward)
    mov dl, byte ptr [esi]                       # 0050defb
    mov bl, 0x1                                  # 0050defd
    movzx ecx, dl                                # 0050deff
    {load} mov eax, ecx                          # 0050df02
    {load} and ecx, edi                          # 0050df04
    shr eax, 0x3                                 # 0050df06
    shl bl, cl                                   # 0050df09
    lea eax, [ebp + eax - local_20]              # 0050df0b
    or byte ptr [eax], bl                        # 0050df0f
    inc esi                                      # 0050df11
    test dl, dl                                  # 0050df12
    jne.d8 L_0050defb                            # 0050df14
    # block 0x0050df16: entered by fall-through of jne at 0x0050df14, 3 instruction(s), ends with jne to 0x0050df23 (forward)
    mov edx, dword ptr [ebp + arg_8]             # 0050df16
    test edx, edx                                # 0050df19
    jne.d8 L_0050df23                            # 0050df1b
    # block 0x0050df1d: entered by fall-through of jne at 0x0050df1b, 2 instruction(s), falls into the block at 0x0050df23
    mov eax, dword ptr [ebp + arg_c]             # 0050df1d
    mov edx, dword ptr [eax + field_18]          # 0050df20
L_0050df23:
    # block 0x0050df23: entered by jne at 0x0050df1b; jmp at 0x0050df41, 11 instruction(s), ends with je to 0x0050df43 (forward)
    mov al, byte ptr [edx]                       # 0050df23
    push 0x1                                     # 0050df25
    movzx esi, al                                # 0050df27
    {load} mov ecx, esi                          # 0050df2a
    pop ebx                                      # 0050df2c
    {load} and ecx, edi                          # 0050df2d
    shl ebx, cl                                  # 0050df2f
    shr esi, 0x3                                 # 0050df31
    mov cl, byte ptr [ebp + esi - local_20]      # 0050df34
    test cl, bl                                  # 0050df38
    je.d8 L_0050df43                             # 0050df3a
    # block 0x0050df3c: entered by fall-through of je at 0x0050df3a, 2 instruction(s), ends with je to 0x0050df43 (forward)
    test al, al                                  # 0050df3c
    je.d8 L_0050df43                             # 0050df3e
    # block 0x0050df40: entered by fall-through of je at 0x0050df3e, 2 instruction(s), ends with backward jump to 0x0050df23
    inc edx                                      # 0050df40
    jmp.d8 L_0050df23                            # 0050df41
L_0050df43:
    # block 0x0050df43: entered by je at 0x0050df3a; je at 0x0050df3e, 1 instruction(s), falls into the block at 0x0050df45
    {load} mov ebx, edx                          # 0050df43
L_0050df45:
    # block 0x0050df45: entered by jmp at 0x0050df63, 3 instruction(s), ends with je to 0x0050df69 (forward)
    mov al, byte ptr [edx]                       # 0050df45
    test al, al                                  # 0050df47
    je.d8 L_0050df69                             # 0050df49
    # block 0x0050df4b: entered by fall-through of je at 0x0050df49, 10 instruction(s), ends with jne to 0x0050df65 (forward)
    movzx esi, al                                # 0050df4b
    {load} mov ecx, esi                          # 0050df4e
    push 0x1                                     # 0050df50
    {load} and ecx, edi                          # 0050df52
    pop eax                                      # 0050df54
    shl eax, cl                                  # 0050df55
    shr esi, 0x3                                 # 0050df57
    mov cl, byte ptr [ebp + esi - local_20]      # 0050df5a
    test cl, al                                  # 0050df5e
    jne.d8 L_0050df65                            # 0050df60
    # block 0x0050df62: entered by fall-through of jne at 0x0050df60, 2 instruction(s), ends with backward jump to 0x0050df45
    inc edx                                      # 0050df62
    jmp.d8 L_0050df45                            # 0050df63
L_0050df65:
    # block 0x0050df65: entered by jne at 0x0050df60, 2 instruction(s), falls into the block at 0x0050df69
    and byte ptr [edx], 0x0                      # 0050df65
    inc edx                                      # 0050df68
L_0050df69:
    # block 0x0050df69: entered by je at 0x0050df49, 12 instruction(s), ends with ret
    mov eax, dword ptr [ebp + arg_c]             # 0050df69
    pop edi                                      # 0050df6c
    pop esi                                      # 0050df6d
    mov dword ptr [eax + field_18], edx          # 0050df6e
    {load} mov eax, ebx                          # 0050df71
    {load} sub eax, edx                          # 0050df73
    neg eax                                      # 0050df75
    {load} sbb eax, eax                          # 0050df77
    {load} and eax, ebx                          # 0050df79
    pop ebx                                      # 0050df7b
    leave                                        # 0050df7c
    ret                                          # 0050df7d

# --- data items (not part of the function) -------------------------
.org 0x0050df7e - 0x401000
PAD_0050df7e:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc

