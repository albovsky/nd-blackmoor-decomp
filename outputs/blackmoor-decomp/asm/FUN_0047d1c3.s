# FUN_0047d1c3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d1c3
# extent:       0x0047d1c3-0x0047d24e (139 code bytes)
# span:         0x0047d1c3-0x0047d24e (code 139, tables 0, padding 0)
# sha256:       807c78e7d97ff53be2eb26a32d391437a4a316c35421a19e3d3a31e90ed10485
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47d1c3_alloc_zeroed
# naming:       native port src/original_methods_fl31b.c:m47d1c3_alloc_zeroed (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Allocates via 0x51dc43, stores the result; zeroes size bytes (rep stos) or on null reports (0x44a2b7 only if the debug flag is set); 45/45, 4/4 directions. See tasks/fl31b-handoff.md.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0050ca3e, FUN_004264e8, FUN_0044a2b7, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31b.c:m47d1c3_alloc_zeroed (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_004264e8, .text + (0x004264e8 - 0x401000)
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0047d1c3 - 0x401000
.globl FUN_0047d1c3
FUN_0047d1c3:
    # block 0x0047d1c3: entry, 15 instruction(s), calls FUN_0051dc43, ends with jne to 0x0047d22f (forward)
    push ebp                                     # 0047d1c3
    {load} mov ebp, esp                          # 0047d1c4
    sub esp, 0x8                                 # 0047d1c6
    push edi                                     # 0047d1c9
    mov dword ptr [ebp - local_8], ecx           # 0047d1ca
    mov eax, dword ptr [ebp + arg_c]             # 0047d1cd
    push eax                                     # 0047d1d0
    call FUN_0051dc43                            # 0047d1d1
    add esp, 0x4                                 # 0047d1d6
    mov dword ptr [ebp - local_4], eax           # 0047d1d9
    mov ecx, dword ptr [ebp + arg_8]             # 0047d1dc
    mov edx, dword ptr [ebp - local_4]           # 0047d1df
    mov dword ptr [ecx], edx                     # 0047d1e2
    cmp dword ptr [ebp - local_4], 0x0           # 0047d1e4
    jne.d8 L_0047d22f                            # 0047d1e8
    # block 0x0047d1ea: entered by fall-through of jne at 0x0047d1e8, 10 instruction(s), calls FUN_0050ca3e, FUN_004264e8, ends with je to 0x0047d223 (forward)
    push 0x54d168                                # 0047d1ea
    push 0x63888b                                # 0047d1ef
    call FUN_0050ca3e                            # 0047d1f4
    add esp, 0x8                                 # 0047d1f9
    push 0x63888b                                # 0047d1fc
    mov ecx, 0x583979                            # 0047d201
    call FUN_004264e8                            # 0047d206
    movsx eax, word ptr [0x63a4cd]               # 0047d20b
    test eax, eax                                # 0047d212
    je.d8 L_0047d223                             # 0047d214
    # block 0x0047d216: entered by fall-through of je at 0x0047d214, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x0047d223
    push 0x63888b                                # 0047d216
    call FUN_0044a2b7                            # 0047d21b
    add esp, 0x4                                 # 0047d220
L_0047d223:
    # block 0x0047d223: entered by je at 0x0047d214, 3 instruction(s), calls FUN_004c97b4, ends with forward jump to 0x0047d247
    mov ecx, 0x5cf659                            # 0047d223
    call FUN_004c97b4                            # 0047d228
    jmp.d8 L_0047d247                            # 0047d22d
L_0047d22f:
    # block 0x0047d22f: entered by jne at 0x0047d1e8, 10 instruction(s), falls into the block at 0x0047d247
    mov ecx, dword ptr [ebp + arg_c]             # 0047d22f
    {load} xor eax, eax                          # 0047d232
    mov edx, dword ptr [ebp + arg_8]             # 0047d234
    mov edi, dword ptr [edx]                     # 0047d237
    {load} mov edx, ecx                          # 0047d239
    shr ecx, 0x2                                 # 0047d23b
    rep stosd dword ptr es:[edi], eax            # 0047d23e
    {load} mov ecx, edx                          # 0047d240
    and ecx, 0x3                                 # 0047d242
    rep stosb byte ptr es:[edi], al              # 0047d245
L_0047d247:
    # block 0x0047d247: entered by jmp at 0x0047d22d, 4 instruction(s), ends with ret 0x8
    pop edi                                      # 0047d247
    {load} mov esp, ebp                          # 0047d248
    pop ebp                                      # 0047d24a
    ret 0x8                                      # 0047d24b

