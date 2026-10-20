# FUN_004b5c5c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b5c5c
# extent:       0x004b5c5c-0x004b5d17 (187 code bytes)
# span:         0x004b5c5c-0x004b5d17 (code 187, tables 0, padding 0)
# sha256:       1d4bb7367575fb73a2071051d8402a72864d94749f1e1fb7f7ef013e2b57961c
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_d1_turning_puzzle_loader
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_d1_runtime.h:16 says "0x4b5c5c loader (0x40b34a, 0x4103ee): copies the 927-byte typed body into a fresh row allocation"; src/scene_resource.c:164 says "0x4b5c5c copies 927 bytes (A-D1.1)"
# name-note:    Loader that copies the 927-byte typed body of the 0xd1 Turning Puzzle into a fresh row allocation.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, FUN_0044a2b7
# track-n:      outputs/blackmoor-decomp/src/scene_resource.c:known_body_length (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 58 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004b5c5c - 0x401000
.globl FUN_004b5c5c
FUN_004b5c5c:
    # block 0x004b5c5c: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x004b5cc3 (forward)
    push ebp                                     # 004b5c5c
    {load} mov ebp, esp                          # 004b5c5d
    sub esp, 0x8                                 # 004b5c5f
    push esi                                     # 004b5c62
    push edi                                     # 004b5c63
    mov dword ptr [ebp - local_8], ecx           # 004b5c64
    push 0x39f                                   # 004b5c67
    call FUN_0051dc43                            # 004b5c6c
    add esp, 0x4                                 # 004b5c71
    mov dword ptr [ebp - local_4], eax           # 004b5c74
    mov eax, dword ptr [ebp + arg_8]             # 004b5c77
    mov ecx, dword ptr [ebp - local_4]           # 004b5c7a
    mov dword ptr [eax], ecx                     # 004b5c7d
    cmp dword ptr [ebp - local_4], 0x0           # 004b5c7f
    jne.d8 L_004b5cc3                            # 004b5c83
    # block 0x004b5c85: entered by fall-through of jne at 0x004b5c83, 14 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004b5cc3
    movsx edx, word ptr [0x5c39e3]               # 004b5c85
    push edx                                     # 004b5c8c
    mov eax, dword ptr [0x5bb57b]                # 004b5c8d
    push eax                                     # 004b5c92
    push 0x551a9c                                # 004b5c93
    push 0x63888b                                # 004b5c98
    call FUN_0050ca3e                            # 004b5c9d
    add esp, 0x10                                # 004b5ca2
    push 0x63888b                                # 004b5ca5
    push 0x551ac8                                # 004b5caa
    mov ecx, 0x583979                            # 004b5caf
    call FUN_0042639d                            # 004b5cb4
    mov ecx, 0x5cf659                            # 004b5cb9
    call FUN_004c97b4                            # 004b5cbe
L_004b5cc3:
    # block 0x004b5cc3: entered by jne at 0x004b5c83, 21 instruction(s), ends with je to 0x004b5d0f (forward)
    mov ecx, dword ptr [ebp + arg_c]             # 004b5cc3
    mov esi, dword ptr [ecx]                     # 004b5cc6
    mov edx, dword ptr [ebp + arg_8]             # 004b5cc8
    mov edi, dword ptr [edx]                     # 004b5ccb
    mov ecx, 0xe7                                # 004b5ccd
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004b5cd2
    movsw word ptr es:[edi], word ptr [esi]      # 004b5cd4
    movsb byte ptr es:[edi], byte ptr [esi]      # 004b5cd6
    mov eax, dword ptr [ebp + arg_10]            # 004b5cd7
    mov ecx, dword ptr [eax]                     # 004b5cda
    add ecx, 0x39f                               # 004b5cdc
    mov edx, dword ptr [ebp + arg_10]            # 004b5ce2
    mov dword ptr [edx], ecx                     # 004b5ce5
    mov eax, dword ptr [ebp + arg_c]             # 004b5ce7
    mov ecx, dword ptr [eax]                     # 004b5cea
    add ecx, 0x39f                               # 004b5cec
    mov edx, dword ptr [ebp + arg_c]             # 004b5cf2
    mov dword ptr [edx], ecx                     # 004b5cf5
    movsx eax, word ptr [0x63a4cd]               # 004b5cf7
    test eax, eax                                # 004b5cfe
    je.d8 L_004b5d0f                             # 004b5d00
    # block 0x004b5d02: entered by fall-through of je at 0x004b5d00, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004b5d0f
    push 0x551ae4                                # 004b5d02
    call FUN_0044a2b7                            # 004b5d07
    add esp, 0x4                                 # 004b5d0c
L_004b5d0f:
    # block 0x004b5d0f: entered by je at 0x004b5d00, 5 instruction(s), ends with ret 0xc
    pop edi                                      # 004b5d0f
    pop esi                                      # 004b5d10
    {load} mov esp, ebp                          # 004b5d11
    pop ebp                                      # 004b5d13
    ret 0xc                                      # 004b5d14

