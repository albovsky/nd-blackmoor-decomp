# FUN_00509910
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00509910
# extent:       0x00509910-0x0050993f (47 code bytes)
# span:         0x00509910-0x00509940 (code 47, tables 0, padding 1)
# sha256:       e553bce3e75547c511bb12f7c5bf3e8e537cda262257d61afa9f68f6eaf9b12a
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00509910
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050ce04
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x00509910 - 0x401000
.globl FUN_00509910
FUN_00509910:
    # block 0x00509910: entry, 7 instruction(s), calls FUN_0050ce04, ends with jle to 0x00509934 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00509910
    fld dword ptr [eax]                          # 00509914
    fmul dword ptr [0x52e648]                    # 00509916
    fadd dword ptr [0x52e644]                    # 0050991c
    call FUN_0050ce04                            # 00509922
    cmp eax, 0x3ff                               # 00509927
    jle.d8 L_00509934                            # 0050992c
    # block 0x0050992e: entered by fall-through of jle at 0x0050992c, 2 instruction(s), ends with ret
    mov eax, 0x3ff                               # 0050992e
    ret                                          # 00509933
L_00509934:
    # block 0x00509934: entered by jle at 0x0050992c, 6 instruction(s), ends with ret
    {load} xor ecx, ecx                          # 00509934
    test eax, eax                                # 00509936
    setl cl                                      # 00509938
    dec ecx                                      # 0050993b
    {load} and eax, ecx                          # 0050993c
    ret                                          # 0050993e

# --- data items (not part of the function) -------------------------
.org 0x0050993f - 0x401000
PAD_0050993f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

