# FUN_0051eb41
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051eb41
# extent:       0x0051eb41-0x0051ebc8 (135 code bytes)
# span:         0x0051eb41-0x0051ebc8 (code 135, tables 0, padding 0)
# sha256:       48f0411d227681a916936c0d028e08678fd9bf893cb4598556e5f96c8200e179
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051eb41
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; no ret instruction in the code part; ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c, field_1070; [ebp + n] field_8, field_minus_4, field_minus_10, field_minus_14, field_minus_50; [ecx + n] field_4; [edi + n] field_4; [esi + n] field_1c
# callees:      calls FUN_0050f978, FUN_0051a7c3, FUN_0052513f, FUN_00525371, FUN_00525b0f, FUN_0051ecc9, FUN_0051ac29, tail jump FUN_0051ebf8
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 42 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_50, 0x50  # offset -0x50
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1070, 0x1070  # offset +0x1070

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a7c3, .text + (0x0051a7c3 - 0x401000)
.set FUN_0051ac29, .text + (0x0051ac29 - 0x401000)
.set FUN_0051ebf8, .text + (0x0051ebf8 - 0x401000)
.set FUN_0051ecc9, .text + (0x0051ecc9 - 0x401000)
.set FUN_0052513f, .text + (0x0052513f - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051eb41 - 0x401000
.globl FUN_0051eb41
FUN_0051eb41:
    # block 0x0051eb41: entry, 29 instruction(s), calls FUN_0050f978, FUN_0051a7c3, FUN_0052513f, FUN_00525371, FUN_00525b0f, FUN_0051ecc9, ends with je to 0x0051ebf8 (forward)
    mov eax, 0x528da0                            # 0051eb41
    call FUN_0050f978                            # 0051eb46
    sub esp, 0x48                                # 0051eb4b
    push ebx                                     # 0051eb4e
    push esi                                     # 0051eb4f
    push edi                                     # 0051eb50
    mov edi, dword ptr [ebp + field_8]           # 0051eb51
    lea ecx, [ebp - field_minus_50]              # 0051eb54
    mov dword ptr [ebp - field_minus_10], esp    # 0051eb57
    mov esi, dword ptr [edi + field_4]           # 0051eb5a
    mov dword ptr [ebp - field_minus_14], esi    # 0051eb5d
    call FUN_0051a7c3                            # 0051eb60
    {load} xor ebx, ebx                          # 0051eb65
    mov dword ptr [ebp - field_minus_4], ebx     # 0051eb67
    mov byte ptr [ebp - field_minus_4], 0x1      # 0051eb6a
    call FUN_0052513f                            # 0051eb6e
    mov ecx, dword ptr [edi]                     # 0051eb73
    mov ecx, dword ptr [ecx + field_4]           # 0051eb75
    mov dword ptr [eax + field_4], ecx           # 0051eb78
    call FUN_00525371                            # 0051eb7b
    push 0x524bd4                                # 0051eb80
    lea ecx, [eax + field_1070]                  # 0051eb85
    call FUN_00525b0f                            # 0051eb8b
    mov dword ptr [eax + field_4], esi           # 0051eb90
    call FUN_0051ecc9                            # 0051eb93
    call FUN_00525371                            # 0051eb98
    mov eax, dword ptr [eax + field_4]           # 0051eb9d
    {load} cmp eax, ebx                          # 0051eba0
    je.d8 . + (86)  # -> FUN_0051ebf8            # 0051eba2
    # block 0x0051eba4: entered by fall-through of je at 0x0051eba2, 2 instruction(s), ends with jne to 0x0051ebf8 (forward)
    cmp dword ptr [esi + field_1c], ebx          # 0051eba4
    jne.d8 . + (81)  # -> FUN_0051ebf8           # 0051eba7
    # block 0x0051eba9: entered by fall-through of jne at 0x0051eba7, 3 instruction(s), ends with je to 0x0051ebf8 (forward)
    mov eax, dword ptr [eax + field_1c]          # 0051eba9
    {load} cmp eax, ebx                          # 0051ebac
    je.d8 . + (74)  # -> FUN_0051ebf8            # 0051ebae
    # block 0x0051ebb0: entered by fall-through of je at 0x0051ebae, 2 instruction(s), ends with je to 0x0051ebf8 (forward)
    cmp dword ptr [eax + field_1c], ebx          # 0051ebb0
    je.d8 . + (69)  # -> FUN_0051ebf8            # 0051ebb3
    # block 0x0051ebb5: entered by fall-through of je at 0x0051ebb3, 6 instruction(s), calls FUN_0051ac29, ends with forward jump to 0x0051ebf8
    push dword ptr [eax + field_1c]              # 0051ebb5
    lea ecx, [ebp - field_minus_50]              # 0051ebb8
    call FUN_0051ac29                            # 0051ebbb
    lea eax, [ebp - field_minus_50]              # 0051ebc0
    mov dword ptr [esi + field_1c], eax          # 0051ebc3
    jmp.d8 . + (50)  # -> FUN_0051ebf8           # 0051ebc6

