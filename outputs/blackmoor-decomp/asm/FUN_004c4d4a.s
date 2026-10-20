# FUN_004c4d4a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c4d4a
# extent:       0x004c4d4a-0x004c4dc3 (121 code bytes)
# span:         0x004c4d4a-0x004c4dc3 (code 121, tables 0, padding 0)
# sha256:       f063a40b01bfe2c97e76db2c86dd7cbb3743cb34a490226dd544f164e2fdb8a4
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_draw_flip
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c4d4a.c.txt, not original source) refers to the data labelled s_DDFlip_____00554684
# name-note:    Calls the surface Flip method, restoring DirectDraw and retrying on lost surface; failure is reported with the DDFlip string.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_2c
# callees:      calls FUN_004c4dc3, FUN_004c88c7, FUN_0042639d, FUN_004c97b4; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 41 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c4dc3, .text + (0x004c4dc3 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x004c4d4a - 0x401000
.globl FUN_004c4d4a
FUN_004c4d4a:
    # block 0x004c4d4a: entry, 4 instruction(s), falls into the block at 0x004c4d53
    push ebp                                     # 004c4d4a
    {load} mov ebp, esp                          # 004c4d4b
    sub esp, 0x8                                 # 004c4d4d
    mov dword ptr [ebp - local_8], ecx           # 004c4d50
L_004c4d53:
    # block 0x004c4d53: entered by jmp at 0x004c4dbb, 3 instruction(s), ends with je to 0x004c4dbd (forward)
    mov eax, 0x1                                 # 004c4d53
    test eax, eax                                # 004c4d58
    je.d8 L_004c4dbd                             # 004c4d5a
    # block 0x004c4d5c: entered by fall-through of je at 0x004c4d5a, 11 instruction(s), calls indirect dword ptr [eax + 0x2c], ends with jne to 0x004c4d79 (forward)
    push 0x1                                     # 004c4d5c
    mov ecx, dword ptr [ebp + arg_8]             # 004c4d5e
    push ecx                                     # 004c4d61
    mov edx, dword ptr [ebp + arg_c]             # 004c4d62
    mov eax, dword ptr [edx]                     # 004c4d65
    mov ecx, dword ptr [ebp + arg_c]             # 004c4d67
    push ecx                                     # 004c4d6a
    call dword ptr [eax + field_2c]              # 004c4d6b
    mov dword ptr [ebp - local_4], eax           # 004c4d6e
    cmp dword ptr [ebp - local_4], 0x0           # 004c4d71
    jne.d8 L_004c4d79                            # 004c4d75
    # block 0x004c4d77: entered by fall-through of jne at 0x004c4d75, 1 instruction(s), ends with forward jump to 0x004c4dbd
    jmp.d8 L_004c4dbd                            # 004c4d77
L_004c4d79:
    # block 0x004c4d79: entered by jne at 0x004c4d75, 2 instruction(s), ends with jne to 0x004c4d8c (forward)
    cmp dword ptr [ebp - local_4], 0x887601c2    # 004c4d79
    jne.d8 L_004c4d8c                            # 004c4d80
    # block 0x004c4d82: entered by fall-through of jne at 0x004c4d80, 3 instruction(s), calls FUN_004c4dc3, ends with forward jump to 0x004c4dbb
    mov ecx, dword ptr [ebp - local_8]           # 004c4d82
    call FUN_004c4dc3                            # 004c4d85
    jmp.d8 L_004c4dbb                            # 004c4d8a
L_004c4d8c:
    # block 0x004c4d8c: entered by jne at 0x004c4d80, 2 instruction(s), ends with je to 0x004c4dbb (forward)
    cmp dword ptr [ebp - local_4], 0x8876021c    # 004c4d8c
    je.d8 L_004c4dbb                             # 004c4d93
    # block 0x004c4d95: entered by fall-through of je at 0x004c4d93, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c4dbd
    mov edx, dword ptr [ebp - local_4]           # 004c4d95
    push edx                                     # 004c4d98
    mov ecx, dword ptr [ebp - local_8]           # 004c4d99
    call FUN_004c88c7                            # 004c4d9c
    push eax                                     # 004c4da1
    push 0x554684                                # 004c4da2
    mov ecx, 0x583979                            # 004c4da7
    call FUN_0042639d                            # 004c4dac
    mov ecx, dword ptr [ebp - local_8]           # 004c4db1
    call FUN_004c97b4                            # 004c4db4
    jmp.d8 L_004c4dbd                            # 004c4db9
L_004c4dbb:
    # block 0x004c4dbb: entered by jmp at 0x004c4d8a; je at 0x004c4d93, 1 instruction(s), ends with backward jump to 0x004c4d53
    jmp.d8 L_004c4d53                            # 004c4dbb
L_004c4dbd:
    # block 0x004c4dbd: entered by je at 0x004c4d5a; jmp at 0x004c4d77; jmp at 0x004c4db9, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 004c4dbd
    pop ebp                                      # 004c4dbf
    ret 0x8                                      # 004c4dc0

