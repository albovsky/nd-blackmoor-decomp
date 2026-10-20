# FUN_0051fa6a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fa6a
# extent:       0x0051fa6a-0x0051fa94 (42 code bytes)
# span:         0x0051fa6a-0x0051fa94 (code 42, tables 0, padding 0)
# sha256:       e55ac808bbea25dbb07f8bdedd5b854e1e9e2ad1c26904146f56b17b358b3679
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         Detach
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_4
# callees:      calls FUN_0051f9c5, FUN_0051a601
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051a601, .text + (0x0051a601 - 0x401000)
.set FUN_0051f9c5, .text + (0x0051f9c5 - 0x401000)

.org 0x0051fa6a - 0x401000
.globl FUN_0051fa6a
FUN_0051fa6a:
    # block 0x0051fa6a: entry, 6 instruction(s), ends with je to 0x0051fa8b (forward)
    push esi                                     # 0051fa6a
    {load} mov esi, ecx                          # 0051fa6b
    push edi                                     # 0051fa6d
    mov edi, dword ptr [esi + field_4]           # 0051fa6e
    test edi, edi                                # 0051fa71
    je.d8 L_0051fa8b                             # 0051fa73
    # block 0x0051fa75: entered by fall-through of je at 0x0051fa73, 4 instruction(s), calls FUN_0051f9c5, ends with je to 0x0051fa8b (forward)
    push 0x0                                     # 0051fa75
    call FUN_0051f9c5                            # 0051fa77
    test eax, eax                                # 0051fa7c
    je.d8 L_0051fa8b                             # 0051fa7e
    # block 0x0051fa80: entered by fall-through of je at 0x0051fa7e, 3 instruction(s), calls FUN_0051a601, falls into the block at 0x0051fa8b
    push dword ptr [esi + field_4]               # 0051fa80
    lea ecx, [eax + field_4]                     # 0051fa83
    call FUN_0051a601                            # 0051fa86
L_0051fa8b:
    # block 0x0051fa8b: entered by je at 0x0051fa73; je at 0x0051fa7e, 5 instruction(s), ends with ret
    and dword ptr [esi + field_4], 0x0           # 0051fa8b
    {load} mov eax, edi                          # 0051fa8f
    pop edi                                      # 0051fa91
    pop esi                                      # 0051fa92
    ret                                          # 0051fa93

