# FUN_005248c1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005248c1
# extent:       0x005248c1-0x00524901 (64 code bytes)
# span:         0x005248c1-0x00524901 (code 64, tables 0, padding 0)
# sha256:       5f1a719c78c6f92709bf9f018c5ba570f966ccd665f112d00e64bee73a8f8e36
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524880 (+0x41)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005248c1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0050c575, FUN_0051a7c3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050c575, .text + (0x0050c575 - 0x401000)
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a7c3, .text + (0x0051a7c3 - 0x401000)

.org 0x005248c1 - 0x401000
.globl FUN_005248c1
FUN_005248c1:
    # block 0x005248c1: entry, 12 instruction(s), calls FUN_0050f978, FUN_0050c575, ends with je to 0x005248f4 (forward)
    mov eax, 0x528c02                            # 005248c1
    call FUN_0050f978                            # 005248c6
    push ecx                                     # 005248cb
    push esi                                     # 005248cc
    mov ecx, 0x63c230                            # 005248cd
    call FUN_0050c575                            # 005248d2
    {load} mov esi, eax                          # 005248d7
    mov dword ptr [ebp - field_minus_10], esi    # 005248d9
    {load} xor eax, eax                          # 005248dc
    {load} cmp esi, eax                          # 005248de
    mov dword ptr [ebp - field_minus_4], eax     # 005248e0
    je.d8 L_005248f4                             # 005248e3
    # block 0x005248e5: entered by fall-through of je at 0x005248e3, 4 instruction(s), calls FUN_0051a7c3, falls into the block at 0x005248f4
    {load} mov ecx, esi                          # 005248e5
    call FUN_0051a7c3                            # 005248e7
    mov dword ptr [esi], 0x52eb7c                # 005248ec
    {load} mov eax, esi                          # 005248f2
L_005248f4:
    # block 0x005248f4: entered by je at 0x005248e3, 5 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 005248f4
    pop esi                                      # 005248f7
    mov dword ptr fs:[0x0], ecx                  # 005248f8
    leave                                        # 005248ff
    ret                                          # 00524900

