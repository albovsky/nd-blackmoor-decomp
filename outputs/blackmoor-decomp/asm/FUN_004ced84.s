# FUN_004ced84
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ced84
# extent:       0x004ced84-0x004cf026 (674 code bytes)
# span:         0x004ced84-0x004cf026 (code 674, tables 0, padding 0)
# sha256:       2a0c3ff70a2cb090b0663c15f75de9852ecbcf5afbefc4baadc0d87bd20cedef
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_random_movie_2e_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/session_bindings_a2e.h:76 says "handler 0x4ced84 on the object"
# name-note:    Handler of raw 0x2e random-movie control, acting on the random-movie object.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_3, field_9, field_d, field_206, field_23a, field_23e, field_242, field_25a; [ecx + n] field_1, field_7, field_b, field_1de, field_23a, field_23e, field_242, field_25a; [edx + n] field_1, field_5, field_9, field_1de, field_206, field_216, field_242
# callees:      calls FUN_0050ca3e, FUN_0044a2b7, FUN_004ceb3b
# track-n:      outputs/blackmoor-decomp/src/blackmoor_app.mm:create_native_scene_session (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 146 instruction(s), 12 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1, 0x1  # offset +0x1
.equ field_3, 0x3  # offset +0x3
.equ field_5, 0x5  # offset +0x5
.equ field_7, 0x7  # offset +0x7
.equ arg_8, 0x8  # offset +0x8
.equ field_9, 0x9  # offset +0x9
.equ field_b, 0xb  # offset +0xb
.equ field_d, 0xd  # offset +0xd
.equ field_1de, 0x1de  # offset +0x1de
.equ field_206, 0x206  # offset +0x206
.equ field_216, 0x216  # offset +0x216
.equ field_23a, 0x23a  # offset +0x23a
.equ field_23e, 0x23e  # offset +0x23e
.equ field_242, 0x242  # offset +0x242
.equ field_25a, 0x25a  # offset +0x25a

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004ceb3b, .text + (0x004ceb3b - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004ced84 - 0x401000
.globl FUN_004ced84
FUN_004ced84:
    # block 0x004ced84: entry, 19 instruction(s), ends with je to 0x004cf00a (forward)
    push ebp                                     # 004ced84
    {load} mov ebp, esp                          # 004ced85
    sub esp, 0xc                                 # 004ced87
    mov dword ptr [ebp - local_8], ecx           # 004ced8a
    movsx eax, word ptr [ebp + arg_8]            # 004ced8d
    mov ecx, dword ptr [ebp - local_8]           # 004ced91
    mov dword ptr [ecx + field_242], eax         # 004ced94
    mov edx, dword ptr [ebp - local_8]           # 004ced9a
    mov eax, dword ptr [edx + field_242]         # 004ced9d
    imul eax, eax, 0x8d                          # 004ceda3
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004ceda9
    mov dword ptr [ebp - local_4], ecx           # 004cedaf
    mov edx, dword ptr [ebp - local_4]           # 004cedb2
    movsx eax, byte ptr [edx]                    # 004cedb5
    mov ecx, dword ptr [ebp - local_8]           # 004cedb8
    mov dword ptr [ecx + field_23a], eax         # 004cedbb
    mov edx, dword ptr [ebp - local_8]           # 004cedc1
    cmp dword ptr [edx + field_216], 0x0         # 004cedc4
    je.d32 L_004cf00a                            # 004cedcb
    # block 0x004cedd1: entered by fall-through of je at 0x004cedcb, 5 instruction(s), ends with je to 0x004cedfc (forward)
    mov eax, dword ptr [ebp - local_8]           # 004cedd1
    mov ecx, dword ptr [eax + field_23a]         # 004cedd4
    mov dword ptr [ebp - local_c], ecx           # 004cedda
    cmp dword ptr [ebp - local_c], 0x0           # 004ceddd
    je.d8 L_004cedfc                             # 004cede1
    # block 0x004cede3: entered by fall-through of je at 0x004cede1, 2 instruction(s), ends with je to 0x004ceefd (forward)
    cmp dword ptr [ebp - local_c], 0x1           # 004cede3
    je.d32 L_004ceefd                            # 004cede7
    # block 0x004ceded: entered by fall-through of je at 0x004cede7, 2 instruction(s), ends with je to 0x004cefc8 (forward)
    cmp dword ptr [ebp - local_c], 0x2           # 004ceded
    je.d32 L_004cefc8                            # 004cedf1
    # block 0x004cedf7: entered by fall-through of je at 0x004cedf1, 1 instruction(s), ends with forward jump to 0x004cf00a
    jmp.d32 L_004cf00a                           # 004cedf7
L_004cedfc:
    # block 0x004cedfc: entered by je at 0x004cede1, 3 instruction(s), ends with je to 0x004cee36 (forward)
    movsx edx, word ptr [0x63a4cd]               # 004cedfc
    test edx, edx                                # 004cee03
    je.d8 L_004cee36                             # 004cee05
    # block 0x004cee07: entered by fall-through of je at 0x004cee05, 12 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004cee36
    mov eax, dword ptr [0x5bb57b]                # 004cee07
    push eax                                     # 004cee0c
    mov ecx, dword ptr [ebp - local_8]           # 004cee0d
    mov edx, dword ptr [ecx + field_23e]         # 004cee10
    push edx                                     # 004cee16
    push 0x559b28                                # 004cee17
    push 0x63888b                                # 004cee1c
    call FUN_0050ca3e                            # 004cee21
    add esp, 0x10                                # 004cee26
    push 0x63888b                                # 004cee29
    call FUN_0044a2b7                            # 004cee2e
    add esp, 0x4                                 # 004cee33
L_004cee36:
    # block 0x004cee36: entered by je at 0x004cee05, 9 instruction(s), calls FUN_004ceb3b, ends with je to 0x004cee6a (forward)
    mov eax, dword ptr [ebp - local_8]           # 004cee36
    mov cx, word ptr [eax + field_23e]           # 004cee39
    push ecx                                     # 004cee40
    mov ecx, dword ptr [ebp - local_8]           # 004cee41
    call FUN_004ceb3b                            # 004cee44
    mov edx, dword ptr [ebp - local_4]           # 004cee49
    movsx eax, word ptr [edx + field_9]          # 004cee4c
    cmp eax, -0x1                                # 004cee50
    je.d8 L_004cee6a                             # 004cee53
    # block 0x004cee55: entered by fall-through of je at 0x004cee53, 5 instruction(s), falls into the block at 0x004cee6a
    mov ecx, dword ptr [ebp - local_4]           # 004cee55
    movsx edx, word ptr [ecx + field_b]          # 004cee58
    mov eax, dword ptr [ebp - local_4]           # 004cee5c
    movsx ecx, word ptr [eax + field_9]          # 004cee5f
    mov dword ptr [4*ecx + 0x585801], edx        # 004cee63
L_004cee6a:
    # block 0x004cee6a: entered by je at 0x004cee53, 4 instruction(s), ends with je to 0x004ceed6 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cee6a
    movsx eax, word ptr [edx + field_1]          # 004cee6d
    cmp eax, 0x270f                              # 004cee71
    je.d8 L_004ceed6                             # 004cee76
    # block 0x004cee78: entered by fall-through of je at 0x004cee76, 16 instruction(s), falls into the block at 0x004ceed6
    mov ecx, dword ptr [ebp - local_4]           # 004cee78
    movsx edx, word ptr [ecx + field_1]          # 004cee7b
    mov dword ptr [0x5bb57b], edx                # 004cee7f
    mov eax, dword ptr [ebp - local_4]           # 004cee85
    mov cx, word ptr [eax + field_3]             # 004cee88
    mov word ptr [0x5bb599], cx                  # 004cee8c
    mov edx, dword ptr [ebp - local_4]           # 004cee93
    mov ax, word ptr [edx + field_5]             # 004cee96
    mov word ptr [0x5bb595], ax                  # 004cee9a
    mov ecx, dword ptr [ebp - local_4]           # 004ceea0
    mov dx, word ptr [ecx + field_7]             # 004ceea3
    mov word ptr [0x5c39ff], dx                  # 004ceea7
    mov dword ptr [0x5bb59b], 0x0                # 004ceeae
    mov dword ptr [0x5bb59f], 0x0                # 004ceeb8
    mov dword ptr [0x5bb5a3], 0x1                # 004ceec2
    mov dword ptr [0x583999], 0x4                # 004ceecc
L_004ceed6:
    # block 0x004ceed6: entered by je at 0x004cee76, 4 instruction(s), ends with jne to 0x004ceeee (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ceed6
    movsx ecx, word ptr [eax + field_d]          # 004ceed9
    cmp ecx, 0x1                                 # 004ceedd
    jne.d8 L_004ceeee                            # 004ceee0
    # block 0x004ceee2: entered by fall-through of jne at 0x004ceee0, 2 instruction(s), ends with forward jump to 0x004ceef8
    mov dword ptr [0x5bb1ca], 0x0                # 004ceee2
    jmp.d8 L_004ceef8                            # 004ceeec
L_004ceeee:
    # block 0x004ceeee: entered by jne at 0x004ceee0, 1 instruction(s), falls into the block at 0x004ceef8
    mov dword ptr [0x5bb1ca], 0x1                # 004ceeee
L_004ceef8:
    # block 0x004ceef8: entered by jmp at 0x004ceeec, 1 instruction(s), ends with forward jump to 0x004cf00a
    jmp.d32 L_004cf00a                           # 004ceef8
L_004ceefd:
    # block 0x004ceefd: entered by je at 0x004cede7, 4 instruction(s), ends with je to 0x004cef1e (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ceefd
    movsx eax, word ptr [edx + field_9]          # 004cef00
    cmp eax, -0x1                                # 004cef04
    je.d8 L_004cef1e                             # 004cef07
    # block 0x004cef09: entered by fall-through of je at 0x004cef07, 5 instruction(s), falls into the block at 0x004cef1e
    mov ecx, dword ptr [ebp - local_4]           # 004cef09
    movsx edx, word ptr [ecx + field_b]          # 004cef0c
    mov eax, dword ptr [ebp - local_4]           # 004cef10
    movsx ecx, word ptr [eax + field_9]          # 004cef13
    mov dword ptr [4*ecx + 0x585801], edx        # 004cef17
L_004cef1e:
    # block 0x004cef1e: entered by je at 0x004cef07, 4 instruction(s), ends with je to 0x004cef8a (forward)
    mov edx, dword ptr [ebp - local_4]           # 004cef1e
    movsx eax, word ptr [edx + field_1]          # 004cef21
    cmp eax, 0x270f                              # 004cef25
    je.d8 L_004cef8a                             # 004cef2a
    # block 0x004cef2c: entered by fall-through of je at 0x004cef2a, 16 instruction(s), falls into the block at 0x004cef8a
    mov ecx, dword ptr [ebp - local_4]           # 004cef2c
    movsx edx, word ptr [ecx + field_1]          # 004cef2f
    mov dword ptr [0x5bb57b], edx                # 004cef33
    mov eax, dword ptr [ebp - local_4]           # 004cef39
    mov cx, word ptr [eax + field_3]             # 004cef3c
    mov word ptr [0x5bb599], cx                  # 004cef40
    mov edx, dword ptr [ebp - local_4]           # 004cef47
    mov ax, word ptr [edx + field_5]             # 004cef4a
    mov word ptr [0x5bb595], ax                  # 004cef4e
    mov ecx, dword ptr [ebp - local_4]           # 004cef54
    mov dx, word ptr [ecx + field_7]             # 004cef57
    mov word ptr [0x5c39ff], dx                  # 004cef5b
    mov dword ptr [0x5bb59b], 0x0                # 004cef62
    mov dword ptr [0x5bb59f], 0x0                # 004cef6c
    mov dword ptr [0x5bb5a3], 0x1                # 004cef76
    mov dword ptr [0x583999], 0x4                # 004cef80
L_004cef8a:
    # block 0x004cef8a: entered by je at 0x004cef2a, 4 instruction(s), ends with jne to 0x004cefa2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004cef8a
    movsx ecx, word ptr [eax + field_d]          # 004cef8d
    cmp ecx, 0x1                                 # 004cef91
    jne.d8 L_004cefa2                            # 004cef94
    # block 0x004cef96: entered by fall-through of jne at 0x004cef94, 2 instruction(s), ends with forward jump to 0x004cefac
    mov dword ptr [0x5bb1ca], 0x0                # 004cef96
    jmp.d8 L_004cefac                            # 004cefa0
L_004cefa2:
    # block 0x004cefa2: entered by jne at 0x004cef94, 1 instruction(s), falls into the block at 0x004cefac
    mov dword ptr [0x5bb1ca], 0x1                # 004cefa2
L_004cefac:
    # block 0x004cefac: entered by jmp at 0x004cefa0, 5 instruction(s), ends with forward jump to 0x004cf00a
    mov edx, dword ptr [ebp - local_8]           # 004cefac
    mov dword ptr [edx + field_1de], 0x2         # 004cefaf
    mov eax, dword ptr [ebp - local_8]           # 004cefb9
    mov dword ptr [eax + field_206], 0x0         # 004cefbc
    jmp.d8 L_004cf00a                            # 004cefc6
L_004cefc8:
    # block 0x004cefc8: entered by je at 0x004cedf1, 3 instruction(s), ends with je to 0x004ceff0 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004cefc8
    cmp dword ptr [ecx + field_25a], 0x0         # 004cefcb
    je.d8 L_004ceff0                             # 004cefd2
    # block 0x004cefd4: entered by fall-through of je at 0x004cefd2, 5 instruction(s), ends with forward jump to 0x004ceffd
    mov edx, dword ptr [ebp - local_8]           # 004cefd4
    mov dword ptr [edx + field_1de], 0x3         # 004cefd7
    mov eax, dword ptr [ebp - local_8]           # 004cefe1
    mov dword ptr [eax + field_25a], 0x0         # 004cefe4
    jmp.d8 L_004ceffd                            # 004cefee
L_004ceff0:
    # block 0x004ceff0: entered by je at 0x004cefd2, 2 instruction(s), falls into the block at 0x004ceffd
    mov ecx, dword ptr [ebp - local_8]           # 004ceff0
    mov dword ptr [ecx + field_1de], 0x0         # 004ceff3
L_004ceffd:
    # block 0x004ceffd: entered by jmp at 0x004cefee, 2 instruction(s), falls into the block at 0x004cf00a
    mov edx, dword ptr [ebp - local_8]           # 004ceffd
    mov dword ptr [edx + field_206], 0x1         # 004cf000
L_004cf00a:
    # block 0x004cf00a: entered by je at 0x004cedcb; jmp at 0x004cedf7; jmp at 0x004ceef8; jmp at 0x004cefc6, 7 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_8]           # 004cf00a
    mov ecx, dword ptr [eax + field_242]         # 004cf00d
    imul ecx, ecx, 0x8d                          # 004cf013
    mov byte ptr [ecx + 0x5bb625], 0x1           # 004cf019
    {load} mov esp, ebp                          # 004cf020
    pop ebp                                      # 004cf022
    ret 0x4                                      # 004cf023

