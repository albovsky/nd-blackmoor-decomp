# FUN_004de214
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de214
# extent:       0x004de214-0x004de227 (19 code bytes)
# span:         0x004de214-0x004de227 (code 19, tables 0, padding 0)
# sha256:       27166be5e0d0b40eb52b45e77558158f6facb5ca3e36a28e01b88ee2cfd4ebf8
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de214
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004de1f5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004de1f5, .text + (0x004de1f5 - 0x401000)

.org 0x004de214 - 0x401000
.globl FUN_004de214
FUN_004de214:
    # block 0x004de214: entry, 9 instruction(s), calls FUN_004de1f5, ends with ret
    push ebp                                     # 004de214
    {load} mov ebp, esp                          # 004de215
    push ecx                                     # 004de217
    mov dword ptr [ebp - local_4], ecx           # 004de218
    mov ecx, dword ptr [ebp - local_4]           # 004de21b
    call FUN_004de1f5                            # 004de21e
    {load} mov esp, ebp                          # 004de223
    pop ebp                                      # 004de225
    ret                                          # 004de226

