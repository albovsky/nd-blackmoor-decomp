# FUN_004e0742
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e0742
# extent:       0x004e0742-0x004e075a (24 code bytes)
# span:         0x004e0742-0x004e075a (code 24, tables 0, padding 0)
# sha256:       7fb952936f4e4f0d75c7d294bee1b9a51f6dad2910516cfd97605e674f1cfd6f
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e0742
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_f2e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_f2e, 0xf2e  # offset +0xf2e

# --- external targets -----------------------------------------------

.org 0x004e0742 - 0x401000
.globl FUN_004e0742
FUN_004e0742:
    # block 0x004e0742: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004e0742
    {load} mov ebp, esp                          # 004e0743
    push ecx                                     # 004e0745
    mov dword ptr [ebp - local_4], ecx           # 004e0746
    mov eax, dword ptr [ebp - local_4]           # 004e0749
    mov dword ptr [eax + field_f2e], 0x1         # 004e074c
    {load} mov esp, ebp                          # 004e0756
    pop ebp                                      # 004e0758
    ret                                          # 004e0759

