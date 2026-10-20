# FUN_0051eac4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051eac4
# extent:       0x0051eac4-0x0051eaec (40 code bytes)
# span:         0x0051eac4-0x0051eaec (code 40, tables 0, padding 0)
# sha256:       6de306f88d4356dbf89d11458ca912e933c13893d041ffc1c4a1d8bc88eea715
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051eac4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_minus_8; [esp + n] stk_8
# callees:      calls FUN_0051e763, KERNEL32.dll!lstrlenA
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl19b.c:m41f986_init_strings (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0051e763, .text + (0x0051e763 - 0x401000)

.org 0x0051eac4 - 0x401000
.globl FUN_0051eac4
FUN_0051eac4:
    # block 0x0051eac4: entry, 6 instruction(s), calls FUN_0051e763, ends with jne to 0x0051eadd (forward)
    push esi                                     # 0051eac4
    {load} mov esi, ecx                          # 0051eac5
    call FUN_0051e763                            # 0051eac7
    mov eax, dword ptr [esp + stk_8]             # 0051eacc
    cmp eax, -0x1                                # 0051ead0
    jne.d8 L_0051eadd                            # 0051ead3
    # block 0x0051ead5: entered by fall-through of jne at 0x0051ead3, 2 instruction(s), calls KERNEL32.dll!lstrlenA, falls into the block at 0x0051eadd
    push dword ptr [esi]                         # 0051ead5
    call dword ptr [0x52a1f8]                    # 0051ead7
L_0051eadd:
    # block 0x0051eadd: entered by jne at 0x0051ead3, 6 instruction(s), ends with ret 0x4
    mov ecx, dword ptr [esi]                     # 0051eadd
    mov dword ptr [ecx - field_minus_8], eax     # 0051eadf
    mov ecx, dword ptr [esi]                     # 0051eae2
    pop esi                                      # 0051eae4
    and byte ptr [ecx + eax], 0x0                # 0051eae5
    ret 0x4                                      # 0051eae9

