# FUN_004e0619
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e0619
# extent:       0x004e0619-0x004e069c (131 code bytes)
# span:         0x004e0619-0x004e069c (code 131, tables 0, padding 0)
# sha256:       f233cdb06d2ea331ed494c69f1d06fbcf1c479aaf6a0e4131a517111530c65ea
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e0619_lifted
# naming:       native port src/original_methods_fl39d.c:m4e0619_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (12 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_74f, field_753, field_757; [ecx + n] field_753; [edx + n] field_753
# callees:      calls FUN_004c2dfb, FUN_004e1d34, FUN_004e04f3
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e0619_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_74f, 0x74f  # offset +0x74f
.equ field_753, 0x753  # offset +0x753
.equ field_757, 0x757  # offset +0x757

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004e04f3, .text + (0x004e04f3 - 0x401000)
.set FUN_004e1d34, .text + (0x004e1d34 - 0x401000)

.org 0x004e0619 - 0x401000
.globl FUN_004e0619
FUN_004e0619:
    # block 0x004e0619: entry, 7 instruction(s), ends with je to 0x004e0640 (forward)
    push ebp                                     # 004e0619
    {load} mov ebp, esp                          # 004e061a
    push ecx                                     # 004e061c
    mov dword ptr [ebp - local_4], ecx           # 004e061d
    mov eax, dword ptr [ebp - local_4]           # 004e0620
    cmp dword ptr [eax + field_74f], 0x0         # 004e0623
    je.d8 L_004e0640                             # 004e062a
    # block 0x004e062c: entered by fall-through of je at 0x004e062a, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e0640
    mov ecx, dword ptr [ebp - local_4]           # 004e062c
    add ecx, 0x74f                               # 004e062f
    push ecx                                     # 004e0635
    mov ecx, 0x5cf659                            # 004e0636
    call FUN_004c2dfb                            # 004e063b
L_004e0640:
    # block 0x004e0640: entered by je at 0x004e062a, 3 instruction(s), ends with forward jump to 0x004e0664
    mov edx, dword ptr [ebp - local_4]           # 004e0640
    mov dword ptr [edx + field_753], 0x0         # 004e0643
    jmp.d8 L_004e0664                            # 004e064d
L_004e064f:
    # block 0x004e064f: entered by jmp at 0x004e068e, 5 instruction(s), falls into the block at 0x004e0664
    mov eax, dword ptr [ebp - local_4]           # 004e064f
    mov ecx, dword ptr [eax + field_753]         # 004e0652
    add ecx, 0x1                                 # 004e0658
    mov edx, dword ptr [ebp - local_4]           # 004e065b
    mov dword ptr [edx + field_753], ecx         # 004e065e
L_004e0664:
    # block 0x004e0664: entered by jmp at 0x004e064d, 3 instruction(s), ends with jge to 0x004e0690 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004e0664
    cmp dword ptr [eax + field_753], 0x5         # 004e0667
    jge.d8 L_004e0690                            # 004e066e
    # block 0x004e0670: entered by fall-through of jge at 0x004e066e, 7 instruction(s), calls FUN_004e1d34, ends with backward jump to 0x004e064f
    mov ecx, dword ptr [ebp - local_4]           # 004e0670
    mov edx, dword ptr [ecx + field_753]         # 004e0673
    imul edx, edx, 0x18f                         # 004e0679
    mov eax, dword ptr [ebp - local_4]           # 004e067f
    lea ecx, [eax + edx + field_757]             # 004e0682
    call FUN_004e1d34                            # 004e0689
    jmp.d8 L_004e064f                            # 004e068e
L_004e0690:
    # block 0x004e0690: entered by jge at 0x004e066e, 5 instruction(s), calls FUN_004e04f3, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 004e0690
    call FUN_004e04f3                            # 004e0693
    {load} mov esp, ebp                          # 004e0698
    pop ebp                                      # 004e069a
    ret                                          # 004e069b

