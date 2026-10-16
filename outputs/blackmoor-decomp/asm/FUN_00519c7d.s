# FUN_00519c7d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519c7d
# extent:       0x00519c7d-0x00519cc0 (67 code bytes)
# span:         0x00519c7d-0x00519cc0 (code 67, tables 0, padding 0)
# sha256:       6d46a31dc674a98f6e9040e9c8403d35d6d19e12a3daa8a0e352c82ae6cce28c
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00519c54 (+0x29)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519c7d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_c, field_10, field_14; [esp + n] stk_8, stk_c, stk_10
# callees:      calls FUN_00519c54, KERNEL32.dll!lstrcpynA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ stk_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00519c54, .text + (0x00519c54 - 0x401000)

.org 0x00519c7d - 0x401000
.globl FUN_00519c7d
FUN_00519c7d:
    # block 0x00519c7d: entry, 5 instruction(s), ends with je to 0x00519c8b (forward)
    mov eax, dword ptr [esp + stk_c]             # 00519c7d
    push esi                                     # 00519c81
    test eax, eax                                # 00519c82
    {load} mov esi, ecx                          # 00519c84
    je.d8 L_00519c8b                             # 00519c86
    # block 0x00519c88: entered by fall-through of je at 0x00519c86, 1 instruction(s), falls into the block at 0x00519c8b
    and dword ptr [eax], 0x0                     # 00519c88
L_00519c8b:
    # block 0x00519c8b: entered by je at 0x00519c86, 2 instruction(s), ends with jne to 0x00519c98 (forward)
    cmp dword ptr [esi + field_c], 0x0           # 00519c8b
    jne.d8 L_00519c98                            # 00519c8f
    # block 0x00519c91: entered by fall-through of jne at 0x00519c8f, 2 instruction(s), calls FUN_00519c54, falls into the block at 0x00519c98
    {load} mov ecx, esi                          # 00519c91
    call FUN_00519c54                            # 00519c93
L_00519c98:
    # block 0x00519c98: entered by jne at 0x00519c8f, 2 instruction(s), ends with je to 0x00519cb2 (forward)
    cmp dword ptr [esi + field_10], 0x0          # 00519c98
    je.d8 L_00519cb2                             # 00519c9c
    # block 0x00519c9e: entered by fall-through of je at 0x00519c9c, 6 instruction(s), calls KERNEL32.dll!lstrcpynA, ends with forward jump to 0x00519cb9
    push dword ptr [esp + stk_c]                 # 00519c9e
    lea eax, [esi + field_14]                    # 00519ca2
    push eax                                     # 00519ca5
    push dword ptr [esp + stk_10]                # 00519ca6
    call dword ptr [0x52a1d4]                    # 00519caa
    jmp.d8 L_00519cb9                            # 00519cb0
L_00519cb2:
    # block 0x00519cb2: entered by je at 0x00519c9c, 2 instruction(s), falls into the block at 0x00519cb9
    mov eax, dword ptr [esp + stk_8]             # 00519cb2
    and byte ptr [eax], 0x0                      # 00519cb6
L_00519cb9:
    # block 0x00519cb9: entered by jmp at 0x00519cb0, 3 instruction(s), ends with ret 0xc
    mov eax, dword ptr [esi + field_10]          # 00519cb9
    pop esi                                      # 00519cbc
    ret 0xc                                      # 00519cbd

