# FUN_0050f8d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050f8d5
# extent:       0x0050f8d5-0x0050f8fe (41 code bytes)
# span:         0x0050f8d5-0x0050f8fe (code 41, tables 0, padding 0)
# sha256:       292f9a82074bcc00bd22bb6127fc877155bff4c23ec7a62fbd1e2574d8cda398
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050f8d5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4
# callees:      calls FUN_00512c18, FUN_0050e936, FUN_00512c79
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)

.org 0x0050f8d5 - 0x401000
.globl FUN_0050f8d5
FUN_0050f8d5:
    # block 0x0050f8d5: entry, 9 instruction(s), calls FUN_00512c18, ends with je to 0x0050f8f4 (forward)
    push esi                                     # 0050f8d5
    {load} mov esi, ecx                          # 0050f8d6
    push 0x1b                                    # 0050f8d8
    mov dword ptr [esi], 0x530268                # 0050f8da
    call FUN_00512c18                            # 0050f8e0
    mov esi, dword ptr [esi + field_4]           # 0050f8e5
    pop ecx                                      # 0050f8e8
    test esi, esi                                # 0050f8e9
    je.d8 L_0050f8f4                             # 0050f8eb
    # block 0x0050f8ed: entered by fall-through of je at 0x0050f8eb, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x0050f8f4
    push esi                                     # 0050f8ed
    call FUN_0050e936                            # 0050f8ee
    pop ecx                                      # 0050f8f3
L_0050f8f4:
    # block 0x0050f8f4: entered by je at 0x0050f8eb, 5 instruction(s), calls FUN_00512c79, ends with ret
    push 0x1b                                    # 0050f8f4
    call FUN_00512c79                            # 0050f8f6
    pop ecx                                      # 0050f8fb
    pop esi                                      # 0050f8fc
    ret                                          # 0050f8fd

