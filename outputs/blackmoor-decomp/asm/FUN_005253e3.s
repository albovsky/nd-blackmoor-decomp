# FUN_005253e3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005253e3
# extent:       0x005253e3-0x0052540b (40 code bytes)
# span:         0x005253e3-0x0052540b (code 40, tables 0, padding 0)
# sha256:       76a2bb0098c8da916083f0ad3d7414b6e95b63dcb687a04ec273ef869eb17841
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005253ae (+0x35)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005253e3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005256dd, FUN_00525170
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00525170, .text + (0x00525170 - 0x401000)
.set FUN_005256dd, .text + (0x005256dd - 0x401000)

.org 0x005253e3 - 0x401000
.globl FUN_005253e3
FUN_005253e3:
    # block 0x005253e3: entry, 6 instruction(s), calls FUN_005256dd, ends with je to 0x00525407 (forward)
    push esi                                     # 005253e3
    push 0x1074                                  # 005253e4
    call FUN_005256dd                            # 005253e9
    {load} mov esi, eax                          # 005253ee
    test esi, esi                                # 005253f0
    je.d8 L_00525407                             # 005253f2
    # block 0x005253f4: entered by fall-through of je at 0x005253f2, 7 instruction(s), calls FUN_00525170, ends with ret
    push 0x1                                     # 005253f4
    {load} mov ecx, esi                          # 005253f6
    call FUN_00525170                            # 005253f8
    mov dword ptr [esi], 0x52fb94                # 005253fd
    {load} mov eax, esi                          # 00525403
    pop esi                                      # 00525405
    ret                                          # 00525406
L_00525407:
    # block 0x00525407: entered by je at 0x005253f2, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 00525407
    pop esi                                      # 00525409
    ret                                          # 0052540a

