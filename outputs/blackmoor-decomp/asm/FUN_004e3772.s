# FUN_004e3772
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e3772
# extent:       0x004e3772-0x004e37bd (75 code bytes)
# span:         0x004e3772-0x004e37bd (code 75, tables 0, padding 0)
# sha256:       17c2c4102395bdb4f4efce5114417135486f742180496e650c93a18aee802429
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e3772_lifted
# naming:       native port src/original_methods_fl39d.c:m4e3772_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; no conditional jumps.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e2940
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e3772_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)

.org 0x004e3772 - 0x401000
.globl FUN_004e3772
FUN_004e3772:
    # block 0x004e3772: entry, 23 instruction(s), calls FUN_004e2940, ends with ret
    push ebp                                     # 004e3772
    {load} mov ebp, esp                          # 004e3773
    push ecx                                     # 004e3775
    mov dword ptr [ebp - local_4], ecx           # 004e3776
    push 0x0                                     # 004e3779
    mov ecx, dword ptr [ebp - local_4]           # 004e377b
    add ecx, 0x407b                              # 004e377e
    call FUN_004e2940                            # 004e3784
    push 0x0                                     # 004e3789
    mov ecx, dword ptr [ebp - local_4]           # 004e378b
    add ecx, 0x420a                              # 004e378e
    call FUN_004e2940                            # 004e3794
    push 0x0                                     # 004e3799
    mov ecx, dword ptr [ebp - local_4]           # 004e379b
    add ecx, 0x3d5d                              # 004e379e
    call FUN_004e2940                            # 004e37a4
    push 0x0                                     # 004e37a9
    mov ecx, dword ptr [ebp - local_4]           # 004e37ab
    add ecx, 0x3eec                              # 004e37ae
    call FUN_004e2940                            # 004e37b4
    {load} mov esp, ebp                          # 004e37b9
    pop ebp                                      # 004e37bb
    ret                                          # 004e37bc

