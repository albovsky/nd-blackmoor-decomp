# FUN_0048aa66
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048aa66
# extent:       0x0048aa66-0x0048ab49 (227 code bytes)
# span:         0x0048aa66-0x0048ab49 (code 227, tables 0, padding 0)
# sha256:       dc70741c555e822c4df254936ddb29f875df0566f03977007e3ba323f847a80e
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48aa66_lifted
# naming:       native port src/original_methods_fl39d.c:m48aa66_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (34 recipes, original bytes run under Unicorn; golden vectors in the direct test). Not original source structure. All instructions run; both jump directions taken.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edx + n] field_1b0
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m48aa66_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 43 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_1b0, 0x1b0  # offset +0x1b0

# --- external targets -----------------------------------------------

.org 0x0048aa66 - 0x401000
.globl FUN_0048aa66
FUN_0048aa66:
    # block 0x0048aa66: entry, 7 instruction(s), ends with jne to 0x0048aad8 (forward)
    push ebp                                     # 0048aa66
    {load} mov ebp, esp                          # 0048aa67
    push ecx                                     # 0048aa69
    mov dword ptr [ebp - local_4], ecx           # 0048aa6a
    movsx eax, word ptr [ebp + arg_8]            # 0048aa6d
    cmp eax, 0x2757                              # 0048aa71
    jne.d8 L_0048aad8                            # 0048aa76
    # block 0x0048aa78: entered by fall-through of jne at 0x0048aa76, 15 instruction(s), ends with forward jump to 0x0048ab43
    mov dword ptr [0x5b44f0], 0x9                # 0048aa78
    mov dword ptr [0x5b44f4], 0x1                # 0048aa82
    mov ecx, dword ptr [0x5d0377]                # 0048aa8c
    mov dword ptr [0x5d162d], ecx                # 0048aa92
    mov edx, dword ptr [0x5b44f0]                # 0048aa98
    shl edx, 0x5                                 # 0048aa9e
    mov eax, dword ptr [0x5b44f4]                # 0048aaa1
    shl eax, 0x4                                 # 0048aaa6
    lea ecx, [edx + eax + 0x5b160c]              # 0048aaa9
    mov dword ptr [0x5d1631], ecx                # 0048aab0
    mov dword ptr [0x5d1639], 0x1                # 0048aab6
    mov dword ptr [0x5c39e5], 0x2757             # 0048aac0
    mov edx, dword ptr [ebp - local_4]           # 0048aaca
    mov word ptr [edx + field_1b0], 0xffff       # 0048aacd
    jmp.d8 L_0048ab43                            # 0048aad6
L_0048aad8:
    # block 0x0048aad8: entered by jne at 0x0048aa76, 3 instruction(s), ends with jne to 0x0048ab43 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0048aad8
    cmp eax, 0x2756                              # 0048aadc
    jne.d8 L_0048ab43                            # 0048aae1
    # block 0x0048aae3: entered by fall-through of jne at 0x0048aae1, 15 instruction(s), falls into the block at 0x0048ab43
    mov dword ptr [0x5b44f0], 0x16               # 0048aae3
    mov dword ptr [0x5b44f4], 0x1                # 0048aaed
    mov ecx, dword ptr [0x5d0377]                # 0048aaf7
    mov dword ptr [0x5d162d], ecx                # 0048aafd
    mov edx, dword ptr [0x5b44f0]                # 0048ab03
    shl edx, 0x5                                 # 0048ab09
    mov eax, dword ptr [0x5b44f4]                # 0048ab0c
    shl eax, 0x4                                 # 0048ab11
    lea ecx, [edx + eax + 0x5b160c]              # 0048ab14
    mov dword ptr [0x5d1631], ecx                # 0048ab1b
    mov dword ptr [0x5d1639], 0x1                # 0048ab21
    mov dword ptr [0x5c39e5], 0x2756             # 0048ab2b
    mov edx, dword ptr [ebp - local_4]           # 0048ab35
    mov ax, word ptr [ebp + arg_c]               # 0048ab38
    mov word ptr [edx + field_1b0], ax           # 0048ab3c
L_0048ab43:
    # block 0x0048ab43: entered by jmp at 0x0048aad6; jne at 0x0048aae1, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0048ab43
    pop ebp                                      # 0048ab45
    ret 0x8                                      # 0048ab46

