# FUN_004e04f3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e04f3
# extent:       0x004e04f3-0x004e053f (76 code bytes)
# span:         0x004e04f3-0x004e053f (code 76, tables 0, padding 0)
# sha256:       7849d46365d2d27ea1505c187408a5921c1bc86a8529ac60476901dd76fceec1
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e04f3
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_f2a, field_f32; [ecx + n] field_74f, field_f36; [edx + n] field_f2e
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_74f, 0x74f  # offset +0x74f
.equ field_f2a, 0xf2a  # offset +0xf2a
.equ field_f2e, 0xf2e  # offset +0xf2e
.equ field_f32, 0xf32  # offset +0xf32
.equ field_f36, 0xf36  # offset +0xf36

# --- external targets -----------------------------------------------

.org 0x004e04f3 - 0x401000
.globl FUN_004e04f3
FUN_004e04f3:
    # block 0x004e04f3: entry, 17 instruction(s), ends with ret
    push ebp                                     # 004e04f3
    {load} mov ebp, esp                          # 004e04f4
    push ecx                                     # 004e04f6
    mov dword ptr [ebp - local_4], ecx           # 004e04f7
    mov eax, dword ptr [ebp - local_4]           # 004e04fa
    mov dword ptr [eax + field_f2a], 0x0         # 004e04fd
    mov ecx, dword ptr [ebp - local_4]           # 004e0507
    mov dword ptr [ecx + field_74f], 0x0         # 004e050a
    mov edx, dword ptr [ebp - local_4]           # 004e0514
    mov dword ptr [edx + field_f2e], 0x0         # 004e0517
    mov eax, dword ptr [ebp - local_4]           # 004e0521
    mov dword ptr [eax + field_f32], 0xffffffff  # 004e0524
    mov ecx, dword ptr [ebp - local_4]           # 004e052e
    mov dword ptr [ecx + field_f36], 0xffffffff  # 004e0531
    {load} mov esp, ebp                          # 004e053b
    pop ebp                                      # 004e053d
    ret                                          # 004e053e

