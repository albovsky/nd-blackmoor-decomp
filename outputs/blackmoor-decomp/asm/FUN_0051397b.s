# FUN_0051397b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051397b
# extent:       0x0051397b-0x005139ae (51 code bytes)
# span:         0x0051397b-0x005139ae (code 51, tables 0, padding 0)
# sha256:       848ce949502d44921535d858bb025390f2c24f90f810f862c960d9515e0bc8bf
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __ctrandisp1
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_a4, local_2c8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005139ae, FUN_005139f0, FUN_00513843
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_a4, 0xa4  # offset -0xa4
.equ local_2c8, 0x2c8  # offset -0x2c8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_00513843, .text + (0x00513843 - 0x401000)
.set FUN_005139ae, .text + (0x005139ae - 0x401000)
.set FUN_005139f0, .text + (0x005139f0 - 0x401000)

.org 0x0051397b - 0x401000
.globl FUN_0051397b
FUN_0051397b:
    # block 0x0051397b: entry, 16 instruction(s), calls FUN_005139ae, FUN_005139f0, FUN_00513843, ends with ret
    push ebp                                     # 0051397b
    {load} mov ebp, esp                          # 0051397c
    add esp, 0xfffffd30                          # 0051397e
    push ebx                                     # 00513984
    push dword ptr [ebp + arg_c]                 # 00513985
    push dword ptr [ebp + arg_8]                 # 00513988
    call FUN_005139ae                            # 0051398b
    add esp, 0x8                                 # 00513990
    wait                                         # 00513993
    fnstcw word ptr [ebp - local_a4]             # 00513994
    and byte ptr [ebp - local_2c8], -0x3         # 0051399a
    call FUN_005139f0                            # 005139a1
    call FUN_00513843                            # 005139a6
    pop ebx                                      # 005139ab
    leave                                        # 005139ac
    ret                                          # 005139ad

