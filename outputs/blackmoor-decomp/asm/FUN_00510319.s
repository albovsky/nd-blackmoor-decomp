# FUN_00510319
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00510319
# extent:       0x00510319-0x0051034c (51 code bytes)
# span:         0x00510319-0x0051034c (code 51, tables 0, padding 0)
# sha256:       66c7e636508f50d734f754b824660f49e4e063c57a29c3c9c2b9d5e39d48be78
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00510319
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x00510319 - 0x401000
.globl FUN_00510319
FUN_00510319:
    # block 0x00510319: entry, 3 instruction(s), ends with je to 0x00510346 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00510319
    sub eax, 0x3a4                               # 0051031d
    je.d8 L_00510346                             # 00510322
    # block 0x00510324: entered by fall-through of je at 0x00510322, 2 instruction(s), ends with je to 0x00510340 (forward)
    sub eax, 0x4                                 # 00510324
    je.d8 L_00510340                             # 00510327
    # block 0x00510329: entered by fall-through of je at 0x00510327, 2 instruction(s), ends with je to 0x0051033a (forward)
    sub eax, 0xd                                 # 00510329
    je.d8 L_0051033a                             # 0051032c
    # block 0x0051032e: entered by fall-through of je at 0x0051032c, 2 instruction(s), ends with je to 0x00510334 (forward)
    dec eax                                      # 0051032e
    je.d8 L_00510334                             # 0051032f
    # block 0x00510331: entered by fall-through of je at 0x0051032f, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 00510331
    ret                                          # 00510333
L_00510334:
    # block 0x00510334: entered by je at 0x0051032f, 2 instruction(s), ends with ret
    mov eax, 0x404                               # 00510334
    ret                                          # 00510339
L_0051033a:
    # block 0x0051033a: entered by je at 0x0051032c, 2 instruction(s), ends with ret
    mov eax, 0x412                               # 0051033a
    ret                                          # 0051033f
L_00510340:
    # block 0x00510340: entered by je at 0x00510327, 2 instruction(s), ends with ret
    mov eax, 0x804                               # 00510340
    ret                                          # 00510345
L_00510346:
    # block 0x00510346: entered by je at 0x00510322, 2 instruction(s), ends with ret
    mov eax, 0x411                               # 00510346
    ret                                          # 0051034b

