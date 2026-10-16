# FUN_0051e44e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e44e
# extent:       0x0051e44e-0x0051e4ca (124 code bytes)
# span:         0x0051e44e-0x0051e4ca (code 124, tables 0, padding 0)
# sha256:       48a4e3eea403fa9125e4a324ebde31eab1a5f9ab8616d4c605dce017be3859d8
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e44e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [edi + n] field_40, field_44, field_48; [esi + n] field_2, field_a, field_c, field_12, field_14
# callees:      calls FUN_00525371, KERNEL32.dll!FindResourceA, KERNEL32.dll!LoadResource, KERNEL32.dll!LockResource
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2, 0x2  # offset +0x2
.equ field_a, 0xa  # offset +0xa
.equ field_c, 0xc  # offset +0xc
.equ field_12, 0x12  # offset +0x12
.equ field_14, 0x14  # offset +0x14
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051e44e - 0x401000
.globl FUN_0051e44e
FUN_0051e44e:
    # block 0x0051e44e: entry, 7 instruction(s), ends with je to 0x0051e47c (forward)
    push esi                                     # 0051e44e
    push edi                                     # 0051e44f
    {load} mov edi, ecx                          # 0051e450
    cmp dword ptr [edi + field_40], 0x0          # 0051e452
    mov esi, dword ptr [edi + field_48]          # 0051e456
    mov eax, dword ptr [edi + field_44]          # 0051e459
    je.d8 L_0051e47c                             # 0051e45c
    # block 0x0051e45e: entered by fall-through of je at 0x0051e45c, 11 instruction(s), calls FUN_00525371, KERNEL32.dll!FindResourceA, KERNEL32.dll!LoadResource, falls into the block at 0x0051e47c
    push ebx                                     # 0051e45e
    call FUN_00525371                            # 0051e45f
    mov ebx, dword ptr [eax + field_c]           # 0051e464
    push 0x5                                     # 0051e467
    push dword ptr [edi + field_40]              # 0051e469
    push ebx                                     # 0051e46c
    call dword ptr [0x52a218]                    # 0051e46d
    push eax                                     # 0051e473
    push ebx                                     # 0051e474
    call dword ptr [0x52a21c]                    # 0051e475
    pop ebx                                      # 0051e47b
L_0051e47c:
    # block 0x0051e47c: entered by je at 0x0051e45c, 2 instruction(s), ends with je to 0x0051e489 (forward)
    test eax, eax                                # 0051e47c
    je.d8 L_0051e489                             # 0051e47e
    # block 0x0051e480: entered by fall-through of je at 0x0051e47e, 3 instruction(s), calls KERNEL32.dll!LockResource, falls into the block at 0x0051e489
    push eax                                     # 0051e480
    call dword ptr [0x52a220]                    # 0051e481
    {load} mov esi, eax                          # 0051e487
L_0051e489:
    # block 0x0051e489: entered by je at 0x0051e47e, 4 instruction(s), ends with je to 0x0051e4c7 (forward)
    push 0x1                                     # 0051e489
    test esi, esi                                # 0051e48b
    pop eax                                      # 0051e48d
    je.d8 L_0051e4c7                             # 0051e48e
    # block 0x0051e490: entered by fall-through of je at 0x0051e48e, 3 instruction(s), ends with jne to 0x0051e4a7 (forward)
    .insn 0x6681/7, dword ptr [esi + field_2], -1{:s16} # 0051e490
    mov ecx, dword ptr [esi]                     # 0051e496
    jne.d8 L_0051e4a7                            # 0051e498
    # block 0x0051e49a: entered by fall-through of jne at 0x0051e498, 4 instruction(s), ends with forward jump to 0x0051e4af
    mov ecx, dword ptr [esi + field_c]           # 0051e49a
    mov ax, word ptr [esi + field_12]            # 0051e49d
    mov si, word ptr [esi + field_14]            # 0051e4a1
    jmp.d8 L_0051e4af                            # 0051e4a5
L_0051e4a7:
    # block 0x0051e4a7: entered by jne at 0x0051e498, 2 instruction(s), falls into the block at 0x0051e4af
    mov ax, word ptr [esi + field_a]             # 0051e4a7
    mov si, word ptr [esi + field_c]             # 0051e4ab
L_0051e4af:
    # block 0x0051e4af: entered by jmp at 0x0051e4a5, 2 instruction(s), ends with jne to 0x0051e4c5 (forward)
    test cx, 0x1801                              # 0051e4af
    jne.d8 L_0051e4c5                            # 0051e4b4
    # block 0x0051e4b6: entered by fall-through of jne at 0x0051e4b4, 2 instruction(s), ends with jne to 0x0051e4c5 (forward)
    test ax, ax                                  # 0051e4b6
    jne.d8 L_0051e4c5                            # 0051e4b9
    # block 0x0051e4bb: entered by fall-through of jne at 0x0051e4b9, 2 instruction(s), ends with jne to 0x0051e4c5 (forward)
    test si, si                                  # 0051e4bb
    jne.d8 L_0051e4c5                            # 0051e4be
    # block 0x0051e4c0: entered by fall-through of jne at 0x0051e4be, 3 instruction(s), ends with forward jump to 0x0051e4c7
    push 0x1                                     # 0051e4c0
    pop eax                                      # 0051e4c2
    jmp.d8 L_0051e4c7                            # 0051e4c3
L_0051e4c5:
    # block 0x0051e4c5: entered by jne at 0x0051e4b4; jne at 0x0051e4b9; jne at 0x0051e4be, 1 instruction(s), falls into the block at 0x0051e4c7
    {load} xor eax, eax                          # 0051e4c5
L_0051e4c7:
    # block 0x0051e4c7: entered by je at 0x0051e48e; jmp at 0x0051e4c3, 3 instruction(s), ends with ret
    pop edi                                      # 0051e4c7
    pop esi                                      # 0051e4c8
    ret                                          # 0051e4c9

