# FUN_0045dd4d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045dd4d
# extent:       0x0045dd4d-0x0045dd96 (73 code bytes)
# span:         0x0045dd4d-0x0045dd96 (code 73, tables 0, padding 0)
# sha256:       416edde92dd8c6283ddc11680ad06db7abd566b7199b4becea703b4eba6c5d3d
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045dd4d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0045dc8a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0045dc8a, .text + (0x0045dc8a - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0045dd4d - 0x401000
.globl FUN_0045dd4d
FUN_0045dd4d:
    # block 0x0045dd4d: entry, 7 instruction(s), ends with je to 0x0045dd6e (forward)
    push ebp                                     # 0045dd4d
    {load} mov ebp, esp                          # 0045dd4e
    push ecx                                     # 0045dd50
    mov dword ptr [ebp - local_4], ecx           # 0045dd51
    mov eax, dword ptr [ebp - local_4]           # 0045dd54
    cmp dword ptr [eax + field_20], 0x0          # 0045dd57
    je.d8 L_0045dd6e                             # 0045dd5b
    # block 0x0045dd5d: entered by fall-through of je at 0x0045dd5b, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0045dd6e
    mov ecx, dword ptr [ebp - local_4]           # 0045dd5d
    add ecx, 0x20                                # 0045dd60
    push ecx                                     # 0045dd63
    mov ecx, 0x5cf659                            # 0045dd64
    call FUN_004c2dfb                            # 0045dd69
L_0045dd6e:
    # block 0x0045dd6e: entered by je at 0x0045dd5b, 4 instruction(s), ends with je to 0x0045dd8a (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045dd6e
    movsx eax, word ptr [edx + field_1c]         # 0045dd71
    cmp eax, -0x1                                # 0045dd75
    je.d8 L_0045dd8a                             # 0045dd78
    # block 0x0045dd7a: entered by fall-through of je at 0x0045dd78, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0045dd8a
    mov ecx, dword ptr [ebp - local_4]           # 0045dd7a
    mov dx, word ptr [ecx + field_1c]            # 0045dd7d
    push edx                                     # 0045dd81
    call FUN_004d3992                            # 0045dd82
    add esp, 0x4                                 # 0045dd87
L_0045dd8a:
    # block 0x0045dd8a: entered by je at 0x0045dd78, 5 instruction(s), calls FUN_0045dc8a, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0045dd8a
    call FUN_0045dc8a                            # 0045dd8d
    {load} mov esp, ebp                          # 0045dd92
    pop ebp                                      # 0045dd94
    ret                                          # 0045dd95

