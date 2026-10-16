# FUN_0050fff4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050fff4
# extent:       0x0050fff4-0x00510066 (114 code bytes)
# span:         0x0050fff4-0x00510066 (code 114, tables 0, padding 0)
# sha256:       a2651b8f2f32a147bf8d72e15056632b2b3086df07c0dad24879695ad2ca6c51
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050fff4
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       [ecx + n] field_1, field_minus_1
# callees:      calls FUN_0050db50, FUN_00512c18, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ field_1, 0x1  # offset +0x1
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050db50, .text + (0x0050db50 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x0050fff4 - 0x401000
.globl FUN_0050fff4
FUN_0050fff4:
    # block 0x0050fff4: entry, 6 instruction(s), ends with jne to 0x00510011 (forward)
    push ebp                                     # 0050fff4
    {load} mov ebp, esp                          # 0050fff5
    push esi                                     # 0050fff7
    {load} xor esi, esi                          # 0050fff8
    cmp dword ptr [0x63df1c], esi                # 0050fffa
    jne.d8 L_00510011                            # 00510000
    # block 0x00510002: entered by fall-through of jne at 0x00510000, 6 instruction(s), calls FUN_0050db50, ends with forward jump to 0x00510063
    push dword ptr [ebp + arg_c]                 # 00510002
    push dword ptr [ebp + arg_8]                 # 00510005
    call FUN_0050db50                            # 00510008
    pop ecx                                      # 0051000d
    pop ecx                                      # 0051000e
    jmp.d8 L_00510063                            # 0051000f
L_00510011:
    # block 0x00510011: entered by jne at 0x00510000, 5 instruction(s), calls FUN_00512c18, falls into the block at 0x0051001d
    push edi                                     # 00510011
    push 0x19                                    # 00510012
    call FUN_00512c18                            # 00510014
    pop ecx                                      # 00510019
    mov ecx, dword ptr [ebp + arg_8]             # 0051001a
L_0051001d:
    # block 0x0051001d: entered by jne at 0x00510056, 5 instruction(s), ends with je to 0x0051004c (forward)
    mov dl, byte ptr [ecx]                       # 0051001d
    movzx eax, dl                                # 0051001f
    movzx edi, al                                # 00510022
    test byte ptr [edi + 0x63e021], 0x4          # 00510025
    je.d8 L_0051004c                             # 0051002c
    # block 0x0051002e: entered by fall-through of je at 0x0051002c, 4 instruction(s), ends with je to 0x00510048 (forward)
    mov dl, byte ptr [ecx + field_1]             # 0051002e
    inc ecx                                      # 00510031
    test dl, dl                                  # 00510032
    je.d8 L_00510048                             # 00510034
    # block 0x00510036: entered by fall-through of je at 0x00510034, 5 instruction(s), ends with jne to 0x00510053 (forward)
    movzx edi, dl                                # 00510036
    shl eax, 0x8                                 # 00510039
    {load} or eax, edi                           # 0051003c
    cmp dword ptr [ebp + arg_c], eax             # 0051003e
    jne.d8 L_00510053                            # 00510041
    # block 0x00510043: entered by fall-through of jne at 0x00510041, 2 instruction(s), ends with forward jump to 0x00510053
    lea esi, [ecx - field_minus_1]               # 00510043
    jmp.d8 L_00510053                            # 00510046
L_00510048:
    # block 0x00510048: entered by je at 0x00510034, 2 instruction(s), ends with forward jump to 0x0051004f
    test esi, esi                                # 00510048
    jmp.d8 L_0051004f                            # 0051004a
L_0051004c:
    # block 0x0051004c: entered by je at 0x0051002c, 1 instruction(s), falls into the block at 0x0051004f
    cmp dword ptr [ebp + arg_c], eax             # 0051004c
L_0051004f:
    # block 0x0051004f: entered by jmp at 0x0051004a, 1 instruction(s), ends with jne to 0x00510053 (forward)
    jne.d8 L_00510053                            # 0051004f
    # block 0x00510051: entered by fall-through of jne at 0x0051004f, 1 instruction(s), falls into the block at 0x00510053
    {load} mov esi, ecx                          # 00510051
L_00510053:
    # block 0x00510053: entered by jne at 0x00510041; jmp at 0x00510046; jne at 0x0051004f, 3 instruction(s), ends with jne to 0x0051001d (backward)
    inc ecx                                      # 00510053
    test dl, dl                                  # 00510054
    jne.d8 L_0051001d                            # 00510056
    # block 0x00510058: entered by fall-through of jne at 0x00510056, 5 instruction(s), calls FUN_00512c79, falls into the block at 0x00510063
    push 0x19                                    # 00510058
    call FUN_00512c79                            # 0051005a
    pop ecx                                      # 0051005f
    {load} mov eax, esi                          # 00510060
    pop edi                                      # 00510062
L_00510063:
    # block 0x00510063: entered by jmp at 0x0051000f, 3 instruction(s), ends with ret
    pop esi                                      # 00510063
    pop ebp                                      # 00510064
    ret                                          # 00510065

