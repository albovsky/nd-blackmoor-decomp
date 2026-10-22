# FUN_004111a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004111a0
# extent:       0x004111a0-0x00411215 (117 code bytes)
# span:         0x004111a0-0x00411215 (code 117, tables 0, padding 0)
# sha256:       07fd5e24ff5544e43015ac6457746f59891002cc957692116c307301e09b3b7b
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004111a0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4111a0_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 38 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------

.org 0x004111a0 - 0x401000
.globl FUN_004111a0
FUN_004111a0:
    # block 0x004111a0: entry, 8 instruction(s), ends with forward jump to 0x004111bd
    push ebp                                     # 004111a0
    {load} mov ebp, esp                          # 004111a1
    sub esp, 0xc                                 # 004111a3
    push esi                                     # 004111a6
    push edi                                     # 004111a7
    mov dword ptr [ebp - local_c], ecx           # 004111a8
    mov dword ptr [ebp - local_8], 0x0           # 004111ab
    jmp.d8 L_004111bd                            # 004111b2
L_004111b4:
    # block 0x004111b4: entered by jmp at 0x0041120d, 3 instruction(s), falls into the block at 0x004111bd
    mov eax, dword ptr [ebp - local_8]           # 004111b4
    add eax, 0x1                                 # 004111b7
    mov dword ptr [ebp - local_8], eax           # 004111ba
L_004111bd:
    # block 0x004111bd: entered by jmp at 0x004111b2, 2 instruction(s), ends with jge to 0x0041120f (forward)
    cmp dword ptr [ebp - local_8], 0x3           # 004111bd
    jge.d8 L_0041120f                            # 004111c1
    # block 0x004111c3: entered by fall-through of jge at 0x004111c1, 2 instruction(s), ends with forward jump to 0x004111d5
    mov dword ptr [ebp - local_4], 0x0           # 004111c3
    jmp.d8 L_004111d5                            # 004111ca
L_004111cc:
    # block 0x004111cc: entered by jmp at 0x004111fe, 3 instruction(s), falls into the block at 0x004111d5
    mov ecx, dword ptr [ebp - local_4]           # 004111cc
    add ecx, 0x1                                 # 004111cf
    mov dword ptr [ebp - local_4], ecx           # 004111d2
L_004111d5:
    # block 0x004111d5: entered by jmp at 0x004111ca, 2 instruction(s), ends with jge to 0x00411200 (forward)
    cmp dword ptr [ebp - local_4], 0x190         # 004111d5
    jge.d8 L_00411200                            # 004111dc
    # block 0x004111de: entered by fall-through of jge at 0x004111dc, 10 instruction(s), ends with backward jump to 0x004111cc
    mov ecx, 0x8                                 # 004111de
    {load} xor eax, eax                          # 004111e3
    mov edx, dword ptr [ebp - local_8]           # 004111e5
    imul edx, edx, 0x3390                        # 004111e8
    mov esi, dword ptr [ebp - local_4]           # 004111ee
    imul esi, esi, 0x21                          # 004111f1
    lea edi, [edx + esi + 0x5957cb]              # 004111f4
    rep stosd dword ptr es:[edi], eax            # 004111fb
    stosb byte ptr es:[edi], al                  # 004111fd
    jmp.d8 L_004111cc                            # 004111fe
L_00411200:
    # block 0x00411200: entered by jge at 0x004111dc, 3 instruction(s), ends with backward jump to 0x004111b4
    mov eax, dword ptr [ebp - local_8]           # 00411200
    mov word ptr [2*eax + 0x59fbdb], 0x0         # 00411203
    jmp.d8 L_004111b4                            # 0041120d
L_0041120f:
    # block 0x0041120f: entered by jge at 0x004111c1, 5 instruction(s), ends with ret
    pop edi                                      # 0041120f
    pop esi                                      # 00411210
    {load} mov esp, ebp                          # 00411211
    pop ebp                                      # 00411213
    ret                                          # 00411214

