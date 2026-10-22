# FUN_004015fb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004015fb
# extent:       0x004015fb-0x0040167f (132 code bytes)
# span:         0x004015fb-0x0040167f (code 132, tables 0, padding 0)
# sha256:       b03484ad811b81567532ae880cef079c06cebf085b8b465f12a96ade9fbf58fc
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004015fb
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_80, local_84, local_88, local_8c, local_90
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401589, FUN_0051d4c4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4015fb_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 32 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c
.equ local_90, 0x90  # offset -0x90

# --- external targets -----------------------------------------------
.set FUN_00401589, .text + (0x00401589 - 0x401000)
.set FUN_0051d4c4, .text + (0x0051d4c4 - 0x401000)

.org 0x004015fb - 0x401000
.globl FUN_004015fb
FUN_004015fb:
    # block 0x004015fb: entry, 7 instruction(s), ends with forward jump to 0x00401630
    push ebp                                     # 004015fb
    {load} mov ebp, esp                          # 004015fc
    sub esp, 0x90                                # 004015fe
    mov dword ptr [ebp - local_90], ecx          # 00401604
    mov word ptr [ebp - local_84], 0x34          # 0040160a
    mov word ptr [ebp - local_8c], 0x0           # 00401613
    jmp.d8 L_00401630                            # 0040161c
L_0040161e:
    # block 0x0040161e: entered by jmp at 0x00401677, 3 instruction(s), falls into the block at 0x00401630
    mov ax, word ptr [ebp - local_8c]            # 0040161e
    .insn 0x66, 0x05, 0x0001{:u16}               # 00401625
    mov word ptr [ebp - local_8c], ax            # 00401629
L_00401630:
    # block 0x00401630: entered by jmp at 0x0040161c, 4 instruction(s), ends with jge to 0x00401679 (forward)
    movsx ecx, word ptr [ebp - local_8c]         # 00401630
    movsx edx, word ptr [ebp - local_84]         # 00401637
    {load} cmp ecx, edx                          # 0040163e
    jge.d8 L_00401679                            # 00401640
    # block 0x00401642: entered by fall-through of jge at 0x00401640, 15 instruction(s), calls FUN_00401589, FUN_0051d4c4, ends with backward jump to 0x0040161e
    lea eax, [ebp - local_88]                    # 00401642
    push eax                                     # 00401648
    lea ecx, [ebp - local_80]                    # 00401649
    push ecx                                     # 0040164c
    mov dx, word ptr [ebp - local_8c]            # 0040164d
    push edx                                     # 00401654
    mov ecx, dword ptr [ebp - local_90]          # 00401655
    call FUN_00401589                            # 0040165b
    lea eax, [ebp - local_80]                    # 00401660
    push eax                                     # 00401663
    movsx ecx, word ptr [ebp - local_88]         # 00401664
    push ecx                                     # 0040166b
    mov ecx, dword ptr [ebp - local_90]          # 0040166c
    call FUN_0051d4c4                            # 00401672
    jmp.d8 L_0040161e                            # 00401677
L_00401679:
    # block 0x00401679: entered by jge at 0x00401640, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 00401679
    pop ebp                                      # 0040167b
    ret 0x4                                      # 0040167c

