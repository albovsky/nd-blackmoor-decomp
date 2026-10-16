# FUN_004b71f7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b71f7
# extent:       0x004b71f7-0x004b7229 (50 code bytes)
# span:         0x004b71f7-0x004b7229 (code 50, tables 0, padding 0)
# sha256:       ed7a6bf486f43d17c64df5d4ce954f955c5a92c1ac0e927d7c15d2b09d934714
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b71f7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_21, field_36; [ecx + n] field_2f, field_3b; [edx + n] field_35
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_21, 0x21  # offset +0x21
.equ field_2f, 0x2f  # offset +0x2f
.equ field_35, 0x35  # offset +0x35
.equ field_36, 0x36  # offset +0x36
.equ field_3b, 0x3b  # offset +0x3b

# --- external targets -----------------------------------------------

.org 0x004b71f7 - 0x401000
.globl FUN_004b71f7
FUN_004b71f7:
    # block 0x004b71f7: entry, 17 instruction(s), ends with ret
    push ebp                                     # 004b71f7
    {load} mov ebp, esp                          # 004b71f8
    push ecx                                     # 004b71fa
    mov dword ptr [ebp - local_4], ecx           # 004b71fb
    mov eax, dword ptr [ebp - local_4]           # 004b71fe
    mov word ptr [eax + field_21], 0xffff        # 004b7201
    mov ecx, dword ptr [ebp - local_4]           # 004b7207
    mov word ptr [ecx + field_2f], 0xffff        # 004b720a
    mov edx, dword ptr [ebp - local_4]           # 004b7210
    mov byte ptr [edx + field_35], 0x0           # 004b7213
    mov eax, dword ptr [ebp - local_4]           # 004b7217
    mov byte ptr [eax + field_36], 0x0           # 004b721a
    mov ecx, dword ptr [ebp - local_4]           # 004b721e
    mov byte ptr [ecx + field_3b], 0x0           # 004b7221
    {load} mov esp, ebp                          # 004b7225
    pop ebp                                      # 004b7227
    ret                                          # 004b7228

