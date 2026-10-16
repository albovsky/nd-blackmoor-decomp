# FUN_004ee86f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ee86f
# extent:       0x004ee86f-0x004ee943 (212 code bytes)
# span:         0x004ee86f-0x004ee950 (code 212, tables 0, padding 13)
# sha256:       6ecd8ef12223fbacdb4100f7e8f979c211ac70f584f48248c05020083f940dbc
# evidence:     ev_78bf7b8051c4829a48ca604612d5796f301092cb8406263fd1630b9c874c5c2a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ee86f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_252, field_4ab, field_4af; [ecx + n] field_4af; [edx + n] field_15f, field_4af
# callees:      calls FUN_004c5377, FUN_004e2b99, FUN_004eff03
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 61 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_15f, 0x15f  # offset +0x15f
.equ field_252, 0x252  # offset +0x252
.equ field_4ab, 0x4ab  # offset +0x4ab
.equ field_4af, 0x4af  # offset +0x4af

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004e2b99, .text + (0x004e2b99 - 0x401000)
.set FUN_004eff03, .text + (0x004eff03 - 0x401000)

.org 0x004ee86f - 0x401000
.globl FUN_004ee86f
FUN_004ee86f:
    # block 0x004ee86f: entry, 7 instruction(s), ends with je to 0x004ee893 (forward)
    push ebp                                     # 004ee86f
    {load} mov ebp, esp                          # 004ee870
    push ecx                                     # 004ee872
    mov dword ptr [ebp - local_4], ecx           # 004ee873
    mov eax, dword ptr [ebp - local_4]           # 004ee876
    cmp dword ptr [eax + field_4af], 0x2         # 004ee879
    je.d8 L_004ee893                             # 004ee880
    # block 0x004ee882: entered by fall-through of je at 0x004ee880, 3 instruction(s), ends with je to 0x004ee893 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ee882
    cmp dword ptr [ecx + field_4af], 0x3         # 004ee885
    je.d8 L_004ee893                             # 004ee88c
    # block 0x004ee88e: entered by fall-through of je at 0x004ee88c, 1 instruction(s), ends with forward jump to 0x004ee93f
    jmp.d32 L_004ee93f                           # 004ee88e
L_004ee893:
    # block 0x004ee893: entered by je at 0x004ee880; je at 0x004ee88c, 3 instruction(s), ends with jne to 0x004ee8cf (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ee893
    cmp dword ptr [edx + field_4af], 0x2         # 004ee896
    jne.d8 L_004ee8cf                            # 004ee89d
    # block 0x004ee89f: entered by fall-through of jne at 0x004ee89d, 15 instruction(s), calls FUN_004c5377, ends with forward jump to 0x004ee90b
    push 0x55cddc                                # 004ee89f
    mov eax, dword ptr [ebp - local_4]           # 004ee8a4
    add eax, 0x1c                                # 004ee8a7
    push eax                                     # 004ee8aa
    mov ecx, dword ptr [ebp - local_4]           # 004ee8ab
    add ecx, 0x53                                # 004ee8ae
    push ecx                                     # 004ee8b1
    mov edx, dword ptr [0x5cf665]                # 004ee8b2
    push edx                                     # 004ee8b8
    mov eax, dword ptr [ebp - local_4]           # 004ee8b9
    mov ecx, dword ptr [eax + field_4ab]         # 004ee8bc
    push ecx                                     # 004ee8c2
    mov ecx, 0x5cf659                            # 004ee8c3
    call FUN_004c5377                            # 004ee8c8
    jmp.d8 L_004ee90b                            # 004ee8cd
L_004ee8cf:
    # block 0x004ee8cf: entered by jne at 0x004ee89d, 3 instruction(s), ends with jne to 0x004ee90b (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ee8cf
    cmp dword ptr [edx + field_4af], 0x3         # 004ee8d2
    jne.d8 L_004ee90b                            # 004ee8d9
    # block 0x004ee8db: entered by fall-through of jne at 0x004ee8d9, 14 instruction(s), calls FUN_004c5377, falls into the block at 0x004ee90b
    push 0x55cdf8                                # 004ee8db
    mov eax, dword ptr [ebp - local_4]           # 004ee8e0
    add eax, 0x665                               # 004ee8e3
    push eax                                     # 004ee8e8
    mov ecx, dword ptr [ebp - local_4]           # 004ee8e9
    add ecx, 0x63                                # 004ee8ec
    push ecx                                     # 004ee8ef
    mov edx, dword ptr [0x5cf665]                # 004ee8f0
    push edx                                     # 004ee8f6
    mov eax, dword ptr [ebp - local_4]           # 004ee8f7
    mov ecx, dword ptr [eax + field_4ab]         # 004ee8fa
    push ecx                                     # 004ee900
    mov ecx, 0x5cf659                            # 004ee901
    call FUN_004c5377                            # 004ee906
L_004ee90b:
    # block 0x004ee90b: entered by jmp at 0x004ee8cd; jne at 0x004ee8d9, 3 instruction(s), ends with je to 0x004ee925 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ee90b
    cmp dword ptr [edx + field_15f], 0x0         # 004ee90e
    je.d8 L_004ee925                             # 004ee915
    # block 0x004ee917: entered by fall-through of je at 0x004ee915, 3 instruction(s), calls FUN_004e2b99, falls into the block at 0x004ee925
    mov ecx, dword ptr [ebp - local_4]           # 004ee917
    add ecx, 0x31c                               # 004ee91a
    call FUN_004e2b99                            # 004ee920
L_004ee925:
    # block 0x004ee925: entered by je at 0x004ee915, 3 instruction(s), ends with je to 0x004ee93f (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ee925
    cmp dword ptr [eax + field_252], 0x0         # 004ee928
    je.d8 L_004ee93f                             # 004ee92f
    # block 0x004ee931: entered by fall-through of je at 0x004ee92f, 3 instruction(s), calls FUN_004eff03, falls into the block at 0x004ee93f
    mov ecx, dword ptr [ebp - local_4]           # 004ee931
    add ecx, 0x4b7                               # 004ee934
    call FUN_004eff03                            # 004ee93a
L_004ee93f:
    # block 0x004ee93f: entered by jmp at 0x004ee88e; je at 0x004ee92f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ee93f
    pop ebp                                      # 004ee941
    ret                                          # 004ee942

# --- data items (not part of the function) -------------------------
.org 0x004ee943 - 0x401000
PAD_004ee943:  # 13 byte(s) of int3 padding
    .fill 13, 1, 0xcc

