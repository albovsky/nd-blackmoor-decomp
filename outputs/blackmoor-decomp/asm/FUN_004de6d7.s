# FUN_004de6d7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004de6d7
# extent:       0x004de6d7-0x004de6fc (37 code bytes)
# span:         0x004de6d7-0x004de6fc (code 37, tables 0, padding 0)
# sha256:       c1f12ba8d1b71a26a97a08668130ee755bd0ddaeee0999a9ddbe299e644a5da6
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004de6d7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_73c; [ecx + n] field_740
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_73c, 0x73c  # offset +0x73c
.equ field_740, 0x740  # offset +0x740

# --- external targets -----------------------------------------------

.org 0x004de6d7 - 0x401000
.globl FUN_004de6d7
FUN_004de6d7:
    # block 0x004de6d7: entry, 11 instruction(s), ends with ret
    push ebp                                     # 004de6d7
    {load} mov ebp, esp                          # 004de6d8
    push ecx                                     # 004de6da
    mov dword ptr [ebp - local_4], ecx           # 004de6db
    mov eax, dword ptr [ebp - local_4]           # 004de6de
    mov dword ptr [eax + field_73c], 0x0         # 004de6e1
    mov ecx, dword ptr [ebp - local_4]           # 004de6eb
    mov dword ptr [ecx + field_740], 0x0         # 004de6ee
    {load} mov esp, ebp                          # 004de6f8
    pop ebp                                      # 004de6fa
    ret                                          # 004de6fb

