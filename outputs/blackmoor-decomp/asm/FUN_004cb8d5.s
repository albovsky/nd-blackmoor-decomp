# FUN_004cb8d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cb8d5
# extent:       0x004cb8d5-0x004cb8fa (37 code bytes)
# span:         0x004cb8d5-0x004cb8fa (code 37, tables 0, padding 0)
# sha256:       890f954d8b7a0aae4a900fa2033c3054491595ea6fc7f5f750082b5ce5db9301
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cb8d5
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004cc70f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004cc70f, .text + (0x004cc70f - 0x401000)

.org 0x004cb8d5 - 0x401000
.globl FUN_004cb8d5
FUN_004cb8d5:
    # block 0x004cb8d5: entry, 14 instruction(s), calls FUN_004cc70f, ends with ret
    push ebp                                     # 004cb8d5
    {load} mov ebp, esp                          # 004cb8d6
    sub esp, 0x8                                 # 004cb8d8
    mov dword ptr [ebp - local_8], ecx           # 004cb8db
    mov dword ptr [ebp - local_4], 0x0           # 004cb8de
    push 0x18                                    # 004cb8e5
    lea eax, [ebp - local_4]                     # 004cb8e7
    push eax                                     # 004cb8ea
    mov ecx, dword ptr [ebp - local_8]           # 004cb8eb
    call FUN_004cc70f                            # 004cb8ee
    mov eax, dword ptr [ebp - local_4]           # 004cb8f3
    {load} mov esp, ebp                          # 004cb8f6
    pop ebp                                      # 004cb8f8
    ret                                          # 004cb8f9

