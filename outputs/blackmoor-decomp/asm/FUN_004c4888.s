# FUN_004c4888
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c4888
# extent:       0x004c4888-0x004c492c (164 code bytes)
# span:         0x004c4888-0x004c492c (code 164, tables 0, padding 0)
# sha256:       a4f37084cf8fd7bbfdc34152a265ecab425e3cf3409522af45d02bd3f3290dbf
# evidence:     ev_093fc7c080074dc275f9d9269921c6e8fdf13c9a1ff4cfaef6b063be7d9fe60e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_fast_flood_fill_rect_blt
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c4888.c.txt, not original source) refers to the data labelled s_FastFloodFillRect_____005545d0
# name-note:    Fills a rectangle on a DirectDraw surface through a color-fill Blt with retry on lost surface; failure reported as FastFloodFillRect.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_18, local_68, local_6c
# fields:       [edx + n] field_14
# callees:      calls FUN_004c4dc3, FUN_004c88c7, FUN_0042639d, FUN_004c97b4; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 55 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_18, 0x18  # offset -0x18
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c4dc3, .text + (0x004c4dc3 - 0x401000)
.set FUN_004c88c7, .text + (0x004c88c7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)

.org 0x004c4888 - 0x401000
.globl FUN_004c4888
FUN_004c4888:
    # block 0x004c4888: entry, 13 instruction(s), falls into the block at 0x004c48b0
    push ebp                                     # 004c4888
    {load} mov ebp, esp                          # 004c4889
    sub esp, 0x6c                                # 004c488b
    push edi                                     # 004c488e
    mov dword ptr [ebp - local_6c], ecx          # 004c488f
    mov ecx, 0x19                                # 004c4892
    {load} xor eax, eax                          # 004c4897
    lea edi, [ebp - local_68]                    # 004c4899
    rep stosd dword ptr es:[edi], eax            # 004c489c
    mov dword ptr [ebp - local_68], 0x64         # 004c489e
    mov eax, dword ptr [ebp + arg_c]             # 004c48a5
    and eax, 0xffff                              # 004c48a8
    mov dword ptr [ebp - local_18], eax          # 004c48ad
L_004c48b0:
    # block 0x004c48b0: entered by jmp at 0x004c4923, 3 instruction(s), ends with je to 0x004c4925 (forward)
    mov ecx, 0x1                                 # 004c48b0
    test ecx, ecx                                # 004c48b5
    je.d8 L_004c4925                             # 004c48b7
    # block 0x004c48b9: entered by fall-through of je at 0x004c48b7, 15 instruction(s), calls indirect dword ptr [edx + 0x14], ends with jne to 0x004c48e1 (forward)
    lea edx, [ebp - local_68]                    # 004c48b9
    push edx                                     # 004c48bc
    push 0x1000400                               # 004c48bd
    push 0x0                                     # 004c48c2
    push 0x0                                     # 004c48c4
    mov eax, dword ptr [ebp + arg_10]            # 004c48c6
    push eax                                     # 004c48c9
    mov ecx, dword ptr [ebp + arg_8]             # 004c48ca
    mov edx, dword ptr [ecx]                     # 004c48cd
    mov eax, dword ptr [ebp + arg_8]             # 004c48cf
    push eax                                     # 004c48d2
    call dword ptr [edx + field_14]              # 004c48d3
    mov dword ptr [ebp - local_4], eax           # 004c48d6
    cmp dword ptr [ebp - local_4], 0x0           # 004c48d9
    jne.d8 L_004c48e1                            # 004c48dd
    # block 0x004c48df: entered by fall-through of jne at 0x004c48dd, 1 instruction(s), ends with forward jump to 0x004c4925
    jmp.d8 L_004c4925                            # 004c48df
L_004c48e1:
    # block 0x004c48e1: entered by jne at 0x004c48dd, 2 instruction(s), ends with jne to 0x004c48f4 (forward)
    cmp dword ptr [ebp - local_4], 0x887601c2    # 004c48e1
    jne.d8 L_004c48f4                            # 004c48e8
    # block 0x004c48ea: entered by fall-through of jne at 0x004c48e8, 3 instruction(s), calls FUN_004c4dc3, ends with forward jump to 0x004c4923
    mov ecx, dword ptr [ebp - local_6c]          # 004c48ea
    call FUN_004c4dc3                            # 004c48ed
    jmp.d8 L_004c4923                            # 004c48f2
L_004c48f4:
    # block 0x004c48f4: entered by jne at 0x004c48e8, 2 instruction(s), ends with je to 0x004c4923 (forward)
    cmp dword ptr [ebp - local_4], 0x8876021c    # 004c48f4
    je.d8 L_004c4923                             # 004c48fb
    # block 0x004c48fd: entered by fall-through of je at 0x004c48fb, 11 instruction(s), calls FUN_004c88c7, FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004c4925
    mov ecx, dword ptr [ebp - local_4]           # 004c48fd
    push ecx                                     # 004c4900
    mov ecx, dword ptr [ebp - local_6c]          # 004c4901
    call FUN_004c88c7                            # 004c4904
    push eax                                     # 004c4909
    push 0x5545d0                                # 004c490a
    mov ecx, 0x583979                            # 004c490f
    call FUN_0042639d                            # 004c4914
    mov ecx, dword ptr [ebp - local_6c]          # 004c4919
    call FUN_004c97b4                            # 004c491c
    jmp.d8 L_004c4925                            # 004c4921
L_004c4923:
    # block 0x004c4923: entered by jmp at 0x004c48f2; je at 0x004c48fb, 1 instruction(s), ends with backward jump to 0x004c48b0
    jmp.d8 L_004c48b0                            # 004c4923
L_004c4925:
    # block 0x004c4925: entered by je at 0x004c48b7; jmp at 0x004c48df; jmp at 0x004c4921, 4 instruction(s), ends with ret 0xc
    pop edi                                      # 004c4925
    {load} mov esp, ebp                          # 004c4926
    pop ebp                                      # 004c4928
    ret 0xc                                      # 004c4929

