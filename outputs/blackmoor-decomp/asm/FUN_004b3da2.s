# FUN_004b3da2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b3da2
# extent:       0x004b3da2-0x004b3ddf (61 code bytes)
# span:         0x004b3da2-0x004b3ddf (code 61, tables 0, padding 0)
# sha256:       2a98862c8c612b2ed020c026d96ef4818091ddb44d2e4c97254450a3e3987a9e
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004b3da2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_726, field_76e; [ecx + n] field_726
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_726, 0x726  # offset +0x726
.equ field_76e, 0x76e  # offset +0x76e

# --- external targets -----------------------------------------------

.org 0x004b3da2 - 0x401000
.globl FUN_004b3da2
FUN_004b3da2:
    # block 0x004b3da2: entry, 7 instruction(s), ends with je to 0x004b3ddb (forward)
    push ebp                                     # 004b3da2
    {load} mov ebp, esp                          # 004b3da3
    push ecx                                     # 004b3da5
    mov dword ptr [ebp - local_4], ecx           # 004b3da6
    mov eax, dword ptr [ebp - local_4]           # 004b3da9
    cmp dword ptr [eax + field_76e], 0x0         # 004b3dac
    je.d8 L_004b3ddb                             # 004b3db3
    # block 0x004b3db5: entered by fall-through of je at 0x004b3db3, 4 instruction(s), ends with je to 0x004b3ddb (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004b3db5
    movsx edx, word ptr [ecx + field_726]        # 004b3db8
    cmp edx, -0x1                                # 004b3dbf
    je.d8 L_004b3ddb                             # 004b3dc2
    # block 0x004b3dc4: entered by fall-through of je at 0x004b3dc2, 4 instruction(s), falls into the block at 0x004b3ddb
    mov eax, dword ptr [ebp - local_4]           # 004b3dc4
    movsx ecx, word ptr [eax + field_726]        # 004b3dc7
    imul ecx, ecx, 0x4a                          # 004b3dce
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004b3dd1
L_004b3ddb:
    # block 0x004b3ddb: entered by je at 0x004b3db3; je at 0x004b3dc2, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b3ddb
    pop ebp                                      # 004b3ddd
    ret                                          # 004b3dde

