# FUN_0051e42d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e42d
# extent:       0x0051e42d-0x0051e446 (25 code bytes)
# span:         0x0051e42d-0x0051e446 (code 25, tables 0, padding 0)
# sha256:       6e091e338fffee7581a760da67684e402b8e6b7ceae26683764331e375cfe3f8
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e42d
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051cab3, FUN_0051e2a0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0051cab3, .text + (0x0051cab3 - 0x401000)
.set FUN_0051e2a0, .text + (0x0051e2a0 - 0x401000)

.org 0x0051e42d - 0x401000
.globl FUN_0051e42d
FUN_0051e42d:
    # block 0x0051e42d: entry, 6 instruction(s), calls FUN_0051cab3, ends with je to 0x0051e444 (forward)
    push esi                                     # 0051e42d
    {load} mov esi, ecx                          # 0051e42e
    push 0x1                                     # 0051e430
    call FUN_0051cab3                            # 0051e432
    test eax, eax                                # 0051e437
    je.d8 L_0051e444                             # 0051e439
    # block 0x0051e43b: entered by fall-through of je at 0x0051e439, 3 instruction(s), calls FUN_0051e2a0, falls into the block at 0x0051e444
    push 0x1                                     # 0051e43b
    {load} mov ecx, esi                          # 0051e43d
    call FUN_0051e2a0                            # 0051e43f
L_0051e444:
    # block 0x0051e444: entered by je at 0x0051e439, 2 instruction(s), ends with ret
    pop esi                                      # 0051e444
    ret                                          # 0051e445

