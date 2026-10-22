# FUN_0045e4d4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045e4d4
# extent:       0x0045e4d4-0x0045e587 (179 code bytes)
# span:         0x0045e4d4-0x0045e587 (code 179, tables 0, padding 0)
# sha256:       a5f03f2cdba2b182a6301720f4eda95cdb81df8e3e5dd3c78c91541d7356f280
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45e4d4_lifted
# naming:       native port src/original_methods_fl40.c:m45e4d4_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 35/35 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m45e4d4_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0045e4d4 - 0x401000
.globl FUN_0045e4d4
FUN_0045e4d4:
    # block 0x0045e4d4: entry, 7 instruction(s), ends with jne to 0x0045e530 (forward)
    push ebp                                     # 0045e4d4
    {load} mov ebp, esp                          # 0045e4d5
    push ecx                                     # 0045e4d7
    mov dword ptr [ebp - local_4], ecx           # 0045e4d8
    movsx eax, word ptr [ebp + arg_8]            # 0045e4db
    cmp eax, 0x27ef                              # 0045e4df
    jne.d8 L_0045e530                            # 0045e4e4
    # block 0x0045e4e6: entered by fall-through of jne at 0x0045e4e4, 12 instruction(s), ends with forward jump to 0x0045e578
    mov ecx, dword ptr [0x5d0377]                # 0045e4e6
    mov dword ptr [0x5d162d], ecx                # 0045e4ec
    mov dword ptr [0x5b44f0], 0x9                # 0045e4f2
    mov dword ptr [0x5b44f4], 0x1                # 0045e4fc
    mov edx, dword ptr [0x5b44f0]                # 0045e506
    shl edx, 0x5                                 # 0045e50c
    mov eax, dword ptr [0x5b44f4]                # 0045e50f
    shl eax, 0x4                                 # 0045e514
    lea ecx, [edx + eax + 0x5b160c]              # 0045e517
    mov dword ptr [0x5d1631], ecx                # 0045e51e
    mov dword ptr [0x5d1639], 0x1                # 0045e524
    jmp.d8 L_0045e578                            # 0045e52e
L_0045e530:
    # block 0x0045e530: entered by jne at 0x0045e4e4, 11 instruction(s), falls into the block at 0x0045e578
    mov dword ptr [0x5b44f0], 0x16               # 0045e530
    mov dword ptr [0x5b44f4], 0x1                # 0045e53a
    mov edx, dword ptr [0x5d0377]                # 0045e544
    mov dword ptr [0x5d162d], edx                # 0045e54a
    mov eax, dword ptr [0x5b44f0]                # 0045e550
    shl eax, 0x5                                 # 0045e555
    mov ecx, dword ptr [0x5b44f4]                # 0045e558
    shl ecx, 0x4                                 # 0045e55e
    lea edx, [eax + ecx + 0x5b160c]              # 0045e561
    mov dword ptr [0x5d1631], edx                # 0045e568
    mov dword ptr [0x5d1639], 0x1                # 0045e56e
L_0045e578:
    # block 0x0045e578: entered by jmp at 0x0045e52e, 5 instruction(s), ends with ret 0x4
    movsx eax, word ptr [ebp + arg_8]            # 0045e578
    mov dword ptr [0x5c39e5], eax                # 0045e57c
    {load} mov esp, ebp                          # 0045e581
    pop ebp                                      # 0045e583
    ret 0x4                                      # 0045e584

