# FUN_0046b855
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046b855
# extent:       0x0046b855-0x0046b954 (255 code bytes)
# span:         0x0046b855-0x0046b954 (code 255, tables 0, padding 0)
# sha256:       ee3083efcaba309e5231564c06ff57b131e541949762223e710fcec6c4bd889f
# evidence:     ev_6f599cab3f17e12adbc143b2bc9a4485485dbe70817326805f2abd1569d53704
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m46b855_clamp_to_bounds
# naming:       native port src/original_methods_fl38c.c:m46b855_clamp_to_bounds (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Clamps self[0x49f8,0x4a00] and self[0x49f4,0x49fc] into global bounds [0x58319a,0x5831a2], [0x583196,0x58319e], extents int16 +0x816c, +0x816a. 63/63 instructions, 8/8 jump ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_49f4, field_49f8, field_49fc, field_4a00; [ecx + n] field_816a, field_816c; [edx + n] field_49f4, field_49f8, field_49fc, field_4a00
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl38c.c:m46b855_clamp_to_bounds (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 63 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_49f4, 0x49f4  # offset +0x49f4
.equ field_49f8, 0x49f8  # offset +0x49f8
.equ field_49fc, 0x49fc  # offset +0x49fc
.equ field_4a00, 0x4a00  # offset +0x4a00
.equ field_816a, 0x816a  # offset +0x816a
.equ field_816c, 0x816c  # offset +0x816c

# --- external targets -----------------------------------------------

.org 0x0046b855 - 0x401000
.globl FUN_0046b855
FUN_0046b855:
    # block 0x0046b855: entry, 8 instruction(s), ends with jge to 0x0046b899 (forward)
    push ebp                                     # 0046b855
    {load} mov ebp, esp                          # 0046b856
    push ecx                                     # 0046b858
    mov dword ptr [ebp - local_4], ecx           # 0046b859
    mov eax, dword ptr [ebp - local_4]           # 0046b85c
    mov ecx, dword ptr [eax + field_49f8]        # 0046b85f
    cmp ecx, dword ptr [0x58319a]                # 0046b865
    jge.d8 L_0046b899                            # 0046b86b
    # block 0x0046b86d: entered by fall-through of jge at 0x0046b86b, 10 instruction(s), falls into the block at 0x0046b899
    mov edx, dword ptr [ebp - local_4]           # 0046b86d
    mov eax, dword ptr [0x58319a]                # 0046b870
    mov dword ptr [edx + field_49f8], eax        # 0046b875
    mov ecx, dword ptr [ebp - local_4]           # 0046b87b
    movsx edx, word ptr [ecx + field_816c]       # 0046b87e
    mov eax, dword ptr [ebp - local_4]           # 0046b885
    mov ecx, dword ptr [eax + field_49f8]        # 0046b888
    {load} add ecx, edx                          # 0046b88e
    mov edx, dword ptr [ebp - local_4]           # 0046b890
    mov dword ptr [edx + field_4a00], ecx        # 0046b893
L_0046b899:
    # block 0x0046b899: entered by jge at 0x0046b86b, 4 instruction(s), ends with jle to 0x0046b8d6 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046b899
    mov ecx, dword ptr [eax + field_4a00]        # 0046b89c
    cmp ecx, dword ptr [0x5831a2]                # 0046b8a2
    jle.d8 L_0046b8d6                            # 0046b8a8
    # block 0x0046b8aa: entered by fall-through of jle at 0x0046b8a8, 10 instruction(s), falls into the block at 0x0046b8d6
    mov edx, dword ptr [ebp - local_4]           # 0046b8aa
    mov eax, dword ptr [0x5831a2]                # 0046b8ad
    mov dword ptr [edx + field_4a00], eax        # 0046b8b2
    mov ecx, dword ptr [ebp - local_4]           # 0046b8b8
    movsx edx, word ptr [ecx + field_816c]       # 0046b8bb
    mov eax, dword ptr [ebp - local_4]           # 0046b8c2
    mov ecx, dword ptr [eax + field_4a00]        # 0046b8c5
    {load} sub ecx, edx                          # 0046b8cb
    mov edx, dword ptr [ebp - local_4]           # 0046b8cd
    mov dword ptr [edx + field_49f8], ecx        # 0046b8d0
L_0046b8d6:
    # block 0x0046b8d6: entered by jle at 0x0046b8a8, 4 instruction(s), ends with jge to 0x0046b913 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046b8d6
    mov ecx, dword ptr [eax + field_49f4]        # 0046b8d9
    cmp ecx, dword ptr [0x583196]                # 0046b8df
    jge.d8 L_0046b913                            # 0046b8e5
    # block 0x0046b8e7: entered by fall-through of jge at 0x0046b8e5, 10 instruction(s), falls into the block at 0x0046b913
    mov edx, dword ptr [ebp - local_4]           # 0046b8e7
    mov eax, dword ptr [0x583196]                # 0046b8ea
    mov dword ptr [edx + field_49f4], eax        # 0046b8ef
    mov ecx, dword ptr [ebp - local_4]           # 0046b8f5
    movsx edx, word ptr [ecx + field_816a]       # 0046b8f8
    mov eax, dword ptr [ebp - local_4]           # 0046b8ff
    mov ecx, dword ptr [eax + field_49f4]        # 0046b902
    {load} add ecx, edx                          # 0046b908
    mov edx, dword ptr [ebp - local_4]           # 0046b90a
    mov dword ptr [edx + field_49fc], ecx        # 0046b90d
L_0046b913:
    # block 0x0046b913: entered by jge at 0x0046b8e5, 4 instruction(s), ends with jle to 0x0046b950 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046b913
    mov ecx, dword ptr [eax + field_49fc]        # 0046b916
    cmp ecx, dword ptr [0x58319e]                # 0046b91c
    jle.d8 L_0046b950                            # 0046b922
    # block 0x0046b924: entered by fall-through of jle at 0x0046b922, 10 instruction(s), falls into the block at 0x0046b950
    mov edx, dword ptr [ebp - local_4]           # 0046b924
    mov eax, dword ptr [0x58319e]                # 0046b927
    mov dword ptr [edx + field_49fc], eax        # 0046b92c
    mov ecx, dword ptr [ebp - local_4]           # 0046b932
    movsx edx, word ptr [ecx + field_816a]       # 0046b935
    mov eax, dword ptr [ebp - local_4]           # 0046b93c
    mov ecx, dword ptr [eax + field_49fc]        # 0046b93f
    {load} sub ecx, edx                          # 0046b945
    mov edx, dword ptr [ebp - local_4]           # 0046b947
    mov dword ptr [edx + field_49f4], ecx        # 0046b94a
L_0046b950:
    # block 0x0046b950: entered by jle at 0x0046b922, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0046b950
    pop ebp                                      # 0046b952
    ret                                          # 0046b953

