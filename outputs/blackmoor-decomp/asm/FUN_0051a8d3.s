# FUN_0051a8d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a8d3
# extent:       0x0051a8d3-0x0051a94c (121 code bytes)
# span:         0x0051a8d3-0x0051a94c (code 121, tables 0, padding 0)
# sha256:       de0bcb30e3db5a46aad25c199074545f647fe4cf471f37e18b55af645ce9f4f7
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a8d3
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_13; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_c, local_10
# fields:       [eax + n] field_4, field_ac; [esi + n] field_1c
# callees:      calls FUN_0051d526, USER32.dll!GetWindowRect, USER32.dll!GetWindow, FUN_0051abe4, FUN_0051d657, FUN_0051cb6b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 7 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_13, 0x13  # offset +0x13
.equ field_1c, 0x1c  # offset +0x1c
.equ field_ac, 0xac  # offset +0xac

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_0051cb6b, .text + (0x0051cb6b - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051d657, .text + (0x0051d657 - 0x401000)

.org 0x0051a8d3 - 0x401000
.globl FUN_0051a8d3
FUN_0051a8d3:
    # block 0x0051a8d3: entry, 6 instruction(s), ends with jne to 0x0051a947 (forward)
    push ebp                                     # 0051a8d3
    {load} mov ebp, esp                          # 0051a8d4
    sub esp, 0x10                                # 0051a8d6
    test byte ptr [ebp + arg_13], 0x10           # 0051a8d9
    push esi                                     # 0051a8dd
    jne.d8 L_0051a947                            # 0051a8de
    # block 0x0051a8e0: entered by fall-through of jne at 0x0051a8de, 5 instruction(s), calls FUN_0051d526, ends with jne to 0x0051a947 (forward)
    mov esi, dword ptr [ebp + arg_8]             # 0051a8e0
    {load} mov ecx, esi                          # 0051a8e3
    call FUN_0051d526                            # 0051a8e5
    test eax, 0x50000000                         # 0051a8ea
    jne.d8 L_0051a947                            # 0051a8ef
    # block 0x0051a8f1: entered by fall-through of jne at 0x0051a8ef, 8 instruction(s), calls USER32.dll!GetWindowRect, ends with jne to 0x0051a947 (forward)
    lea eax, [ebp - local_10]                    # 0051a8f1
    push eax                                     # 0051a8f4
    push dword ptr [esi + field_1c]              # 0051a8f5
    call dword ptr [0x52a46c]                    # 0051a8f8
    mov eax, dword ptr [ebp + arg_c]             # 0051a8fe
    mov ecx, dword ptr [eax]                     # 0051a901
    cmp ecx, dword ptr [ebp - local_10]          # 0051a903
    jne.d8 L_0051a947                            # 0051a906
    # block 0x0051a908: entered by fall-through of jne at 0x0051a906, 3 instruction(s), ends with jne to 0x0051a947 (forward)
    mov eax, dword ptr [eax + field_4]           # 0051a908
    cmp eax, dword ptr [ebp - local_c]           # 0051a90b
    jne.d8 L_0051a947                            # 0051a90e
    # block 0x0051a910: entered by fall-through of jne at 0x0051a90e, 7 instruction(s), calls USER32.dll!GetWindow, FUN_0051abe4, ends with je to 0x0051a930 (forward)
    push 0x4                                     # 0051a910
    push dword ptr [esi + field_1c]              # 0051a912
    call dword ptr [0x52a450]                    # 0051a915
    push eax                                     # 0051a91b
    call FUN_0051abe4                            # 0051a91c
    test eax, eax                                # 0051a921
    je.d8 L_0051a930                             # 0051a923
    # block 0x0051a925: entered by fall-through of je at 0x0051a923, 4 instruction(s), calls FUN_0051d657, ends with jne to 0x0051a947 (forward)
    {load} mov ecx, eax                          # 0051a925
    call FUN_0051d657                            # 0051a927
    test eax, eax                                # 0051a92c
    jne.d8 L_0051a947                            # 0051a92e
L_0051a930:
    # block 0x0051a930: entered by je at 0x0051a923; fall-through of jne at 0x0051a92e, 5 instruction(s), calls indirect dword ptr [eax + 0xac], ends with je to 0x0051a947 (forward)
    mov eax, dword ptr [esi]                     # 0051a930
    {load} mov ecx, esi                          # 0051a932
    call dword ptr [eax + field_ac]              # 0051a934
    test eax, eax                                # 0051a93a
    je.d8 L_0051a947                             # 0051a93c
    # block 0x0051a93e: entered by fall-through of je at 0x0051a93c, 3 instruction(s), calls FUN_0051cb6b, falls into the block at 0x0051a947
    push 0x0                                     # 0051a93e
    {load} mov ecx, esi                          # 0051a940
    call FUN_0051cb6b                            # 0051a942
L_0051a947:
    # block 0x0051a947: entered by jne at 0x0051a8de; jne at 0x0051a8ef; jne at 0x0051a906; jne at 0x0051a90e; more, 3 instruction(s), ends with ret 0xc
    pop esi                                      # 0051a947
    leave                                        # 0051a948
    ret 0xc                                      # 0051a949

