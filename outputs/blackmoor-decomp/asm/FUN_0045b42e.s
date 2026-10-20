# FUN_0045b42e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b42e
# extent:       0x0045b42e-0x0045b477 (73 code bytes)
# span:         0x0045b42e-0x0045b477 (code 73, tables 0, padding 0)
# sha256:       8c41eba777fc7fde61077839ea84c321cc4a834e50074bfe9b74aecb2d345122
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45b42e_begin_scene
# naming:       native port src/original_methods_fl17.c:m45b42e_begin_scene (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m45b42e_begin_scene; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 73 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_0045b3ea
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m45b42e_begin_scene (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0045b3ea, .text + (0x0045b3ea - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x0045b42e - 0x401000
.globl FUN_0045b42e
FUN_0045b42e:
    # block 0x0045b42e: entry, 7 instruction(s), ends with je to 0x0045b44f (forward)
    push ebp                                     # 0045b42e
    {load} mov ebp, esp                          # 0045b42f
    push ecx                                     # 0045b431
    mov dword ptr [ebp - local_4], ecx           # 0045b432
    mov eax, dword ptr [ebp - local_4]           # 0045b435
    cmp dword ptr [eax + field_20], 0x0          # 0045b438
    je.d8 L_0045b44f                             # 0045b43c
    # block 0x0045b43e: entered by fall-through of je at 0x0045b43c, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x0045b44f
    mov ecx, dword ptr [ebp - local_4]           # 0045b43e
    add ecx, 0x20                                # 0045b441
    push ecx                                     # 0045b444
    mov ecx, 0x5cf659                            # 0045b445
    call FUN_004c2dfb                            # 0045b44a
L_0045b44f:
    # block 0x0045b44f: entered by je at 0x0045b43c, 4 instruction(s), ends with je to 0x0045b46b (forward)
    mov edx, dword ptr [ebp - local_4]           # 0045b44f
    movsx eax, word ptr [edx + field_1c]         # 0045b452
    cmp eax, -0x1                                # 0045b456
    je.d8 L_0045b46b                             # 0045b459
    # block 0x0045b45b: entered by fall-through of je at 0x0045b459, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0045b46b
    mov ecx, dword ptr [ebp - local_4]           # 0045b45b
    mov dx, word ptr [ecx + field_1c]            # 0045b45e
    push edx                                     # 0045b462
    call FUN_004d3992                            # 0045b463
    add esp, 0x4                                 # 0045b468
L_0045b46b:
    # block 0x0045b46b: entered by je at 0x0045b459, 5 instruction(s), calls FUN_0045b3ea, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0045b46b
    call FUN_0045b3ea                            # 0045b46e
    {load} mov esp, ebp                          # 0045b473
    pop ebp                                      # 0045b475
    ret                                          # 0045b476

