# FUN_0051d55a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d55a
# extent:       0x0051d55a-0x0051d58b (49 code bytes)
# span:         0x0051d55a-0x0051d58b (code 49, tables 0, padding 0)
# sha256:       0327faba21a2aa10a0b8ece35efeb23226c6ce4727a1ceec2387dd38d3505610
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d55a
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none: no [ebp-n] slot referenced
# fields:       [ecx + n] field_1c, field_38; [edx + n] field_7c
# callees:      calls FUN_0051a896; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_7c, 0x7c  # offset +0x7c

# --- external targets -----------------------------------------------
.set FUN_0051a896, .text + (0x0051a896 - 0x401000)

.org 0x0051d55a - 0x401000
.globl FUN_0051d55a
FUN_0051d55a:
    # block 0x0051d55a: entry, 5 instruction(s), ends with jne to 0x0051d577 (forward)
    push ebp                                     # 0051d55a
    {load} mov ebp, esp                          # 0051d55b
    mov eax, dword ptr [ecx + field_38]          # 0051d55d
    test eax, eax                                # 0051d560
    jne.d8 L_0051d577                            # 0051d562
    # block 0x0051d564: entered by fall-through of jne at 0x0051d562, 6 instruction(s), calls FUN_0051a896, ends with forward jump to 0x0051d587
    push dword ptr [ebp + arg_10]                # 0051d564
    push dword ptr [ebp + arg_c]                 # 0051d567
    push dword ptr [ebp + arg_8]                 # 0051d56a
    push dword ptr [ecx + field_1c]              # 0051d56d
    call FUN_0051a896                            # 0051d570
    jmp.d8 L_0051d587                            # 0051d575
L_0051d577:
    # block 0x0051d577: entered by jne at 0x0051d562, 6 instruction(s), calls indirect dword ptr [edx + 0x7c], falls into the block at 0x0051d587
    push dword ptr [ebp + arg_10]                # 0051d577
    mov edx, dword ptr [eax]                     # 0051d57a
    {load} mov ecx, eax                          # 0051d57c
    push dword ptr [ebp + arg_c]                 # 0051d57e
    push dword ptr [ebp + arg_8]                 # 0051d581
    call dword ptr [edx + field_7c]              # 0051d584
L_0051d587:
    # block 0x0051d587: entered by jmp at 0x0051d575, 2 instruction(s), ends with ret 0xc
    pop ebp                                      # 0051d587
    ret 0xc                                      # 0051d588

