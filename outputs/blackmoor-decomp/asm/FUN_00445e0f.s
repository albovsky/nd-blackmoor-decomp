# FUN_00445e0f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00445e0f
# extent:       0x00445e0f-0x00445e2b (28 code bytes)
# span:         0x00445e0f-0x00445e2b (code 28, tables 0, padding 0)
# sha256:       4564d8d4f04e4c49cf96548d041d312fadf3a37716cfb947accf720cfc6b0c32
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00445e0f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00445f40
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_00445f40, .text + (0x00445f40 - 0x401000)

.org 0x00445e0f - 0x401000
.globl FUN_00445e0f
FUN_00445e0f:
    # block 0x00445e0f: entry, 11 instruction(s), calls FUN_00445f40, ends with ret
    push ebp                                     # 00445e0f
    {load} mov ebp, esp                          # 00445e10
    push ecx                                     # 00445e12
    mov dword ptr [ebp - local_4], ecx           # 00445e13
    mov eax, dword ptr [ebp - local_4]           # 00445e16
    mov dword ptr [eax], 0x52ca1c                # 00445e19
    mov ecx, dword ptr [ebp - local_4]           # 00445e1f
    call FUN_00445f40                            # 00445e22
    {load} mov esp, ebp                          # 00445e27
    pop ebp                                      # 00445e29
    ret                                          # 00445e2a

