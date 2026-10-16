# FUN_0051a3f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a3f4
# extent:       0x0051a3f4-0x0051a40a (22 code bytes)
# span:         0x0051a3f4-0x0051a40a (code 22, tables 0, padding 0)
# sha256:       80f59a3129612fe4eafaf646f280451a97f792eac218c6f46f692fb3d7eb55ba
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a3f4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0051a3f4 - 0x401000
.globl FUN_0051a3f4
FUN_0051a3f4:
    # block 0x0051a3f4: entry, 2 instruction(s), ends with je to 0x0051a409 (forward)
    test ecx, ecx                                # 0051a3f4
    je.d8 L_0051a409                             # 0051a3f6
    # block 0x0051a3f8: entered by fall-through of je at 0x0051a3f6, 1 instruction(s), falls into the block at 0x0051a3f9
    push esi                                     # 0051a3f8
L_0051a3f9:
    # block 0x0051a3f9: entered by jne at 0x0051a406, 7 instruction(s), calls FUN_0051dc6c, ends with jne to 0x0051a3f9 (backward)
    mov esi, dword ptr [ecx]                     # 0051a3f9
    push ecx                                     # 0051a3fb
    call FUN_0051dc6c                            # 0051a3fc
    pop ecx                                      # 0051a401
    test esi, esi                                # 0051a402
    {load} mov ecx, esi                          # 0051a404
    jne.d8 L_0051a3f9                            # 0051a406
    # block 0x0051a408: entered by fall-through of jne at 0x0051a406, 1 instruction(s), falls into the block at 0x0051a409
    pop esi                                      # 0051a408
L_0051a409:
    # block 0x0051a409: entered by je at 0x0051a3f6, 1 instruction(s), ends with ret
    ret                                          # 0051a409

