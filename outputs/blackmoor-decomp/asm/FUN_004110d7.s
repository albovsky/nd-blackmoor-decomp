# FUN_004110d7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004110d7
# extent:       0x004110d7-0x004110f6 (31 code bytes)
# span:         0x004110d7-0x004110f6 (code 31, tables 0, padding 0)
# sha256:       e931016ab00904d8c9f6fcb09933ce9516b51946eb76a6401235a1fcdd9622e0
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004110d7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004230d1
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004230d1, .text + (0x004230d1 - 0x401000)

.org 0x004110d7 - 0x401000
.globl FUN_004110d7
FUN_004110d7:
    # block 0x004110d7: entry, 12 instruction(s), calls FUN_004230d1, ends with ret
    push ebp                                     # 004110d7
    {load} mov ebp, esp                          # 004110d8
    push ecx                                     # 004110da
    mov dword ptr [ebp - local_4], ecx           # 004110db
    mov eax, dword ptr [ebp - local_4]           # 004110de
    mov dword ptr [eax], 0x52c4b0                # 004110e1
    mov ecx, dword ptr [ebp - local_4]           # 004110e7
    add ecx, 0x2a                                # 004110ea
    call FUN_004230d1                            # 004110ed
    {load} mov esp, ebp                          # 004110f2
    pop ebp                                      # 004110f4
    ret                                          # 004110f5

