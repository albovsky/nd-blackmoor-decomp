# FUN_004e2956
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2956
# extent:       0x004e2956-0x004e2967 (17 code bytes)
# span:         0x004e2956-0x004e2967 (code 17, tables 0, padding 0)
# sha256:       03ffee0f52fc669a8821fe8061ce6595c1120a0f1d7c8ee7410b50cc4afec5db
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e2956
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_30
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------

.org 0x004e2956 - 0x401000
.globl FUN_004e2956
FUN_004e2956:
    # block 0x004e2956: entry, 9 instruction(s), ends with ret
    push ebp                                     # 004e2956
    {load} mov ebp, esp                          # 004e2957
    push ecx                                     # 004e2959
    mov dword ptr [ebp - local_4], ecx           # 004e295a
    mov eax, dword ptr [ebp - local_4]           # 004e295d
    mov eax, dword ptr [eax + field_30]          # 004e2960
    {load} mov esp, ebp                          # 004e2963
    pop ebp                                      # 004e2965
    ret                                          # 004e2966

