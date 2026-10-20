# FUN_0047ce6f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047ce6f
# extent:       0x0047ce6f-0x0047cf4e (223 code bytes)
# span:         0x0047ce6f-0x0047cf4e (code 223, tables 0, padding 0)
# sha256:       f53e38752eefe5817035cd9a0851bf5dd189663d9b8f792fdebf52e3cba7071c
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_wrong_sound_record_player
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_ee_runtime.h:65 says "a mismatch plays the "wrong" sound record at once (0x47ce6f)"
# name-note:    Picks a random sound record and plays it; used for the 'wrong' sound on a mismatch.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c, field_2bc, field_856; [ecx + n] field_c, field_856; [edx + n] field_c, field_2bc, field_856
# callees:      calls FUN_00516530, FUN_0050cd50, FUN_0047d02d
# track-n:      outputs/blackmoor-decomp/src/action_family_ee_runtime.c:pick_and_play (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 62 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_c, 0xc  # offset +0xc
.equ field_2bc, 0x2bc  # offset +0x2bc
.equ field_856, 0x856  # offset +0x856

# --- external targets -----------------------------------------------
.set FUN_0047d02d, .text + (0x0047d02d - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_00516530, .text + (0x00516530 - 0x401000)

.org 0x0047ce6f - 0x401000
.globl FUN_0047ce6f
FUN_0047ce6f:
    # block 0x0047ce6f: entry, 9 instruction(s), ends with forward jump to 0x0047ce9e
    push ebp                                     # 0047ce6f
    {load} mov ebp, esp                          # 0047ce70
    sub esp, 0xc                                 # 0047ce72
    mov dword ptr [ebp - local_c], ecx           # 0047ce75
    mov eax, dword ptr [ebp - local_c]           # 0047ce78
    mov dword ptr [eax + field_2bc], 0xffffffff  # 0047ce7b
    mov dword ptr [ebp - local_8], 0x0           # 0047ce85
    mov dword ptr [ebp - local_4], 0x0           # 0047ce8c
    jmp.d8 L_0047ce9e                            # 0047ce93
L_0047ce95:
    # block 0x0047ce95: entered by jmp at 0x0047ced5, 3 instruction(s), falls into the block at 0x0047ce9e
    mov ecx, dword ptr [ebp - local_4]           # 0047ce95
    add ecx, 0x1                                 # 0047ce98
    mov dword ptr [ebp - local_4], ecx           # 0047ce9b
L_0047ce9e:
    # block 0x0047ce9e: entered by jmp at 0x0047ce93, 2 instruction(s), ends with jge to 0x0047ced7 (forward)
    cmp dword ptr [ebp - local_4], 0xa           # 0047ce9e
    jge.d8 L_0047ced7                            # 0047cea2
    # block 0x0047cea4: entered by fall-through of jge at 0x0047cea2, 11 instruction(s), calls FUN_00516530, ends with je to 0x0047ced5 (forward)
    push 0x54d11c                                # 0047cea4
    mov edx, dword ptr [ebp - local_c]           # 0047cea9
    mov eax, dword ptr [edx + field_c]           # 0047ceac
    mov ecx, dword ptr [ebp - local_4]           # 0047ceaf
    imul ecx, ecx, 0xb6                          # 0047ceb2
    lea edx, [eax + ecx + field_856]             # 0047ceb8
    push edx                                     # 0047cebf
    call FUN_00516530                            # 0047cec0
    add esp, 0x8                                 # 0047cec5
    test eax, eax                                # 0047cec8
    je.d8 L_0047ced5                             # 0047ceca
    # block 0x0047cecc: entered by fall-through of je at 0x0047ceca, 2 instruction(s), ends with forward jump to 0x0047ced7
    mov dword ptr [ebp - local_8], 0x1           # 0047cecc
    jmp.d8 L_0047ced7                            # 0047ced3
L_0047ced5:
    # block 0x0047ced5: entered by je at 0x0047ceca, 1 instruction(s), ends with backward jump to 0x0047ce95
    jmp.d8 L_0047ce95                            # 0047ced5
L_0047ced7:
    # block 0x0047ced7: entered by jge at 0x0047cea2; jmp at 0x0047ced3, 2 instruction(s), ends with je to 0x0047cf4a (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0047ced7
    je.d8 L_0047cf4a                             # 0047cedb
L_0047cedd:
    # block 0x0047cedd: entered by jmp at 0x0047cf48; fall-through of je at 0x0047cedb, 18 instruction(s), calls FUN_0050cd50, FUN_00516530, ends with je to 0x0047cf48 (forward)
    call FUN_0050cd50                            # 0047cedd
    cdq                                          # 0047cee2
    mov ecx, 0xa                                 # 0047cee3
    idiv ecx                                     # 0047cee8
    mov eax, dword ptr [ebp - local_c]           # 0047ceea
    mov dword ptr [eax + field_2bc], edx         # 0047ceed
    push 0x54d128                                # 0047cef3
    mov ecx, dword ptr [ebp - local_c]           # 0047cef8
    mov edx, dword ptr [ecx + field_c]           # 0047cefb
    mov eax, dword ptr [ebp - local_c]           # 0047cefe
    mov ecx, dword ptr [eax + field_2bc]         # 0047cf01
    imul ecx, ecx, 0xb6                          # 0047cf07
    lea edx, [edx + ecx + field_856]             # 0047cf0d
    push edx                                     # 0047cf14
    call FUN_00516530                            # 0047cf15
    add esp, 0x8                                 # 0047cf1a
    test eax, eax                                # 0047cf1d
    je.d8 L_0047cf48                             # 0047cf1f
    # block 0x0047cf21: entered by fall-through of je at 0x0047cf1f, 10 instruction(s), calls FUN_0047d02d, ends with forward jump to 0x0047cf4a
    mov eax, dword ptr [ebp - local_c]           # 0047cf21
    mov ecx, dword ptr [eax + field_c]           # 0047cf24
    mov edx, dword ptr [ebp - local_c]           # 0047cf27
    mov eax, dword ptr [edx + field_2bc]         # 0047cf2a
    imul eax, eax, 0xb6                          # 0047cf30
    lea ecx, [ecx + eax + field_856]             # 0047cf36
    push ecx                                     # 0047cf3d
    mov ecx, dword ptr [ebp - local_c]           # 0047cf3e
    call FUN_0047d02d                            # 0047cf41
    jmp.d8 L_0047cf4a                            # 0047cf46
L_0047cf48:
    # block 0x0047cf48: entered by je at 0x0047cf1f, 1 instruction(s), ends with backward jump to 0x0047cedd
    jmp.d8 L_0047cedd                            # 0047cf48
L_0047cf4a:
    # block 0x0047cf4a: entered by je at 0x0047cedb; jmp at 0x0047cf46, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047cf4a
    pop ebp                                      # 0047cf4c
    ret                                          # 0047cf4d

