# FUN_00478915
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00478915
# extent:       0x00478915-0x004789d6 (193 code bytes)
# span:         0x00478915-0x004789d6 (code 193, tables 0, padding 0)
# sha256:       25cf4e4ee7dca4b22368966c42970d8edab6b53e70b587478020f89bcdba8d31
# evidence:     ev_f110a51708a87e42a1df088442ce84584fa97ada22af5597067d90dfc82d854f
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m478915_lifted
# naming:       native port src/original_methods_fl40.c:m478915_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 4 seeds; oracle: 50/50 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_21, field_158, field_1c0, field_1566, field_156a, field_156e, field_158a; [ecx + n] field_23, field_15c, field_156a, field_1572; [edx + n] field_1c0, field_1566, field_1586
# callees:      calls FUN_00478e7b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m478915_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 50 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_158, 0x158  # offset +0x158
.equ field_15c, 0x15c  # offset +0x15c
.equ field_1c0, 0x1c0  # offset +0x1c0
.equ field_1566, 0x1566  # offset +0x1566
.equ field_156a, 0x156a  # offset +0x156a
.equ field_156e, 0x156e  # offset +0x156e
.equ field_1572, 0x1572  # offset +0x1572
.equ field_1586, 0x1586  # offset +0x1586
.equ field_158a, 0x158a  # offset +0x158a

# --- external targets -----------------------------------------------
.set FUN_00478e7b, .text + (0x00478e7b - 0x401000)

.org 0x00478915 - 0x401000
.globl FUN_00478915
FUN_00478915:
    # block 0x00478915: entry, 50 instruction(s), calls FUN_00478e7b, ends with ret
    push ebp                                     # 00478915
    {load} mov ebp, esp                          # 00478916
    sub esp, 0x8                                 # 00478918
    mov dword ptr [ebp - local_8], ecx           # 0047891b
    mov eax, dword ptr [ebp - local_8]           # 0047891e
    movsx ecx, word ptr [eax + field_1e]         # 00478921
    imul ecx, ecx, 0x8d                          # 00478925
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0047892b
    mov dword ptr [ebp - local_4], edx           # 00478931
    mov eax, dword ptr [ebp - local_4]           # 00478934
    mov ecx, dword ptr [eax + field_158]         # 00478937
    add ecx, dword ptr [0x583186]                # 0047893d
    mov edx, dword ptr [ebp - local_8]           # 00478943
    mov dword ptr [edx + field_1566], ecx        # 00478946
    mov eax, dword ptr [ebp - local_4]           # 0047894c
    movsx ecx, word ptr [eax + field_21]         # 0047894f
    mov edx, dword ptr [ebp - local_4]           # 00478953
    movsx eax, word ptr [edx + field_1c0]        # 00478956
    mov edx, dword ptr [ebp - local_8]           # 0047895d
    mov edx, dword ptr [edx + field_1586]        # 00478960
    {load} add edx, eax                          # 00478966
    imul ecx, edx                                # 00478968
    mov eax, dword ptr [ebp - local_8]           # 0047896b
    mov edx, dword ptr [eax + field_1566]        # 0047896e
    {load} add edx, ecx                          # 00478974
    mov eax, dword ptr [ebp - local_8]           # 00478976
    mov dword ptr [eax + field_156e], edx        # 00478979
    mov ecx, dword ptr [ebp - local_4]           # 0047897f
    mov edx, dword ptr [ecx + field_15c]         # 00478982
    add edx, dword ptr [0x58318a]                # 00478988
    mov eax, dword ptr [ebp - local_8]           # 0047898e
    mov dword ptr [eax + field_156a], edx        # 00478991
    mov ecx, dword ptr [ebp - local_4]           # 00478997
    movsx edx, word ptr [ecx + field_23]         # 0047899a
    mov eax, dword ptr [ebp - local_4]           # 0047899e
    movsx ecx, word ptr [eax + field_1c0]        # 004789a1
    mov eax, dword ptr [ebp - local_8]           # 004789a8
    mov eax, dword ptr [eax + field_158a]        # 004789ab
    {load} add eax, ecx                          # 004789b1
    imul edx, eax                                # 004789b3
    mov ecx, dword ptr [ebp - local_8]           # 004789b6
    mov eax, dword ptr [ecx + field_156a]        # 004789b9
    {load} add eax, edx                          # 004789bf
    mov ecx, dword ptr [ebp - local_8]           # 004789c1
    mov dword ptr [ecx + field_1572], eax        # 004789c4
    mov ecx, dword ptr [ebp - local_8]           # 004789ca
    call FUN_00478e7b                            # 004789cd
    {load} mov esp, ebp                          # 004789d2
    pop ebp                                      # 004789d4
    ret                                          # 004789d5

