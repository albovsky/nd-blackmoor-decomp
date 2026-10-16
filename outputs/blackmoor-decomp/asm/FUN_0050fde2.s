# FUN_0050fde2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050fde2
# extent:       0x0050fde2-0x0050fe79 (151 code bytes)
# span:         0x0050fde2-0x0050fe79 (code 151, tables 0, padding 0)
# sha256:       70f8bec9994d795dee0323ca469b485e70e531d280f0ceb7b0bfcccf599b694d
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050fde2
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [esi + n] field_1, field_minus_1
# callees:      calls FUN_00513030, FUN_00512c18, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 62 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_00513030, .text + (0x00513030 - 0x401000)

.org 0x0050fde2 - 0x401000
.globl FUN_0050fde2
FUN_0050fde2:
    # block 0x0050fde2: entry, 6 instruction(s), ends with jne to 0x0050fdff (forward)
    push ebp                                     # 0050fde2
    {load} mov ebp, esp                          # 0050fde3
    cmp dword ptr [0x63df1c], 0x0                # 0050fde5
    push ebx                                     # 0050fdec
    push esi                                     # 0050fded
    jne.d8 L_0050fdff                            # 0050fdee
    # block 0x0050fdf0: entered by fall-through of jne at 0x0050fdee, 6 instruction(s), calls FUN_00513030, ends with forward jump to 0x0050fe75
    push dword ptr [ebp + arg_c]                 # 0050fdf0
    push dword ptr [ebp + arg_8]                 # 0050fdf3
    call FUN_00513030                            # 0050fdf6
    pop ecx                                      # 0050fdfb
    pop ecx                                      # 0050fdfc
    jmp.d8 L_0050fe75                            # 0050fdfd
L_0050fdff:
    # block 0x0050fdff: entered by jne at 0x0050fdee, 4 instruction(s), calls FUN_00512c18, falls into the block at 0x0050fe0a
    push 0x19                                    # 0050fdff
    call FUN_00512c18                            # 0050fe01
    mov esi, dword ptr [ebp + arg_8]             # 0050fe06
    pop ecx                                      # 0050fe09
L_0050fe0a:
    # block 0x0050fe0a: entered by jmp at 0x0050fe42, 3 instruction(s), ends with je to 0x0050fe5d (forward)
    movzx bx, byte ptr [esi]                     # 0050fe0a
    test bx, bx                                  # 0050fe0e
    je.d8 L_0050fe5d                             # 0050fe11
    # block 0x0050fe13: entered by fall-through of je at 0x0050fe11, 3 instruction(s), ends with je to 0x0050fe39 (forward)
    movzx eax, bl                                # 0050fe13
    test byte ptr [eax + 0x63e021], 0x4          # 0050fe16
    je.d8 L_0050fe39                             # 0050fe1d
    # block 0x0050fe1f: entered by fall-through of je at 0x0050fe1d, 4 instruction(s), ends with je to 0x0050fe44 (forward)
    mov al, byte ptr [esi + field_1]             # 0050fe1f
    inc esi                                      # 0050fe22
    test al, al                                  # 0050fe23
    je.d8 L_0050fe44                             # 0050fe25
    # block 0x0050fe27: entered by fall-through of je at 0x0050fe25, 6 instruction(s), ends with je to 0x0050fe50 (forward)
    movzx ecx, bx                                # 0050fe27
    movzx eax, al                                # 0050fe2a
    shl ecx, 0x8                                 # 0050fe2d
    {load} or ecx, eax                           # 0050fe30
    cmp dword ptr [ebp + arg_c], ecx             # 0050fe32
    je.d8 L_0050fe50                             # 0050fe35
    # block 0x0050fe37: entered by fall-through of je at 0x0050fe35, 1 instruction(s), ends with forward jump to 0x0050fe41
    jmp.d8 L_0050fe41                            # 0050fe37
L_0050fe39:
    # block 0x0050fe39: entered by je at 0x0050fe1d, 3 instruction(s), ends with je to 0x0050fe5d (forward)
    movzx eax, bx                                # 0050fe39
    cmp dword ptr [ebp + arg_c], eax             # 0050fe3c
    je.d8 L_0050fe5d                             # 0050fe3f
L_0050fe41:
    # block 0x0050fe41: entered by jmp at 0x0050fe37; fall-through of je at 0x0050fe3f, 2 instruction(s), ends with backward jump to 0x0050fe0a
    inc esi                                      # 0050fe41
    jmp.d8 L_0050fe0a                            # 0050fe42
L_0050fe44:
    # block 0x0050fe44: entered by je at 0x0050fe25, 5 instruction(s), calls FUN_00512c79, ends with forward jump to 0x0050fe75
    push 0x19                                    # 0050fe44
    call FUN_00512c79                            # 0050fe46
    pop ecx                                      # 0050fe4b
    {load} xor eax, eax                          # 0050fe4c
    jmp.d8 L_0050fe75                            # 0050fe4e
L_0050fe50:
    # block 0x0050fe50: entered by je at 0x0050fe35, 5 instruction(s), calls FUN_00512c79, ends with forward jump to 0x0050fe75
    push 0x19                                    # 0050fe50
    call FUN_00512c79                            # 0050fe52
    pop ecx                                      # 0050fe57
    lea eax, [esi - field_minus_1]               # 0050fe58
    jmp.d8 L_0050fe75                            # 0050fe5b
L_0050fe5d:
    # block 0x0050fe5d: entered by je at 0x0050fe11; je at 0x0050fe3f, 10 instruction(s), calls FUN_00512c79, falls into the block at 0x0050fe75
    push 0x19                                    # 0050fe5d
    call FUN_00512c79                            # 0050fe5f
    mov eax, dword ptr [ebp + arg_c]             # 0050fe64
    pop ecx                                      # 0050fe67
    movzx ecx, bx                                # 0050fe68
    {load} sub eax, ecx                          # 0050fe6b
    neg eax                                      # 0050fe6d
    {load} sbb eax, eax                          # 0050fe6f
    not eax                                      # 0050fe71
    {load} and eax, esi                          # 0050fe73
L_0050fe75:
    # block 0x0050fe75: entered by jmp at 0x0050fdfd; jmp at 0x0050fe4e; jmp at 0x0050fe5b, 4 instruction(s), ends with ret
    pop esi                                      # 0050fe75
    pop ebx                                      # 0050fe76
    pop ebp                                      # 0050fe77
    ret                                          # 0050fe78

