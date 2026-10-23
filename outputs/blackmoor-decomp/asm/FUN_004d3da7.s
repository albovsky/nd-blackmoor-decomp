# FUN_004d3da7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3da7
# extent:       0x004d3da7-0x004d3eba (275 code bytes)
# span:         0x004d3da7-0x004d3eba (code 275, tables 0, padding 0)
# sha256:       872c48b66d86a0e6841afb390249926f879ca681b839c7915521bdd8297a589a
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_clock_scene_init
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4d3da7.c.txt, not original source) refers to the data labelled s_CLOCK_0055a4ac
# name-note:    Initializes the clock scene: plays a sound, resets state, fills the render descriptor with the CLOCK name and a draw callback, and sets a GetTickCount timer.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_327, field_43e, field_440; [ecx + n] field_324, field_448, field_452; [edx + n] field_444, field_44a, field_462
# callees:      calls FUN_004fb2e3, FUN_004dad60, KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 63 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_324, 0x324  # offset +0x324
.equ field_327, 0x327  # offset +0x327
.equ field_43e, 0x43e  # offset +0x43e
.equ field_440, 0x440  # offset +0x440
.equ field_444, 0x444  # offset +0x444
.equ field_448, 0x448  # offset +0x448
.equ field_44a, 0x44a  # offset +0x44a
.equ field_452, 0x452  # offset +0x452
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004d3da7 - 0x401000
.globl FUN_004d3da7
FUN_004d3da7:
    # block 0x004d3da7: entry, 11 instruction(s), ends with jne to 0x004d3dcb (forward)
    push ebp                                     # 004d3da7
    {load} mov ebp, esp                          # 004d3da8
    push ecx                                     # 004d3daa
    push esi                                     # 004d3dab
    push edi                                     # 004d3dac
    mov dword ptr [ebp - local_4], ecx           # 004d3dad
    mov eax, dword ptr [ebp - local_4]           # 004d3db0
    {load} xor ecx, ecx                          # 004d3db3
    mov cl, byte ptr [eax + field_327]           # 004d3db5
    test ecx, ecx                                # 004d3dbb
    jne.d8 L_004d3dcb                            # 004d3dbd
    # block 0x004d3dbf: entered by fall-through of jne at 0x004d3dbd, 3 instruction(s), calls FUN_004fb2e3, falls into the block at 0x004d3dcb
    push 0x14                                    # 004d3dbf
    mov ecx, 0x5c3a67                            # 004d3dc1
    call FUN_004fb2e3                            # 004d3dc6
L_004d3dcb:
    # block 0x004d3dcb: entered by jne at 0x004d3dbd, 49 instruction(s), calls FUN_004dad60, KERNEL32.dll!GetTickCount, ends with ret
    mov edx, dword ptr [ebp - local_4]           # 004d3dcb
    mov dword ptr [edx + field_444], 0x1         # 004d3dce
    mov eax, dword ptr [ebp - local_4]           # 004d3dd8
    mov word ptr [eax + field_43e], 0x0          # 004d3ddb
    mov ecx, 0x5830a6                            # 004d3de4
    call FUN_004dad60                            # 004d3de9
    mov ecx, dword ptr [ebp - local_4]           # 004d3dee
    mov word ptr [ecx + field_448], 0xffff       # 004d3df1
    mov edx, dword ptr [ebp - local_4]           # 004d3dfa
    mov dword ptr [edx + field_44a], 0x0         # 004d3dfd
    mov eax, dword ptr [ebp - local_4]           # 004d3e07
    mov dword ptr [eax + field_440], 0x0         # 004d3e0a
    mov dword ptr [0x5d1c37], 0xd                # 004d3e14
    mov dword ptr [0x5d1c3b], 0x4d41a2           # 004d3e1e
    mov ecx, dword ptr [0x5d0377]                # 004d3e28
    mov dword ptr [0x5d1c3f], ecx                # 004d3e2e
    mov dword ptr [0x5d1c43], 0x0                # 004d3e34
    mov dword ptr [0x5d1c47], 0x0                # 004d3e3e
    mov dword ptr [0x5d1c4b], 0x1                # 004d3e48
    mov dword ptr [0x5d1c4f], 0x1                # 004d3e52
    mov word ptr [0x5d1c53], 0x0                 # 004d3e5c
    mov edi, 0x55a4ac                            # 004d3e65
    mov edx, 0x5d1c59                            # 004d3e6a
    or ecx, -0x1                                 # 004d3e6f
    {load} xor eax, eax                          # 004d3e72
    repne scasb al, byte ptr es:[edi]            # 004d3e74
    not ecx                                      # 004d3e76
    {load} sub edi, ecx                          # 004d3e78
    {load} mov esi, edi                          # 004d3e7a
    {load} mov eax, ecx                          # 004d3e7c
    {load} mov edi, edx                          # 004d3e7e
    shr ecx, 0x2                                 # 004d3e80
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004d3e83
    {load} mov ecx, eax                          # 004d3e85
    and ecx, 0x3                                 # 004d3e87
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004d3e8a
    call dword ptr [0x52a23c]                    # 004d3e8c
    mov ecx, dword ptr [ebp - local_4]           # 004d3e92
    movsx edx, word ptr [ecx + field_324]        # 004d3e95
    {load} add eax, edx                          # 004d3e9c
    mov ecx, dword ptr [ebp - local_4]           # 004d3e9e
    mov dword ptr [ecx + field_452], eax         # 004d3ea1
    mov edx, dword ptr [ebp - local_4]           # 004d3ea7
    mov dword ptr [edx + field_462], 0x1         # 004d3eaa
    pop edi                                      # 004d3eb4
    pop esi                                      # 004d3eb5
    {load} mov esp, ebp                          # 004d3eb6
    pop ebp                                      # 004d3eb8
    ret                                          # 004d3eb9

