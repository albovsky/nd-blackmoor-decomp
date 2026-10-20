# FUN_00519e49
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519e49
# extent:       0x00519e49-0x00519e77 (46 code bytes)
# span:         0x00519e49-0x00519e77 (code 46, tables 0, padding 0)
# sha256:       58f8cdc07b43f44798b9a282d8d00d862593fe7923b6d2c371185e1f6b9cf4aa
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CPrintDialog::DoModal
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esi + n] field_5c
# callees:      calls FUN_0051e0c4, FUN_00519a3c, FUN_0051e0fe
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_00519a3c, .text + (0x00519a3c - 0x401000)
.set FUN_0051e0c4, .text + (0x0051e0c4 - 0x401000)
.set FUN_0051e0fe, .text + (0x0051e0fe - 0x401000)

.org 0x00519e49 - 0x401000
.globl FUN_00519e49
FUN_00519e49:
    # block 0x00519e49: entry, 13 instruction(s), calls FUN_0051e0c4, FUN_00519a3c, FUN_0051e0fe, ends with je to 0x00519e71 (forward)
    push esi                                     # 00519e49
    push edi                                     # 00519e4a
    {load} mov esi, ecx                          # 00519e4b
    call FUN_0051e0c4                            # 00519e4d
    mov ecx, dword ptr [esi + field_5c]          # 00519e52
    mov dword ptr [ecx + field_4], eax           # 00519e55
    push dword ptr [esi + field_5c]              # 00519e58
    call FUN_00519a3c                            # 00519e5b
    {load} mov ecx, esi                          # 00519e60
    {load} mov edi, eax                          # 00519e62
    call FUN_0051e0fe                            # 00519e64
    test edi, edi                                # 00519e69
    je.d8 L_00519e71                             # 00519e6b
    # block 0x00519e6d: entered by fall-through of je at 0x00519e6b, 2 instruction(s), ends with forward jump to 0x00519e74
    {load} mov eax, edi                          # 00519e6d
    jmp.d8 L_00519e74                            # 00519e6f
L_00519e71:
    # block 0x00519e71: entered by je at 0x00519e6b, 2 instruction(s), falls into the block at 0x00519e74
    push 0x2                                     # 00519e71
    pop eax                                      # 00519e73
L_00519e74:
    # block 0x00519e74: entered by jmp at 0x00519e6f, 3 instruction(s), ends with ret
    pop edi                                      # 00519e74
    pop esi                                      # 00519e75
    ret                                          # 00519e76

