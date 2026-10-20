# FUN_0051ac62
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ac62
# extent:       0x0051ac62-0x0051ac90 (46 code bytes)
# span:         0x0051ac62-0x0051ac90 (code 46, tables 0, padding 0)
# sha256:       b25a60566c61a3f837da8e5bc0fbccb3f1c4ec6f7425f248c69f1e63b084af10
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CWnd::Detach
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_1c, field_38
# callees:      calls FUN_0051ab72, FUN_0051a601
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0051ac90
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_38, 0x38  # offset +0x38

# --- external targets -----------------------------------------------
.set FUN_0051a601, .text + (0x0051a601 - 0x401000)
.set FUN_0051ab72, .text + (0x0051ab72 - 0x401000)

.org 0x0051ac62 - 0x401000
.globl FUN_0051ac62
FUN_0051ac62:
    # block 0x0051ac62: entry, 6 instruction(s), ends with je to 0x0051ac87 (forward)
    push esi                                     # 0051ac62
    {load} mov esi, ecx                          # 0051ac63
    push edi                                     # 0051ac65
    mov edi, dword ptr [esi + field_1c]          # 0051ac66
    test edi, edi                                # 0051ac69
    je.d8 L_0051ac87                             # 0051ac6b
    # block 0x0051ac6d: entered by fall-through of je at 0x0051ac6b, 4 instruction(s), calls FUN_0051ab72, ends with je to 0x0051ac83 (forward)
    push 0x0                                     # 0051ac6d
    call FUN_0051ab72                            # 0051ac6f
    test eax, eax                                # 0051ac74
    je.d8 L_0051ac83                             # 0051ac76
    # block 0x0051ac78: entered by fall-through of je at 0x0051ac76, 3 instruction(s), calls FUN_0051a601, falls into the block at 0x0051ac83
    push dword ptr [esi + field_1c]              # 0051ac78
    lea ecx, [eax + field_4]                     # 0051ac7b
    call FUN_0051a601                            # 0051ac7e
L_0051ac83:
    # block 0x0051ac83: entered by je at 0x0051ac76, 1 instruction(s), falls into the block at 0x0051ac87
    and dword ptr [esi + field_1c], 0x0          # 0051ac83
L_0051ac87:
    # block 0x0051ac87: entered by je at 0x0051ac6b, 5 instruction(s), ends with ret
    and dword ptr [esi + field_38], 0x0          # 0051ac87
    {load} mov eax, edi                          # 0051ac8b
    pop edi                                      # 0051ac8d
    pop esi                                      # 0051ac8e
    ret                                          # 0051ac8f

