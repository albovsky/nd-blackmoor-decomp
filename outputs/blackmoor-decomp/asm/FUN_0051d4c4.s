# FUN_0051d4c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d4c4
# extent:       0x0051d4c4-0x0051d4f3 (47 code bytes)
# span:         0x0051d4c4-0x0051d4f3 (code 47, tables 0, padding 0)
# sha256:       9d8ebff4684900e181ccd841f54e5866919fa2710d35cbb77615c7207a6b67c2
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d4c4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_34; [edx + n] field_84; [esp + n] stk_8
# callees:      calls USER32.dll!SetDlgItemTextA; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_34, 0x34  # offset +0x34
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------

.org 0x0051d4c4 - 0x401000
.globl FUN_0051d4c4
FUN_0051d4c4:
    # block 0x0051d4c4: entry, 3 instruction(s), ends with jne to 0x0051d4de (forward)
    mov eax, dword ptr [ecx + field_34]          # 0051d4c4
    test eax, eax                                # 0051d4c7
    jne.d8 L_0051d4de                            # 0051d4c9
    # block 0x0051d4cb: entered by fall-through of jne at 0x0051d4c9, 5 instruction(s), calls USER32.dll!SetDlgItemTextA, ends with forward jump to 0x0051d4f0
    push dword ptr [esp + stk_8]                 # 0051d4cb
    push dword ptr [esp + stk_8]                 # 0051d4cf
    push dword ptr [ecx + field_1c]              # 0051d4d3
    call dword ptr [0x52a320]                    # 0051d4d6
    jmp.d8 L_0051d4f0                            # 0051d4dc
L_0051d4de:
    # block 0x0051d4de: entered by jne at 0x0051d4c9, 5 instruction(s), calls indirect dword ptr [edx + 0x84], falls into the block at 0x0051d4f0
    push dword ptr [esp + stk_8]                 # 0051d4de
    mov edx, dword ptr [eax]                     # 0051d4e2
    {load} mov ecx, eax                          # 0051d4e4
    push dword ptr [esp + stk_8]                 # 0051d4e6
    call dword ptr [edx + field_84]              # 0051d4ea
L_0051d4f0:
    # block 0x0051d4f0: entered by jmp at 0x0051d4dc, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 0051d4f0

