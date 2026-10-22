# FUN_0044e767
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044e767
# extent:       0x0044e767-0x0044e78e (39 code bytes)
# span:         0x0044e767-0x0044e78e (code 39, tables 0, padding 0)
# sha256:       0f087e36dc071e23497cca1e297aba71b6fe2f5bcb79c2f87473b51b63ad680a
# evidence:     ev_44f9ad36cfcb6cd07f5dfecee6ae0cfb679ab9d068db67b1a73f7c4febbd58e5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044e767
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e; [ecx + n] field_1c; [edx + n] field_6b
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_6b, 0x6b  # offset +0x6b

# --- external targets -----------------------------------------------

.org 0x0044e767 - 0x401000
.globl FUN_0044e767
FUN_0044e767:
    # block 0x0044e767: entry, 13 instruction(s), ends with ret
    push ebp                                     # 0044e767
    {load} mov ebp, esp                          # 0044e768
    push ecx                                     # 0044e76a
    mov dword ptr [ebp - local_4], ecx           # 0044e76b
    mov eax, dword ptr [ebp - local_4]           # 0044e76e
    mov word ptr [eax + field_1e], 0xffff        # 0044e771
    mov ecx, dword ptr [ebp - local_4]           # 0044e777
    mov word ptr [ecx + field_1c], 0xffff        # 0044e77a
    mov edx, dword ptr [ebp - local_4]           # 0044e780
    mov dword ptr [edx + field_6b], 0x0          # 0044e783
    {load} mov esp, ebp                          # 0044e78a
    pop ebp                                      # 0044e78c
    ret                                          # 0044e78d

