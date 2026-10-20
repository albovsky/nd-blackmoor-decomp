# FUN_0047cf4e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047cf4e
# extent:       0x0047cf4e-0x0047d02d (223 code bytes)
# span:         0x0047cf4e-0x0047d02d (code 223, tables 0, padding 0)
# sha256:       74fe1246fd0e96f87f1c7fa91fcc3131266024eb19d402950792fd4329662d9f
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_random_sound_record_player_alt
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_ee_runtime.c:316 says "0x47cd90 / 0x47ce6f / 0x47cf4e: pick a sound record other than "NO SOUND" at random and play it."
# name-note:    Picks a sound record other than NO SOUND at random and plays it.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_c, field_2c0, field_f72; [ecx + n] field_c, field_f72; [edx + n] field_c, field_2c0, field_f72
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
.equ field_2c0, 0x2c0  # offset +0x2c0
.equ field_f72, 0xf72  # offset +0xf72

# --- external targets -----------------------------------------------
.set FUN_0047d02d, .text + (0x0047d02d - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)
.set FUN_00516530, .text + (0x00516530 - 0x401000)

.org 0x0047cf4e - 0x401000
.globl FUN_0047cf4e
FUN_0047cf4e:
    # block 0x0047cf4e: entry, 9 instruction(s), ends with forward jump to 0x0047cf7d
    push ebp                                     # 0047cf4e
    {load} mov ebp, esp                          # 0047cf4f
    sub esp, 0xc                                 # 0047cf51
    mov dword ptr [ebp - local_c], ecx           # 0047cf54
    mov eax, dword ptr [ebp - local_c]           # 0047cf57
    mov dword ptr [eax + field_2c0], 0xffffffff  # 0047cf5a
    mov dword ptr [ebp - local_8], 0x0           # 0047cf64
    mov dword ptr [ebp - local_4], 0x0           # 0047cf6b
    jmp.d8 L_0047cf7d                            # 0047cf72
L_0047cf74:
    # block 0x0047cf74: entered by jmp at 0x0047cfb4, 3 instruction(s), falls into the block at 0x0047cf7d
    mov ecx, dword ptr [ebp - local_4]           # 0047cf74
    add ecx, 0x1                                 # 0047cf77
    mov dword ptr [ebp - local_4], ecx           # 0047cf7a
L_0047cf7d:
    # block 0x0047cf7d: entered by jmp at 0x0047cf72, 2 instruction(s), ends with jge to 0x0047cfb6 (forward)
    cmp dword ptr [ebp - local_4], 0xa           # 0047cf7d
    jge.d8 L_0047cfb6                            # 0047cf81
    # block 0x0047cf83: entered by fall-through of jge at 0x0047cf81, 11 instruction(s), calls FUN_00516530, ends with je to 0x0047cfb4 (forward)
    push 0x54d134                                # 0047cf83
    mov edx, dword ptr [ebp - local_c]           # 0047cf88
    mov eax, dword ptr [edx + field_c]           # 0047cf8b
    mov ecx, dword ptr [ebp - local_4]           # 0047cf8e
    imul ecx, ecx, 0xb6                          # 0047cf91
    lea edx, [eax + ecx + field_f72]             # 0047cf97
    push edx                                     # 0047cf9e
    call FUN_00516530                            # 0047cf9f
    add esp, 0x8                                 # 0047cfa4
    test eax, eax                                # 0047cfa7
    je.d8 L_0047cfb4                             # 0047cfa9
    # block 0x0047cfab: entered by fall-through of je at 0x0047cfa9, 2 instruction(s), ends with forward jump to 0x0047cfb6
    mov dword ptr [ebp - local_8], 0x1           # 0047cfab
    jmp.d8 L_0047cfb6                            # 0047cfb2
L_0047cfb4:
    # block 0x0047cfb4: entered by je at 0x0047cfa9, 1 instruction(s), ends with backward jump to 0x0047cf74
    jmp.d8 L_0047cf74                            # 0047cfb4
L_0047cfb6:
    # block 0x0047cfb6: entered by jge at 0x0047cf81; jmp at 0x0047cfb2, 2 instruction(s), ends with je to 0x0047d029 (forward)
    cmp dword ptr [ebp - local_8], 0x0           # 0047cfb6
    je.d8 L_0047d029                             # 0047cfba
L_0047cfbc:
    # block 0x0047cfbc: entered by jmp at 0x0047d027; fall-through of je at 0x0047cfba, 18 instruction(s), calls FUN_0050cd50, FUN_00516530, ends with je to 0x0047d027 (forward)
    call FUN_0050cd50                            # 0047cfbc
    cdq                                          # 0047cfc1
    mov ecx, 0xa                                 # 0047cfc2
    idiv ecx                                     # 0047cfc7
    mov eax, dword ptr [ebp - local_c]           # 0047cfc9
    mov dword ptr [eax + field_2c0], edx         # 0047cfcc
    push 0x54d140                                # 0047cfd2
    mov ecx, dword ptr [ebp - local_c]           # 0047cfd7
    mov edx, dword ptr [ecx + field_c]           # 0047cfda
    mov eax, dword ptr [ebp - local_c]           # 0047cfdd
    mov ecx, dword ptr [eax + field_2c0]         # 0047cfe0
    imul ecx, ecx, 0xb6                          # 0047cfe6
    lea edx, [edx + ecx + field_f72]             # 0047cfec
    push edx                                     # 0047cff3
    call FUN_00516530                            # 0047cff4
    add esp, 0x8                                 # 0047cff9
    test eax, eax                                # 0047cffc
    je.d8 L_0047d027                             # 0047cffe
    # block 0x0047d000: entered by fall-through of je at 0x0047cffe, 10 instruction(s), calls FUN_0047d02d, ends with forward jump to 0x0047d029
    mov eax, dword ptr [ebp - local_c]           # 0047d000
    mov ecx, dword ptr [eax + field_c]           # 0047d003
    mov edx, dword ptr [ebp - local_c]           # 0047d006
    mov eax, dword ptr [edx + field_2c0]         # 0047d009
    imul eax, eax, 0xb6                          # 0047d00f
    lea ecx, [ecx + eax + field_f72]             # 0047d015
    push ecx                                     # 0047d01c
    mov ecx, dword ptr [ebp - local_c]           # 0047d01d
    call FUN_0047d02d                            # 0047d020
    jmp.d8 L_0047d029                            # 0047d025
L_0047d027:
    # block 0x0047d027: entered by je at 0x0047cffe, 1 instruction(s), ends with backward jump to 0x0047cfbc
    jmp.d8 L_0047cfbc                            # 0047d027
L_0047d029:
    # block 0x0047d029: entered by je at 0x0047cfba; jmp at 0x0047d025, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0047d029
    pop ebp                                      # 0047d02b
    ret                                          # 0047d02c

