# FUN_0047cd90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047cd90
# extent:       0x0047cd90-0x0047ce6f (223 code bytes)
# span:         0x0047cd90-0x0047ce6f (code 223, tables 0, padding 0)
# sha256:       bdf6e9cc6fe545851cc51e94bbcf082503cdd8ec153c66282400ae6fcd144c25
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47cd90_pick_variant_a
# naming:       native port src/original_methods_fl31c.c:m47cd90_pick_variant_a (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Scans 5 records with 0x516530, then draws 0x50cd50 % 5 until a record passes the second compare, calls 0x47d02d; selector +0x2b8; shared static helper; 62/62 instr, 8/8 directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c, field_2b8, field_4c8; [ecx + n] field_c, field_4c8; [edx + n] field_c, field_2b8, field_4c8
# callees:      calls FUN_00516530, FUN_0050cd50, FUN_0047d02d
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31c.c:m47cd90_pick_variant_a (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 62 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_c, 0xc  # offset +0xc
.equ field_2b8, 0x2b8  # offset +0x2b8
.equ field_4c8, 0x4c8  # offset +0x4c8

# --- external targets -----------------------------------------------
.set FUN_0047d02d, .text + (0x0047d02d - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_00516530, .text + (0x00516530 - 0x401000)

.org 0x0047cd90 - 0x401000
.globl FUN_0047cd90
FUN_0047cd90:
    # block 0x0047cd90: entry, 9 instruction(s), ends with forward jump to 0x0047cdbf
    push ebp                                     # 0047cd90
    {load} mov ebp, esp                          # 0047cd91
    sub esp, 0xc                                 # 0047cd93
    mov dword ptr [ebp - local_c], ecx           # 0047cd96
    mov eax, dword ptr [ebp - local_c]           # 0047cd99
    mov dword ptr [eax + field_2b8], 0xffffffff  # 0047cd9c
    mov dword ptr [ebp - local_8], 0x0           # 0047cda6
    mov dword ptr [ebp - local_4], 0x0           # 0047cdad
    jmp.d8 L_0047cdbf                            # 0047cdb4
L_0047cdb6:
    # block 0x0047cdb6: entered by jmp at 0x0047cdf6, 3 instruction(s), falls into the block at 0x0047cdbf
    mov ecx, dword ptr [ebp - local_4]           # 0047cdb6
    add ecx, 0x1                                 # 0047cdb9
    mov dword ptr [ebp - local_4], ecx           # 0047cdbc
L_0047cdbf:
    # block 0x0047cdbf: entered by jmp at 0x0047cdb4, 2 instruction(s), ends with jge to 0x0047cdf8 (forward)
    cmp dword ptr [ebp - local_4], 0x5           # 0047cdbf
    jge.d8 L_0047cdf8                            # 0047cdc3
    # block 0x0047cdc5: entered by fall-through of jge at 0x0047cdc3, 11 instruction(s), calls FUN_00516530, ends with je to 0x0047cdf6 (forward)
    push 0x54d104                                # 0047cdc5
    mov edx, dword ptr [ebp - local_c]           # 0047cdca
    mov eax, dword ptr [edx + field_c]           # 0047cdcd
    mov ecx, dword ptr [ebp - local_4]           # 0047cdd0
    imul ecx, ecx, 0xb6                          # 0047cdd3
    lea edx, [eax + ecx + field_4c8]             # 0047cdd9
    push edx                                     # 0047cde0
    call FUN_00516530                            # 0047cde1
    add esp, 0x8                                 # 0047cde6
    test eax, eax                                # 0047cde9
    je.d8 L_0047cdf6                             # 0047cdeb
    # block 0x0047cded: entered by fall-through of je at 0x0047cdeb, 2 instruction(s), ends with forward jump to 0x0047cdf8
    mov dword ptr [ebp - local_8], 0x1           # 0047cded
    jmp.d8 L_0047cdf8                            # 0047cdf4
L_0047cdf6:
    # block 0x0047cdf6: entered by je at 0x0047cdeb, 1 instruction(s), ends with backward jump to 0x0047cdb6
    jmp.d8 L_0047cdb6                            # 0047cdf6
L_0047cdf8:
    # block 0x0047cdf8: entered by jge at 0x0047cdc3; jmp at 0x0047cdf4, 2 instruction(s), ends with je to 0x0047ce6b (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0047cdf8
    je.d8 L_0047ce6b                             # 0047cdfc
L_0047cdfe:
    # block 0x0047cdfe: entered by jmp at 0x0047ce69; fall-through of je at 0x0047cdfc, 18 instruction(s), calls FUN_0050cd50, FUN_00516530, ends with je to 0x0047ce69 (forward)
    call FUN_0050cd50                            # 0047cdfe
    cdq                                          # 0047ce03
    mov ecx, 0x5                                 # 0047ce04
    idiv ecx                                     # 0047ce09
    mov eax, dword ptr [ebp - local_c]           # 0047ce0b
    mov dword ptr [eax + field_2b8], edx         # 0047ce0e
    push 0x54d110                                # 0047ce14
    mov ecx, dword ptr [ebp - local_c]           # 0047ce19
    mov edx, dword ptr [ecx + field_c]           # 0047ce1c
    mov eax, dword ptr [ebp - local_c]           # 0047ce1f
    mov ecx, dword ptr [eax + field_2b8]         # 0047ce22
    imul ecx, ecx, 0xb6                          # 0047ce28
    lea edx, [edx + ecx + field_4c8]             # 0047ce2e
    push edx                                     # 0047ce35
    call FUN_00516530                            # 0047ce36
    add esp, 0x8                                 # 0047ce3b
    test eax, eax                                # 0047ce3e
    je.d8 L_0047ce69                             # 0047ce40
    # block 0x0047ce42: entered by fall-through of je at 0x0047ce40, 10 instruction(s), calls FUN_0047d02d, ends with forward jump to 0x0047ce6b
    mov eax, dword ptr [ebp - local_c]           # 0047ce42
    mov ecx, dword ptr [eax + field_c]           # 0047ce45
    mov edx, dword ptr [ebp - local_c]           # 0047ce48
    mov eax, dword ptr [edx + field_2b8]         # 0047ce4b
    imul eax, eax, 0xb6                          # 0047ce51
    lea ecx, [ecx + eax + field_4c8]             # 0047ce57
    push ecx                                     # 0047ce5e
    mov ecx, dword ptr [ebp - local_c]           # 0047ce5f
    call FUN_0047d02d                            # 0047ce62
    jmp.d8 L_0047ce6b                            # 0047ce67
L_0047ce69:
    # block 0x0047ce69: entered by je at 0x0047ce40, 1 instruction(s), ends with backward jump to 0x0047cdfe
    jmp.d8 L_0047cdfe                            # 0047ce69
L_0047ce6b:
    # block 0x0047ce6b: entered by je at 0x0047cdfc; jmp at 0x0047ce67, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047ce6b
    pop ebp                                      # 0047ce6d
    ret                                          # 0047ce6e

