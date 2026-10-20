# FUN_00520fd4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520fd4
# extent:       0x00520fd4-0x00520ffe (42 code bytes)
# span:         0x00520fd4-0x00520ffe (code 42, tables 0, padding 0)
# sha256:       eb0e91acbf161c4ba2fb70c9a207741f84ba03992bbb3a77457c03bc96fa0d5a
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Detach
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_4
# callees:      calls FUN_00520f4d, FUN_0051a601
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051a601, .text + (0x0051a601 - 0x401000)
.set FUN_00520f4d, .text + (0x00520f4d - 0x401000)

.org 0x00520fd4 - 0x401000
.globl FUN_00520fd4
FUN_00520fd4:
    # block 0x00520fd4: entry, 6 instruction(s), ends with je to 0x00520ff5 (forward)
    push esi                                     # 00520fd4
    {load} mov esi, ecx                          # 00520fd5
    push edi                                     # 00520fd7
    mov edi, dword ptr [esi + field_4]           # 00520fd8
    test edi, edi                                # 00520fdb
    je.d8 L_00520ff5                             # 00520fdd
    # block 0x00520fdf: entered by fall-through of je at 0x00520fdd, 4 instruction(s), calls FUN_00520f4d, ends with je to 0x00520ff5 (forward)
    push 0x0                                     # 00520fdf
    call FUN_00520f4d                            # 00520fe1
    test eax, eax                                # 00520fe6
    je.d8 L_00520ff5                             # 00520fe8
    # block 0x00520fea: entered by fall-through of je at 0x00520fe8, 3 instruction(s), calls FUN_0051a601, falls into the block at 0x00520ff5
    push dword ptr [esi + field_4]               # 00520fea
    lea ecx, [eax + field_4]                     # 00520fed
    call FUN_0051a601                            # 00520ff0
L_00520ff5:
    # block 0x00520ff5: entered by je at 0x00520fdd; je at 0x00520fe8, 5 instruction(s), ends with ret
    and dword ptr [esi + field_4], 0x0           # 00520ff5
    {load} mov eax, edi                          # 00520ff9
    pop edi                                      # 00520ffb
    pop esi                                      # 00520ffc
    ret                                          # 00520ffd

