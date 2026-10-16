# FUN_0051d4f3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d4f3
# extent:       0x0051d4f3-0x0051d526 (51 code bytes)
# span:         0x0051d4f3-0x0051d526 (code 51, tables 0, padding 0)
# sha256:       8d755af8bca77201bdcadf939d3821d1164e621bc9b49211417a7f930aca4bb9
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d4f3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1038; [edx + n] field_24; [esi + n] field_1c, field_25; [esp + n] stk_8
# callees:      calls FUN_00525371, USER32.dll!IsDialogMessageA; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_24, 0x24  # offset +0x24
.equ field_25, 0x25  # offset +0x25
.equ field_1038, 0x1038  # offset +0x1038

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051d4f3 - 0x401000
.globl FUN_0051d4f3
FUN_0051d4f3:
    # block 0x0051d4f3: entry, 4 instruction(s), ends with je to 0x0051d515 (forward)
    push esi                                     # 0051d4f3
    {load} mov esi, ecx                          # 0051d4f4
    test byte ptr [esi + field_25], 0x1          # 0051d4f6
    je.d8 L_0051d515                             # 0051d4fa
    # block 0x0051d4fc: entered by fall-through of je at 0x0051d4fa, 8 instruction(s), calls FUN_00525371, indirect dword ptr [edx + 0x24], ends with forward jump to 0x0051d522
    call FUN_00525371                            # 0051d4fc
    mov eax, dword ptr [eax + field_1038]        # 0051d501
    push dword ptr [esp + stk_8]                 # 0051d507
    {load} mov ecx, eax                          # 0051d50b
    mov edx, dword ptr [eax]                     # 0051d50d
    push esi                                     # 0051d50f
    call dword ptr [edx + field_24]              # 0051d510
    jmp.d8 L_0051d522                            # 0051d513
L_0051d515:
    # block 0x0051d515: entered by je at 0x0051d4fa, 3 instruction(s), calls USER32.dll!IsDialogMessageA, falls into the block at 0x0051d522
    push dword ptr [esp + stk_8]                 # 0051d515
    push dword ptr [esi + field_1c]              # 0051d519
    call dword ptr [0x52a324]                    # 0051d51c
L_0051d522:
    # block 0x0051d522: entered by jmp at 0x0051d513, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051d522
    ret 0x4                                      # 0051d523

