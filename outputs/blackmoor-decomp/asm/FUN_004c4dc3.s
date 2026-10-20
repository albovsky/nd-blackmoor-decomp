# FUN_004c4dc3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c4dc3
# extent:       0x004c4dc3-0x004c4e41 (126 code bytes)
# span:         0x004c4dc3-0x004c4e41 (code 126, tables 0, padding 0)
# sha256:       f24dc231a44981a8382318b20ef9ba7138b8077270fdac2fe638c0d671e710d6
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_direct_draw_restore
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c4dc3.c.txt, not original source) refers to the data labelled s_Begin_RestoreDirectDraw______00554690, s_RestoreDirectDraw_____005546b0
# name-note:    Calls the DirectDraw RestoreAllSurfaces method, logging Begin/End RestoreDirectDraw and aborting with the RestoreDirectDraw error on failure.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_8, field_6c; [ecx + n] field_8
# callees:      calls FUN_0044a2b7, FUN_004c88c7, FUN_0042639d, FUN_004c97b4; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_8, 0x8  # offset +0x8
.equ field_6c, 0x6c  # offset +0x6c

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x004c4dc3 - 0x401000
.globl FUN_004c4dc3
FUN_004c4dc3:
    # block 0x004c4dc3: entry, 7 instruction(s), ends with je to 0x004c4de4 (forward)
    push ebp                                     # 004c4dc3
    {load} mov ebp, esp                          # 004c4dc4
    sub esp, 0x8                                 # 004c4dc6
    mov dword ptr [ebp - local_8], ecx           # 004c4dc9
    movsx eax, word ptr [0x63a4cd]               # 004c4dcc
    test eax, eax                                # 004c4dd3
    je.d8 L_004c4de4                             # 004c4dd5
    # block 0x004c4dd7: entered by fall-through of je at 0x004c4dd5, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c4de4
    push 0x554690                                # 004c4dd7
    call FUN_0044a2b7                            # 004c4ddc
    add esp, 0x4                                 # 004c4de1
L_004c4de4:
    # block 0x004c4de4: entered by je at 0x004c4dd5, 10 instruction(s), calls indirect dword ptr [eax + 0x6c], ends with je to 0x004c4e25 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004c4de4
    mov edx, dword ptr [ecx + field_8]           # 004c4de7
    mov eax, dword ptr [ebp - local_8]           # 004c4dea
    mov ecx, dword ptr [eax + field_8]           # 004c4ded
    mov eax, dword ptr [ecx]                     # 004c4df0
    push edx                                     # 004c4df2
    call dword ptr [eax + field_6c]              # 004c4df3
    mov dword ptr [ebp - local_4], eax           # 004c4df6
    cmp dword ptr [ebp - local_4], 0x0           # 004c4df9
    je.d8 L_004c4e25                             # 004c4dfd
    # block 0x004c4dff: entered by fall-through of je at 0x004c4dfd, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c4e3d
    mov ecx, dword ptr [ebp - local_4]           # 004c4dff
    push ecx                                     # 004c4e02
    mov ecx, dword ptr [ebp - local_8]           # 004c4e03
    call FUN_004c88c7                            # 004c4e06
    push eax                                     # 004c4e0b
    push 0x5546b0                                # 004c4e0c
    mov ecx, 0x583979                            # 004c4e11
    call FUN_0042639d                            # 004c4e16
    mov ecx, dword ptr [ebp - local_8]           # 004c4e1b
    call FUN_004c97b4                            # 004c4e1e
    jmp.d8 L_004c4e3d                            # 004c4e23
L_004c4e25:
    # block 0x004c4e25: entered by je at 0x004c4dfd, 3 instruction(s), ends with je to 0x004c4e3d (forward)
    movsx edx, word ptr [0x63a4cd]               # 004c4e25
    test edx, edx                                # 004c4e2c
    je.d8 L_004c4e3d                             # 004c4e2e
    # block 0x004c4e30: entered by fall-through of je at 0x004c4e2e, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004c4e3d
    push 0x5546c8                                # 004c4e30
    call FUN_0044a2b7                            # 004c4e35
    add esp, 0x4                                 # 004c4e3a
L_004c4e3d:
    # block 0x004c4e3d: entered by jmp at 0x004c4e23; je at 0x004c4e2e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004c4e3d
    pop ebp                                      # 004c4e3f
    ret                                          # 004c4e40

