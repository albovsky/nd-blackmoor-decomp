# FUN_00513780
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513780
# extent:       0x00513780-0x005137be (62 code bytes)
# span:         0x00513780-0x005137be (code 62, tables 0, padding 0)
# sha256:       3c2270d3c7aa0e1de33c2230ca3460aed24d7aa2b4bbdd0eac259e52db976ea4
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __cintrindisp2
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       4 ebp-relative slot(s): local_7e, local_86, local_a4, local_2c8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00513a57, FUN_0051384a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_7e, 0x7e  # offset -0x7e
.equ local_86, 0x86  # offset -0x86
.equ local_a4, 0xa4  # offset -0xa4
.equ local_2c8, 0x2c8  # offset -0x2c8

# --- external targets -----------------------------------------------
.set FUN_0051384a, .text + (0x0051384a - 0x401000)
.set FUN_00513a57, .text + (0x00513a57 - 0x401000)

.org 0x00513780 - 0x401000
.globl FUN_00513780
FUN_00513780:
    # block 0x00513780: entry, 9 instruction(s), ends with je to 0x005137af (forward)
    push ebp                                     # 00513780
    {load} mov ebp, esp                          # 00513781
    add esp, 0xfffffd30                          # 00513783
    push ebx                                     # 00513789
    wait                                         # 0051378a
    fnstcw word ptr [ebp - local_a4]             # 0051378b
    wait                                         # 00513791
    cmp dword ptr [0x568e30], 0x0                # 00513792
    je.d8 L_005137af                             # 00513799
L_0051379b:
    # block 0x0051379b: entered by jmp at 0x005137bc; fall-through of je at 0x00513799, 6 instruction(s), calls FUN_00513a57, FUN_0051384a, ends with ret
    call FUN_00513a57                            # 0051379b
    or byte ptr [ebp - local_2c8], 0x3           # 005137a0
    call FUN_0051384a                            # 005137a7
    pop ebx                                      # 005137ac
    leave                                        # 005137ad
    ret                                          # 005137ae
L_005137af:
    # block 0x005137af: entered by je at 0x00513799, 5 instruction(s), ends with backward jump to 0x0051379b
    fxch st(1)                                   # 005137af
    fst qword ptr [ebp - local_86]               # 005137b1
    fxch st(1)                                   # 005137b7
    fst qword ptr [ebp - local_7e]               # 005137b9
    jmp.d8 L_0051379b                            # 005137bc

