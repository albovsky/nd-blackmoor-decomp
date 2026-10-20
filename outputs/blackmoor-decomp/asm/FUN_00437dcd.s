# FUN_00437dcd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00437dcd
# extent:       0x00437dcd-0x00437ea1 (212 code bytes)
# span:         0x00437dcd-0x00437ea1 (code 212, tables 0, padding 0)
# sha256:       dc0a96cc685c34f58fb28837f441765ce700432baa6ce916a1e50456423d5f17
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_character_message_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_76_runtime.h:23 says "0x437dcd character message handler"
# name-note:    Character message handler that stores an accepted typed character when a puzzle is active.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00437ea1, FUN_004a1f59, FUN_0048e93e, FUN_004b8193
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 68 instruction(s), 9 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00437ea1, .text + (0x00437ea1 - 0x401000)
.set FUN_0048e93e, .text + (0x0048e93e - 0x401000)
.set FUN_004a1f59, .text + (0x004a1f59 - 0x401000)
.set FUN_004b8193, .text + (0x004b8193 - 0x401000)

.org 0x00437dcd - 0x401000
.globl FUN_00437dcd
FUN_00437dcd:
    # block 0x00437dcd: entry, 6 instruction(s), ends with je to 0x00437e2d (forward)
    push ebp                                     # 00437dcd
    {load} mov ebp, esp                          # 00437dce
    push ecx                                     # 00437dd0
    mov dword ptr [ebp - local_4], ecx           # 00437dd1
    cmp dword ptr [0x5e32c9], 0x0                # 00437dd4
    je.d8 L_00437e2d                             # 00437ddb
    # block 0x00437ddd: entered by fall-through of je at 0x00437ddb, 2 instruction(s), ends with jne to 0x00437e2d (forward)
    cmp dword ptr [0x5e32de], 0x0                # 00437ddd
    jne.d8 L_00437e2d                            # 00437de4
    # block 0x00437de6: entered by fall-through of jne at 0x00437de4, 7 instruction(s), calls FUN_00437ea1, ends with je to 0x00437e2d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00437de6
    mov cl, byte ptr [eax]                       # 00437de9
    push ecx                                     # 00437deb
    mov ecx, dword ptr [ebp - local_4]           # 00437dec
    call FUN_00437ea1                            # 00437def
    test eax, eax                                # 00437df4
    je.d8 L_00437e2d                             # 00437df6
    # block 0x00437df8: entered by fall-through of je at 0x00437df6, 4 instruction(s), ends with je to 0x00437e2d (forward)
    mov edx, dword ptr [ebp + arg_8]             # 00437df8
    movsx eax, byte ptr [edx]                    # 00437dfb
    cmp eax, 0x2f                                # 00437dfe
    je.d8 L_00437e2d                             # 00437e01
    # block 0x00437e03: entered by fall-through of je at 0x00437e01, 4 instruction(s), ends with je to 0x00437e2d (forward)
    mov ecx, dword ptr [ebp + arg_8]             # 00437e03
    movsx edx, byte ptr [ecx]                    # 00437e06
    cmp edx, 0x3f                                # 00437e09
    je.d8 L_00437e2d                             # 00437e0c
    # block 0x00437e0e: entered by fall-through of je at 0x00437e0c, 4 instruction(s), ends with je to 0x00437e2d (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00437e0e
    movsx ecx, byte ptr [eax]                    # 00437e11
    cmp ecx, 0x3a                                # 00437e14
    je.d8 L_00437e2d                             # 00437e17
    # block 0x00437e19: entered by fall-through of je at 0x00437e17, 4 instruction(s), falls into the block at 0x00437e2d
    mov edx, dword ptr [ebp + arg_8]             # 00437e19
    mov al, byte ptr [edx]                       # 00437e1c
    mov byte ptr [0x5e32dd], al                  # 00437e1e
    mov dword ptr [0x5e32de], 0x1                # 00437e23
L_00437e2d:
    # block 0x00437e2d: entered by je at 0x00437ddb; jne at 0x00437de4; je at 0x00437df6; je at 0x00437e01; more, 4 instruction(s), ends with je to 0x00437e68 (forward)
    {load} xor ecx, ecx                          # 00437e2d
    mov cl, byte ptr [0x5b61af]                  # 00437e2f
    test ecx, ecx                                # 00437e35
    je.d8 L_00437e68                             # 00437e37
    # block 0x00437e39: entered by fall-through of je at 0x00437e37, 4 instruction(s), ends with jne to 0x00437e68 (forward)
    {load} xor edx, edx                          # 00437e39
    mov dl, byte ptr [0x5b616b]                  # 00437e3b
    test edx, edx                                # 00437e41
    jne.d8 L_00437e68                            # 00437e43
    # block 0x00437e45: entered by fall-through of jne at 0x00437e43, 7 instruction(s), calls FUN_00437ea1, ends with je to 0x00437e68 (forward)
    mov eax, dword ptr [ebp + arg_8]             # 00437e45
    mov cl, byte ptr [eax]                       # 00437e48
    push ecx                                     # 00437e4a
    mov ecx, dword ptr [ebp - local_4]           # 00437e4b
    call FUN_00437ea1                            # 00437e4e
    test eax, eax                                # 00437e53
    je.d8 L_00437e68                             # 00437e55
    # block 0x00437e57: entered by fall-through of je at 0x00437e55, 4 instruction(s), falls into the block at 0x00437e68
    mov edx, dword ptr [ebp + arg_8]             # 00437e57
    mov al, byte ptr [edx]                       # 00437e5a
    mov byte ptr [0x5b616c], al                  # 00437e5c
    mov byte ptr [0x5b616b], 0x1                 # 00437e61
L_00437e68:
    # block 0x00437e68: entered by je at 0x00437e37; jne at 0x00437e43; je at 0x00437e55, 18 instruction(s), calls FUN_004a1f59, FUN_0048e93e, FUN_004b8193, ends with ret 0xc
    mov ecx, dword ptr [ebp + arg_8]             # 00437e68
    movsx edx, byte ptr [ecx]                    # 00437e6b
    push edx                                     # 00437e6e
    mov ecx, 0x61d2dd                            # 00437e6f
    call FUN_004a1f59                            # 00437e74
    mov eax, dword ptr [ebp + arg_8]             # 00437e79
    movsx ecx, byte ptr [eax]                    # 00437e7c
    push ecx                                     # 00437e7f
    mov ecx, 0x624dc9                            # 00437e80
    call FUN_0048e93e                            # 00437e85
    mov edx, dword ptr [ebp + arg_8]             # 00437e8a
    movsx eax, byte ptr [edx]                    # 00437e8d
    push eax                                     # 00437e90
    mov ecx, 0x61ee6e                            # 00437e91
    call FUN_004b8193                            # 00437e96
    {load} mov esp, ebp                          # 00437e9b
    pop ebp                                      # 00437e9d
    ret 0xc                                      # 00437e9e

