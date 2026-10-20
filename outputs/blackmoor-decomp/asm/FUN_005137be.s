# FUN_005137be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005137be
# extent:       0x005137be-0x005137fb (61 code bytes)
# span:         0x005137be-0x005137fb (code 61, tables 0, padding 0)
# sha256:       a0a9b859e40f58ff5fa6e6ef9c6a08d5bb1b80ff0a4b374f4abf6b7b642eab29
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __cintrindisp1
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_86, local_a4, local_2c8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005139f0, FUN_0051384a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_86, 0x86  # offset -0x86
.equ local_a4, 0xa4  # offset -0xa4
.equ local_2c8, 0x2c8  # offset -0x2c8

# --- external targets -----------------------------------------------
.set FUN_0051384a, .text + (0x0051384a - 0x401000)
.set FUN_005139f0, .text + (0x005139f0 - 0x401000)

.org 0x005137be - 0x401000
.globl FUN_005137be
FUN_005137be:
    # block 0x005137be: entry, 8 instruction(s), ends with je to 0x005137f3 (forward)
    push ebp                                     # 005137be
    {load} mov ebp, esp                          # 005137bf
    add esp, 0xfffffd30                          # 005137c1
    push ebx                                     # 005137c7
    wait                                         # 005137c8
    fnstcw word ptr [ebp - local_a4]             # 005137c9
    cmp dword ptr [0x568e30], 0x0                # 005137cf
    je.d8 L_005137f3                             # 005137d6
L_005137d8:
    # block 0x005137d8: entered by jmp at 0x005137f9; fall-through of je at 0x005137d6, 7 instruction(s), calls FUN_005139f0, FUN_0051384a, ends with ret
    call FUN_005139f0                            # 005137d8
    or byte ptr [ebp - local_2c8], 0x1           # 005137dd
    and byte ptr [ebp - local_2c8], -0x3         # 005137e4
    call FUN_0051384a                            # 005137eb
    pop ebx                                      # 005137f0
    leave                                        # 005137f1
    ret                                          # 005137f2
L_005137f3:
    # block 0x005137f3: entered by je at 0x005137d6, 2 instruction(s), ends with backward jump to 0x005137d8
    fst qword ptr [ebp - local_86]               # 005137f3
    jmp.d8 L_005137d8                            # 005137f9

