# FUN_00458045
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00458045
# extent:       0x00458045-0x0045807c (55 code bytes)
# span:         0x00458045-0x0045807c (code 55, tables 0, padding 0)
# sha256:       e72e11810ed840a37f490c4d03a61ec781d2cac223dae8659c2c1423ecd830f0
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00458045
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_24, field_98; [ecx + n] field_24
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_24, 0x24  # offset +0x24
.equ field_98, 0x98  # offset +0x98

# --- external targets -----------------------------------------------

.org 0x00458045 - 0x401000
.globl FUN_00458045
FUN_00458045:
    # block 0x00458045: entry, 7 instruction(s), ends with je to 0x00458078 (forward)
    push ebp                                     # 00458045
    {load} mov ebp, esp                          # 00458046
    push ecx                                     # 00458048
    mov dword ptr [ebp - local_4], ecx           # 00458049
    mov eax, dword ptr [ebp - local_4]           # 0045804c
    cmp dword ptr [eax + field_98], 0x0          # 0045804f
    je.d8 L_00458078                             # 00458056
    # block 0x00458058: entered by fall-through of je at 0x00458056, 4 instruction(s), ends with je to 0x00458078 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00458058
    movsx edx, word ptr [ecx + field_24]         # 0045805b
    cmp edx, -0x1                                # 0045805f
    je.d8 L_00458078                             # 00458062
    # block 0x00458064: entered by fall-through of je at 0x00458062, 4 instruction(s), falls into the block at 0x00458078
    mov eax, dword ptr [ebp - local_4]           # 00458064
    movsx ecx, word ptr [eax + field_24]         # 00458067
    imul ecx, ecx, 0x4a                          # 0045806b
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0045806e
L_00458078:
    # block 0x00458078: entered by je at 0x00458056; je at 0x00458062, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00458078
    pop ebp                                      # 0045807a
    ret                                          # 0045807b

