# FUN_00488d89
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00488d89
# extent:       0x00488d89-0x00488da5 (28 code bytes)
# span:         0x00488d89-0x00488da5 (code 28, tables 0, padding 0)
# sha256:       8aae77b2134fe0f94c0d247e4363d7871a860f5d13578f5da502cc03496dd6fb
# evidence:     ev_54bace4f2834e1ad21518a3c0097c08b99de1c57712a85070ff3f94714efabd4
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00488d89
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00488d89 - 0x401000
.globl FUN_00488d89
FUN_00488d89:
    # block 0x00488d89: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00488d89
    {load} mov ebp, esp                          # 00488d8a
    push ecx                                     # 00488d8c
    mov dword ptr [ebp - local_4], ecx           # 00488d8d
    mov eax, dword ptr [ebp - local_4]           # 00488d90
    mov dword ptr [eax], 0x52d850                # 00488d93
    mov ecx, dword ptr [ebp - local_4]           # 00488d99
    call FUN_0051d730                            # 00488d9c
    {load} mov esp, ebp                          # 00488da1
    pop ebp                                      # 00488da3
    ret                                          # 00488da4

