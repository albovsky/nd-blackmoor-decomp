# FUN_00472fb7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00472fb7
# extent:       0x00472fb7-0x004730a6 (239 code bytes)
# span:         0x00472fb7-0x004730a6 (code 239, tables 0, padding 0)
# sha256:       139ca54133d8d3eb2b75f711a8addf0bf5d30044432eb1bcf70bfbcac3876aea
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00472fb7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_8, field_c, field_82, field_347, field_355, field_371; [ecx + n] field_4, field_8, field_c, field_14, field_7a, field_34d, field_359, field_35d; [edx + n] field_4, field_8, field_c, field_7e, field_345, field_351, field_35f
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m472f21_lifted (function ledger class candidate_port; also m472fb7_lifted, m4730a6_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 53 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_7a, 0x7a  # offset +0x7a
.equ field_7e, 0x7e  # offset +0x7e
.equ field_82, 0x82  # offset +0x82
.equ field_345, 0x345  # offset +0x345
.equ field_347, 0x347  # offset +0x347
.equ field_34d, 0x34d  # offset +0x34d
.equ field_351, 0x351  # offset +0x351
.equ field_355, 0x355  # offset +0x355
.equ field_359, 0x359  # offset +0x359
.equ field_35d, 0x35d  # offset +0x35d
.equ field_35f, 0x35f  # offset +0x35f
.equ field_371, 0x371  # offset +0x371

# --- external targets -----------------------------------------------

.org 0x00472fb7 - 0x401000
.globl FUN_00472fb7
FUN_00472fb7:
    # block 0x00472fb7: entry, 53 instruction(s), ends with ret
    push ebp                                     # 00472fb7
    {load} mov ebp, esp                          # 00472fb8
    push ecx                                     # 00472fba
    mov dword ptr [ebp - local_4], ecx           # 00472fbb
    mov eax, dword ptr [ebp - local_4]           # 00472fbe
    mov word ptr [eax + field_c], 0xffff         # 00472fc1
    mov ecx, dword ptr [ebp - local_4]           # 00472fc7
    mov word ptr [ecx + field_14], 0xffff        # 00472fca
    mov edx, dword ptr [ebp - local_4]           # 00472fd0
    mov dword ptr [edx + field_4], 0x0           # 00472fd3
    mov eax, dword ptr [ebp - local_4]           # 00472fda
    mov dword ptr [eax + field_8], 0x0           # 00472fdd
    mov ecx, dword ptr [ebp - local_4]           # 00472fe4
    mov dword ptr [ecx + field_7a], 0x0          # 00472fe7
    mov edx, dword ptr [ebp - local_4]           # 00472fee
    mov dword ptr [edx + field_7e], 0x0          # 00472ff1
    mov eax, dword ptr [ebp - local_4]           # 00472ff8
    mov dword ptr [eax + field_82], 0x0          # 00472ffb
    mov ecx, dword ptr [ebp - local_4]           # 00473005
    mov dword ptr [ecx + field_34d], 0x0         # 00473008
    mov edx, dword ptr [ebp - local_4]           # 00473012
    mov dword ptr [edx + field_351], 0x0         # 00473015
    mov eax, dword ptr [ebp - local_4]           # 0047301f
    mov dword ptr [eax + field_355], 0x0         # 00473022
    mov ecx, dword ptr [ebp - local_4]           # 0047302c
    mov dword ptr [ecx + field_359], 0x0         # 0047302f
    mov edx, dword ptr [ebp - local_4]           # 00473039
    mov word ptr [edx + field_345], 0x0          # 0047303c
    mov eax, dword ptr [ebp - local_4]           # 00473045
    mov word ptr [eax + field_347], 0x0          # 00473048
    mov ecx, dword ptr [ebp - local_4]           # 00473051
    mov word ptr [ecx + field_35d], 0x0          # 00473054
    mov edx, dword ptr [ebp - local_4]           # 0047305d
    mov word ptr [edx + field_35f], 0x0          # 00473060
    mov eax, dword ptr [ebp - local_4]           # 00473069
    mov dword ptr [eax + field_371], 0x0         # 0047306c
    {load} xor ecx, ecx                          # 00473076
    mov edx, dword ptr [ebp - local_4]           # 00473078
    add edx, 0x361                               # 0047307b
    mov dword ptr [edx], ecx                     # 00473081
    mov dword ptr [edx + field_4], ecx           # 00473083
    mov dword ptr [edx + field_8], ecx           # 00473086
    mov dword ptr [edx + field_c], ecx           # 00473089
    {load} xor eax, eax                          # 0047308c
    mov ecx, dword ptr [ebp - local_4]           # 0047308e
    add ecx, 0x375                               # 00473091
    mov dword ptr [ecx], eax                     # 00473097
    mov dword ptr [ecx + field_4], eax           # 00473099
    mov dword ptr [ecx + field_8], eax           # 0047309c
    mov dword ptr [ecx + field_c], eax           # 0047309f
    {load} mov esp, ebp                          # 004730a2
    pop ebp                                      # 004730a4
    ret                                          # 004730a5

