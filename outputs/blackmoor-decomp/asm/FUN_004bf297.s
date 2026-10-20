# FUN_004bf297
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004bf297
# extent:       0x004bf297-0x004bf315 (126 code bytes)
# span:         0x004bf297-0x004bf315 (code 126, tables 0, padding 0)
# sha256:       059363babdb246a560dc2df0208730861ea928d6799576c20b83aa9ccac0f61a
# evidence:     ev_9b97a3dfc13c18288f6cf40dd7f15c3bf5b969f690eaa08654df89043c2c39c3
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_bink_get_ddraw_surface_type
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4bf297.c.txt, not original source) refers to the data labelled s_CBink__GetDirectDrawSurfaceType__00552454
# name-note:    Calls BinkDDSurfaceType to get the DirectDraw surface type, stores it and logs CBink::GetDirectDrawSurfaceType; stores an error code when the type is 0 or -1.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4; [ecx + n] field_4, field_2c0; [edx + n] field_4
# callees:      calls FUN_004bf38c, binkw32.dll!_BinkDDSurfaceType@4, FUN_0050ca3e, FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_2c0, 0x2c0  # offset +0x2c0

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004bf38c, .text + (0x004bf38c - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004bf297 - 0x401000
.globl FUN_004bf297
FUN_004bf297:
    # block 0x004bf297: entry, 14 instruction(s), calls FUN_004bf38c, binkw32.dll!_BinkDDSurfaceType@4, ends with je to 0x004bf2c8 (forward)
    push ebp                                     # 004bf297
    {load} mov ebp, esp                          # 004bf298
    push ecx                                     # 004bf29a
    mov dword ptr [ebp - local_4], ecx           # 004bf29b
    mov ecx, dword ptr [ebp - local_4]           # 004bf29e
    call FUN_004bf38c                            # 004bf2a1
    mov eax, dword ptr [ebp + arg_8]             # 004bf2a6
    push eax                                     # 004bf2a9
    call dword ptr [0x52a51c]                    # 004bf2aa
    mov ecx, dword ptr [ebp - local_4]           # 004bf2b0
    mov dword ptr [ecx + field_4], eax           # 004bf2b3
    mov edx, dword ptr [ebp - local_4]           # 004bf2b6
    cmp dword ptr [edx + field_4], -0x1          # 004bf2b9
    je.d8 L_004bf2c8                             # 004bf2bd
    # block 0x004bf2bf: entered by fall-through of je at 0x004bf2bd, 3 instruction(s), ends with jne to 0x004bf2dc (forward)
    mov eax, dword ptr [ebp - local_4]           # 004bf2bf
    cmp dword ptr [eax + field_4], 0x0           # 004bf2c2
    jne.d8 L_004bf2dc                            # 004bf2c6
L_004bf2c8:
    # block 0x004bf2c8: entered by je at 0x004bf2bd; fall-through of jne at 0x004bf2c6, 4 instruction(s), ends with forward jump to 0x004bf30f
    mov ecx, dword ptr [ebp - local_4]           # 004bf2c8
    mov dword ptr [ecx + field_2c0], 0xfffffffc  # 004bf2cb
    mov eax, 0xfffffffc                          # 004bf2d5
    jmp.d8 L_004bf30f                            # 004bf2da
L_004bf2dc:
    # block 0x004bf2dc: entered by jne at 0x004bf2c6, 3 instruction(s), ends with je to 0x004bf30d (forward)
    movsx edx, word ptr [0x63a4cd]               # 004bf2dc
    test edx, edx                                # 004bf2e3
    je.d8 L_004bf30d                             # 004bf2e5
    # block 0x004bf2e7: entered by fall-through of je at 0x004bf2e5, 10 instruction(s), calls FUN_0050ca3e, FUN_0044a2b7, falls into the block at 0x004bf30d
    mov eax, dword ptr [ebp - local_4]           # 004bf2e7
    mov ecx, dword ptr [eax + field_4]           # 004bf2ea
    push ecx                                     # 004bf2ed
    push 0x552454                                # 004bf2ee
    push 0x63888b                                # 004bf2f3
    call FUN_0050ca3e                            # 004bf2f8
    add esp, 0xc                                 # 004bf2fd
    push 0x63888b                                # 004bf300
    call FUN_0044a2b7                            # 004bf305
    add esp, 0x4                                 # 004bf30a
L_004bf30d:
    # block 0x004bf30d: entered by je at 0x004bf2e5, 1 instruction(s), falls into the block at 0x004bf30f
    {load} xor eax, eax                          # 004bf30d
L_004bf30f:
    # block 0x004bf30f: entered by jmp at 0x004bf2da, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004bf30f
    pop ebp                                      # 004bf311
    ret 0x4                                      # 004bf312

