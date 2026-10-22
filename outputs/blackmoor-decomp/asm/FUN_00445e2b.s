# FUN_00445e2b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00445e2b
# extent:       0x00445e2b-0x00445f40 (277 code bytes)
# span:         0x00445e2b-0x00445f40 (code 277, tables 0, padding 0)
# sha256:       b755881b50f8c001459010d2700cf93b729df9499fdc064d0b40219aace83219
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m445e2b_lifted
# naming:       native port src/original_methods_fl40.c:m445e2b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 69/69 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_10, field_23c, field_248, field_266; [ecx + n] field_8, field_b4, field_240, field_252, field_270; [edx + n] field_c, field_b8, field_244, field_25c, field_27a
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m445e2b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 69 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_b4, 0xb4  # offset +0xb4
.equ field_b8, 0xb8  # offset +0xb8
.equ field_23c, 0x23c  # offset +0x23c
.equ field_240, 0x240  # offset +0x240
.equ field_244, 0x244  # offset +0x244
.equ field_248, 0x248  # offset +0x248
.equ field_252, 0x252  # offset +0x252
.equ field_25c, 0x25c  # offset +0x25c
.equ field_266, 0x266  # offset +0x266
.equ field_270, 0x270  # offset +0x270
.equ field_27a, 0x27a  # offset +0x27a

# --- external targets -----------------------------------------------

.org 0x00445e2b - 0x401000
.globl FUN_00445e2b
FUN_00445e2b:
    # block 0x00445e2b: entry, 69 instruction(s), ends with ret
    push ebp                                     # 00445e2b
    {load} mov ebp, esp                          # 00445e2c
    push ecx                                     # 00445e2e
    push edi                                     # 00445e2f
    mov dword ptr [ebp - local_4], ecx           # 00445e30
    mov eax, dword ptr [ebp - local_4]           # 00445e33
    mov dword ptr [eax + field_4], 0x0           # 00445e36
    mov ecx, dword ptr [ebp - local_4]           # 00445e3d
    mov dword ptr [ecx + field_8], 0x0           # 00445e40
    mov edx, dword ptr [ebp - local_4]           # 00445e47
    mov dword ptr [edx + field_c], 0x0           # 00445e4a
    mov eax, dword ptr [ebp - local_4]           # 00445e51
    mov dword ptr [eax + field_10], 0x0          # 00445e54
    mov ecx, dword ptr [ebp - local_4]           # 00445e5b
    mov dword ptr [ecx + field_b4], 0x0          # 00445e5e
    mov edx, dword ptr [ebp - local_4]           # 00445e68
    mov dword ptr [edx + field_b8], 0x0          # 00445e6b
    mov eax, dword ptr [ebp - local_4]           # 00445e75
    mov dword ptr [eax + field_23c], 0x0         # 00445e78
    mov ecx, dword ptr [ebp - local_4]           # 00445e82
    mov dword ptr [ecx + field_240], 0x0         # 00445e85
    mov edx, dword ptr [ebp - local_4]           # 00445e8f
    mov dword ptr [edx + field_244], 0x0         # 00445e92
    mov eax, dword ptr [ebp - local_4]           # 00445e9c
    mov byte ptr [eax + field_248], 0x0          # 00445e9f
    mov ecx, dword ptr [ebp - local_4]           # 00445ea6
    mov byte ptr [ecx + field_252], 0x0          # 00445ea9
    mov edx, dword ptr [ebp - local_4]           # 00445eb0
    mov byte ptr [edx + field_25c], 0x0          # 00445eb3
    mov eax, dword ptr [ebp - local_4]           # 00445eba
    mov byte ptr [eax + field_266], 0x0          # 00445ebd
    mov ecx, dword ptr [ebp - local_4]           # 00445ec4
    mov byte ptr [ecx + field_270], 0x0          # 00445ec7
    mov edx, dword ptr [ebp - local_4]           # 00445ece
    mov byte ptr [edx + field_27a], 0x0          # 00445ed1
    mov ecx, 0xa                                 # 00445ed8
    {load} xor eax, eax                          # 00445edd
    mov edi, dword ptr [ebp - local_4]           # 00445edf
    add edi, 0x14                                # 00445ee2
    rep stosd dword ptr es:[edi], eax            # 00445ee5
    mov ecx, 0xa                                 # 00445ee7
    {load} xor eax, eax                          # 00445eec
    mov edi, dword ptr [ebp - local_4]           # 00445eee
    add edi, 0x3c                                # 00445ef1
    rep stosd dword ptr es:[edi], eax            # 00445ef4
    mov ecx, 0xa                                 # 00445ef6
    {load} xor eax, eax                          # 00445efb
    mov edi, dword ptr [ebp - local_4]           # 00445efd
    add edi, 0x64                                # 00445f00
    rep stosd dword ptr es:[edi], eax            # 00445f03
    mov ecx, 0xa                                 # 00445f05
    {load} xor eax, eax                          # 00445f0a
    mov edi, dword ptr [ebp - local_4]           # 00445f0c
    add edi, 0x8c                                # 00445f0f
    rep stosd dword ptr es:[edi], eax            # 00445f15
    mov ecx, 0x2e                                # 00445f17
    {load} xor eax, eax                          # 00445f1c
    mov edi, dword ptr [ebp - local_4]           # 00445f1e
    add edi, 0xbc                                # 00445f21
    rep stosd dword ptr es:[edi], eax            # 00445f27
    mov ecx, 0x32                                # 00445f29
    {load} xor eax, eax                          # 00445f2e
    mov edi, dword ptr [ebp - local_4]           # 00445f30
    add edi, 0x174                               # 00445f33
    rep stosd dword ptr es:[edi], eax            # 00445f39
    pop edi                                      # 00445f3b
    {load} mov esp, ebp                          # 00445f3c
    pop ebp                                      # 00445f3e
    ret                                          # 00445f3f

