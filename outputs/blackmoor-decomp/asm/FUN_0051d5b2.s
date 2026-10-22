# FUN_0051d5b2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d5b2
# extent:       0x0051d5b2-0x0051d5e1 (47 code bytes)
# span:         0x0051d5b2-0x0051d5e1 (code 47, tables 0, padding 0)
# sha256:       243b41bab0c60604f8d2d7d463e727d81187787f9d2aa6f6c0916d8958c6cdf6
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d5b2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_38; [edx + n] field_84; [esp + n] stk_8
# callees:      calls USER32.dll!GetWindowTextA; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------

.org 0x0051d5b2 - 0x401000
.globl FUN_0051d5b2
FUN_0051d5b2:
    # block 0x0051d5b2: entry, 3 instruction(s), ends with jne to 0x0051d5cc (forward)
    mov eax, dword ptr [ecx + field_38]          # 0051d5b2
    test eax, eax                                # 0051d5b5
    jne.d8 L_0051d5cc                            # 0051d5b7
    # block 0x0051d5b9: entered by fall-through of jne at 0x0051d5b7, 5 instruction(s), calls USER32.dll!GetWindowTextA, ends with forward jump to 0x0051d5de
    push dword ptr [esp + stk_8]                 # 0051d5b9
    push dword ptr [esp + stk_8]                 # 0051d5bd
    push dword ptr [ecx + field_1c]              # 0051d5c1
    call dword ptr [0x52a408]                    # 0051d5c4
    jmp.d8 L_0051d5de                            # 0051d5ca
L_0051d5cc:
    # block 0x0051d5cc: entered by jne at 0x0051d5b7, 5 instruction(s), calls indirect dword ptr [edx + 0x84], falls into the block at 0x0051d5de
    push dword ptr [esp + stk_8]                 # 0051d5cc
    mov edx, dword ptr [eax]                     # 0051d5d0
    {load} mov ecx, eax                          # 0051d5d2
    push dword ptr [esp + stk_8]                 # 0051d5d4
    call dword ptr [edx + field_84]              # 0051d5d8
L_0051d5de:
    # block 0x0051d5de: entered by jmp at 0x0051d5ca, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 0051d5de

