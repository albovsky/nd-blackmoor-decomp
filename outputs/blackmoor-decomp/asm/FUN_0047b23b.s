# FUN_0047b23b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b23b
# extent:       0x0047b23b-0x0047b321 (230 code bytes)
# span:         0x0047b23b-0x0047b321 (code 230, tables 0, padding 0)
# sha256:       a4f9e3a25088b9091adec3ef3cbc76d49c083705d3653f6c233c15304af09ea8
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047b23b
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_6, field_8, field_1c, field_24, field_30, field_28c, field_29c; [ecx + n] field_4, field_14, field_20, field_28, field_34, field_288, field_2a4; [edx + n] field_c, field_18, field_2c, field_280, field_2a0, field_2a8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 47 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_34, 0x34  # offset +0x34
.equ field_280, 0x280  # offset +0x280
.equ field_288, 0x288  # offset +0x288
.equ field_28c, 0x28c  # offset +0x28c
.equ field_29c, 0x29c  # offset +0x29c
.equ field_2a0, 0x2a0  # offset +0x2a0
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_2a8, 0x2a8  # offset +0x2a8

# --- external targets -----------------------------------------------

.org 0x0047b23b - 0x401000
.globl FUN_0047b23b
FUN_0047b23b:
    # block 0x0047b23b: entry, 47 instruction(s), ends with ret
    push ebp                                     # 0047b23b
    {load} mov ebp, esp                          # 0047b23c
    push ecx                                     # 0047b23e
    mov dword ptr [ebp - local_4], ecx           # 0047b23f
    mov eax, dword ptr [ebp - local_4]           # 0047b242
    mov word ptr [eax + field_6], 0xffff         # 0047b245
    mov ecx, dword ptr [ebp - local_4]           # 0047b24b
    mov word ptr [ecx + field_4], 0xffff         # 0047b24e
    mov edx, dword ptr [ebp - local_4]           # 0047b254
    mov dword ptr [edx + field_c], 0x0           # 0047b257
    mov eax, dword ptr [ebp - local_4]           # 0047b25e
    mov dword ptr [eax + field_24], 0x0          # 0047b261
    mov ecx, dword ptr [ebp - local_4]           # 0047b268
    mov dword ptr [ecx + field_28], 0x0          # 0047b26b
    mov edx, dword ptr [ebp - local_4]           # 0047b272
    mov dword ptr [edx + field_2c], 0x0          # 0047b275
    mov eax, dword ptr [ebp - local_4]           # 0047b27c
    mov dword ptr [eax + field_30], 0x0          # 0047b27f
    mov ecx, dword ptr [ebp - local_4]           # 0047b286
    mov dword ptr [ecx + field_34], 0x0          # 0047b289
    mov edx, dword ptr [ebp - local_4]           # 0047b290
    mov dword ptr [edx + field_2a8], 0x0         # 0047b293
    mov eax, dword ptr [ebp - local_4]           # 0047b29d
    mov dword ptr [eax + field_8], 0x0           # 0047b2a0
    mov ecx, dword ptr [ebp - local_4]           # 0047b2a7
    mov dword ptr [ecx + field_14], 0x0          # 0047b2aa
    mov edx, dword ptr [ebp - local_4]           # 0047b2b1
    mov dword ptr [edx + field_18], 0x0          # 0047b2b4
    mov eax, dword ptr [ebp - local_4]           # 0047b2bb
    mov dword ptr [eax + field_1c], 0x0          # 0047b2be
    mov ecx, dword ptr [ebp - local_4]           # 0047b2c5
    mov dword ptr [ecx + field_20], 0x0          # 0047b2c8
    mov edx, dword ptr [ebp - local_4]           # 0047b2cf
    mov dword ptr [edx + field_280], 0x0         # 0047b2d2
    mov eax, dword ptr [ebp - local_4]           # 0047b2dc
    mov dword ptr [eax + field_29c], 0x0         # 0047b2df
    mov ecx, dword ptr [ebp - local_4]           # 0047b2e9
    mov dword ptr [ecx + field_288], 0x0         # 0047b2ec
    mov edx, dword ptr [ebp - local_4]           # 0047b2f6
    mov dword ptr [edx + field_2a0], 0x0         # 0047b2f9
    mov eax, dword ptr [ebp - local_4]           # 0047b303
    mov dword ptr [eax + field_28c], 0x0         # 0047b306
    mov ecx, dword ptr [ebp - local_4]           # 0047b310
    mov dword ptr [ecx + field_2a4], 0x0         # 0047b313
    {load} mov esp, ebp                          # 0047b31d
    pop ebp                                      # 0047b31f
    ret                                          # 0047b320

