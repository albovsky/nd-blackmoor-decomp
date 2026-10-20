# FUN_0045b7a8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b7a8
# extent:       0x0045b7a8-0x0045b872 (202 code bytes)
# span:         0x0045b7a8-0x0045b872 (code 202, tables 0, padding 0)
# sha256:       c9ffd6250f130ce3825d3e66ee88b47d482c9dcb2e4e6309c54770660e6918ca
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45b7a8_arm_hotspot
# naming:       native port src/original_methods_fl18.c:m45b7a8_arm_hotspot (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m45b7a8_arm_hotspot. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 202 bytes.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [edx + n] field_172
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl18.c:m45b7a8_arm_hotspot (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 40 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_172, 0x172  # offset +0x172

# --- external targets -----------------------------------------------

.org 0x0045b7a8 - 0x401000
.globl FUN_0045b7a8
FUN_0045b7a8:
    # block 0x0045b7a8: entry, 7 instruction(s), ends with jne to 0x0045b80e (forward)
    push ebp                                     # 0045b7a8
    {load} mov ebp, esp                          # 0045b7a9
    push ecx                                     # 0045b7ab
    mov dword ptr [ebp - local_4], ecx           # 0045b7ac
    movsx eax, word ptr [ebp + arg_8]            # 0045b7af
    cmp eax, 0x27bb                              # 0045b7b3
    jne.d8 L_0045b80e                            # 0045b7b8
    # block 0x0045b7ba: entered by fall-through of jne at 0x0045b7b8, 14 instruction(s), ends with forward jump to 0x0045b86c
    mov ecx, dword ptr [0x5d0377]                # 0045b7ba
    mov dword ptr [0x5d162d], ecx                # 0045b7c0
    mov dword ptr [0x5b44f0], 0x9                # 0045b7c6
    mov dword ptr [0x5b44f4], 0x1                # 0045b7d0
    mov edx, dword ptr [0x5b44f0]                # 0045b7da
    shl edx, 0x5                                 # 0045b7e0
    mov eax, dword ptr [0x5b44f4]                # 0045b7e3
    shl eax, 0x4                                 # 0045b7e8
    lea ecx, [edx + eax + 0x5b160c]              # 0045b7eb
    mov dword ptr [0x5d1631], ecx                # 0045b7f2
    mov dword ptr [0x5d1639], 0x1                # 0045b7f8
    movsx edx, word ptr [ebp + arg_8]            # 0045b802
    mov dword ptr [0x5c39e5], edx                # 0045b806
    jmp.d8 L_0045b86c                            # 0045b80c
L_0045b80e:
    # block 0x0045b80e: entered by jne at 0x0045b7b8, 16 instruction(s), falls into the block at 0x0045b86c
    mov dword ptr [0x5b44f0], 0x16               # 0045b80e
    mov dword ptr [0x5b44f4], 0x1                # 0045b818
    mov eax, dword ptr [0x5d0377]                # 0045b822
    mov dword ptr [0x5d162d], eax                # 0045b827
    mov ecx, dword ptr [0x5b44f0]                # 0045b82c
    shl ecx, 0x5                                 # 0045b832
    mov edx, dword ptr [0x5b44f4]                # 0045b835
    shl edx, 0x4                                 # 0045b83b
    lea eax, [ecx + edx + 0x5b160c]              # 0045b83e
    mov dword ptr [0x5d1631], eax                # 0045b845
    mov dword ptr [0x5d1639], 0x1                # 0045b84a
    movsx ecx, word ptr [ebp + arg_8]            # 0045b854
    mov dword ptr [0x5c39e5], ecx                # 0045b858
    mov edx, dword ptr [ebp - local_4]           # 0045b85e
    mov ax, word ptr [ebp + arg_c]               # 0045b861
    mov word ptr [edx + field_172], ax           # 0045b865
L_0045b86c:
    # block 0x0045b86c: entered by jmp at 0x0045b80c, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0045b86c
    pop ebp                                      # 0045b86e
    ret 0x8                                      # 0045b86f

