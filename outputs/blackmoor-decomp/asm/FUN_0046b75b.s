# FUN_0046b75b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b75b
# extent:       0x0046b75b-0x0046b79a (63 code bytes)
# span:         0x0046b75b-0x0046b79a (code 63, tables 0, padding 0)
# sha256:       076816b00cdf92cac6a181d54c52311fb1e9ea32c7c3974f8a9fafc21117a610
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046b75b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4a28, field_4a2c; [ecx + n] field_4a24; [edx + n] field_4a4c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4a24, 0x4a24  # offset +0x4a24
.equ field_4a28, 0x4a28  # offset +0x4a28
.equ field_4a2c, 0x4a2c  # offset +0x4a2c
.equ field_4a4c, 0x4a4c  # offset +0x4a4c

# --- external targets -----------------------------------------------

.org 0x0046b75b - 0x401000
.globl FUN_0046b75b
FUN_0046b75b:
    # block 0x0046b75b: entry, 15 instruction(s), ends with ret
    push ebp                                     # 0046b75b
    {load} mov ebp, esp                          # 0046b75c
    push ecx                                     # 0046b75e
    mov dword ptr [ebp - local_4], ecx           # 0046b75f
    mov eax, dword ptr [ebp - local_4]           # 0046b762
    mov dword ptr [eax + field_4a28], 0x0        # 0046b765
    mov ecx, dword ptr [ebp - local_4]           # 0046b76f
    mov dword ptr [ecx + field_4a24], 0x0        # 0046b772
    mov edx, dword ptr [ebp - local_4]           # 0046b77c
    mov dword ptr [edx + field_4a4c], 0x0        # 0046b77f
    mov eax, dword ptr [ebp - local_4]           # 0046b789
    mov dword ptr [eax + field_4a2c], 0x0        # 0046b78c
    {load} mov esp, ebp                          # 0046b796
    pop ebp                                      # 0046b798
    ret                                          # 0046b799

