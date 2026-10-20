# FUN_005137fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005137fb
# extent:       0x005137fb-0x00513843 (72 code bytes)
# span:         0x005137fb-0x00513843 (code 72, tables 0, padding 0)
# sha256:       13d255e0b6e2273e8e7dae7d9a3c4c02b9b9a8b7fcc0bfac6f0116b64946d8c5
# evidence:     ev_d7f4aec8bb0e093ec20247522281ab9457c1cc675ad71ff176c6b77b54b753d3
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __ctrandisp2
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_8f, local_a4, local_2c8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005139ae, FUN_00513a57, FUN_00513843
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8f, 0x8f  # offset -0x8f
.equ local_a4, 0xa4  # offset -0xa4
.equ local_2c8, 0x2c8  # offset -0x2c8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_00513843, .text + (0x00513843 - 0x401000)
.set FUN_005139ae, .text + (0x005139ae - 0x401000)
.set FUN_00513a57, .text + (0x00513a57 - 0x401000)

.org 0x005137fb - 0x401000
.globl FUN_005137fb
FUN_005137fb:
    # block 0x005137fb: entry, 21 instruction(s), calls FUN_005139ae, FUN_00513a57, FUN_00513843, ends with ret
    push ebp                                     # 005137fb
    {load} mov ebp, esp                          # 005137fc
    add esp, 0xfffffd30                          # 005137fe
    push ebx                                     # 00513804
    push dword ptr [ebp + arg_c]                 # 00513805
    push dword ptr [ebp + arg_8]                 # 00513808
    call FUN_005139ae                            # 0051380b
    add esp, 0x8                                 # 00513810
    push dword ptr [ebp + arg_14]                # 00513813
    push dword ptr [ebp + arg_10]                # 00513816
    call FUN_005139ae                            # 00513819
    add esp, 0x8                                 # 0051381e
    wait                                         # 00513821
    fnstcw word ptr [ebp - local_a4]             # 00513822
    or byte ptr [ebp - local_2c8], 0x2           # 00513828
    mov byte ptr [ebp - local_8f], 0x1           # 0051382f
    call FUN_00513a57                            # 00513836
    call FUN_00513843                            # 0051383b
    pop ebx                                      # 00513840
    leave                                        # 00513841
    ret                                          # 00513842

