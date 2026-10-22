# FUN_00446ffb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00446ffb
# extent:       0x00446ffb-0x00447166 (363 code bytes)
# span:         0x00446ffb-0x00447166 (code 363, tables 0, padding 0)
# sha256:       cc4db654f3be4ff4a547245ae96732692a9dc174fa743a71cf505b35f14d651a
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m446ffb_lifted
# naming:       native port src/original_methods_fl40.c:m446ffb_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 2 seeds; oracle: 104/104 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1c, field_21, field_39, field_45; [ecx + n] field_4, field_8, field_c, field_10, field_14, field_25, field_35, field_39, field_3d; [edx + n] field_1d, field_29, field_31, field_39, field_41
# callees:      calls FUN_004473a9, FUN_0051dc43, FUN_0050ca3e, FUN_0042639d, FUN_004c97b4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m446ffb_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 104 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1d, 0x1d  # offset +0x1d
.equ field_21, 0x21  # offset +0x21
.equ field_25, 0x25  # offset +0x25
.equ field_29, 0x29  # offset +0x29
.equ field_31, 0x31  # offset +0x31
.equ field_35, 0x35  # offset +0x35
.equ field_39, 0x39  # offset +0x39
.equ field_3d, 0x3d  # offset +0x3d
.equ field_41, 0x41  # offset +0x41
.equ field_45, 0x45  # offset +0x45

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004473a9, .text + (0x004473a9 - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00446ffb - 0x401000
.globl FUN_00446ffb
FUN_00446ffb:
    # block 0x00446ffb: entry, 58 instruction(s), calls FUN_004473a9, FUN_0051dc43, ends with jne to 0x004470eb (forward)
    push ebp                                     # 00446ffb
    {load} mov ebp, esp                          # 00446ffc
    sub esp, 0xc                                 # 00446ffe
    mov dword ptr [ebp - local_c], ecx           # 00447001
    mov eax, dword ptr [ebp - local_c]           # 00447004
    mov byte ptr [eax + field_1c], 0x0           # 00447007
    mov ecx, dword ptr [ebp - local_c]           # 0044700b
    call FUN_004473a9                            # 0044700e
    mov ecx, dword ptr [ebp - local_c]           # 00447013
    add ecx, 0x1d                                # 00447016
    mov edx, dword ptr [0x583186]                # 00447019
    mov dword ptr [ecx], edx                     # 0044701f
    mov eax, dword ptr [0x58318a]                # 00447021
    mov dword ptr [ecx + field_4], eax           # 00447026
    mov edx, dword ptr [0x58318e]                # 00447029
    mov dword ptr [ecx + field_8], edx           # 0044702f
    mov eax, dword ptr [0x583192]                # 00447032
    mov dword ptr [ecx + field_c], eax           # 00447037
    mov ecx, dword ptr [ebp - local_c]           # 0044703a
    mov edx, dword ptr [ebp - local_c]           # 0044703d
    mov eax, dword ptr [ecx + field_25]          # 00447040
    sub eax, dword ptr [edx + field_1d]          # 00447043
    add eax, 0x1                                 # 00447046
    mov ecx, dword ptr [ebp - local_c]           # 00447049
    mov dword ptr [ecx + field_3d], eax          # 0044704c
    mov edx, dword ptr [ebp - local_c]           # 0044704f
    mov eax, dword ptr [ebp - local_c]           # 00447052
    mov ecx, dword ptr [edx + field_29]          # 00447055
    sub ecx, dword ptr [eax + field_21]          # 00447058
    add ecx, 0x1                                 # 0044705b
    mov edx, dword ptr [ebp - local_c]           # 0044705e
    mov dword ptr [edx + field_41], ecx          # 00447061
    movsx eax, word ptr [0x639895]               # 00447064
    mov ecx, dword ptr [ebp - local_c]           # 0044706b
    mov edx, dword ptr [ecx + field_3d]          # 0044706e
    imul edx, eax                                # 00447071
    mov eax, dword ptr [ebp - local_c]           # 00447074
    mov dword ptr [eax + field_45], edx          # 00447077
    mov ecx, dword ptr [ebp - local_c]           # 0044707a
    mov edx, dword ptr [ebp - local_c]           # 0044707d
    mov eax, dword ptr [ecx + field_3d]          # 00447080
    imul eax, dword ptr [edx + field_41]         # 00447083
    mov ecx, dword ptr [ebp - local_c]           # 00447087
    mov dword ptr [ecx + field_39], eax          # 0044708a
    mov edx, dword ptr [ebp - local_c]           # 0044708d
    mov dword ptr [edx + field_31], 0x0          # 00447090
    mov eax, dword ptr [ebp - local_c]           # 00447097
    mov ecx, dword ptr [eax + field_39]          # 0044709a
    imul ecx, ecx, 0xc                           # 0044709d
    push ecx                                     # 004470a0
    call FUN_0051dc43                            # 004470a1
    add esp, 0x4                                 # 004470a6
    mov dword ptr [ebp - local_4], eax           # 004470a9
    mov edx, dword ptr [ebp - local_c]           # 004470ac
    mov eax, dword ptr [ebp - local_4]           # 004470af
    mov dword ptr [edx + field_31], eax          # 004470b2
    cmp dword ptr [ebp - local_4], 0x0           # 004470b5
    jne.d8 L_004470eb                            # 004470b9
    # block 0x004470bb: entered by fall-through of jne at 0x004470b9, 10 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x004470eb
    push 0x548388                                # 004470bb
    push 0x63888b                                # 004470c0
    call FUN_0050ca3e                            # 004470c5
    add esp, 0x8                                 # 004470ca
    push 0x63888b                                # 004470cd
    push 0x5483d0                                # 004470d2
    mov ecx, 0x583979                            # 004470d7
    call FUN_0042639d                            # 004470dc
    mov ecx, 0x5cf659                            # 004470e1
    call FUN_004c97b4                            # 004470e6
L_004470eb:
    # block 0x004470eb: entered by jne at 0x004470b9, 14 instruction(s), calls FUN_0051dc43, ends with jne to 0x00447149 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004470eb
    mov dword ptr [ecx + field_35], 0x0          # 004470ee
    mov edx, dword ptr [ebp - local_c]           # 004470f5
    mov eax, dword ptr [edx + field_39]          # 004470f8
    imul eax, eax, 0xc                           # 004470fb
    push eax                                     # 004470fe
    call FUN_0051dc43                            # 004470ff
    add esp, 0x4                                 # 00447104
    mov dword ptr [ebp - local_8], eax           # 00447107
    mov ecx, dword ptr [ebp - local_c]           # 0044710a
    mov edx, dword ptr [ebp - local_8]           # 0044710d
    mov dword ptr [ecx + field_35], edx          # 00447110
    cmp dword ptr [ebp - local_8], 0x0           # 00447113
    jne.d8 L_00447149                            # 00447117
    # block 0x00447119: entered by fall-through of jne at 0x00447117, 10 instruction(s), calls FUN_0050ca3e, FUN_0042639d, FUN_004c97b4, falls into the block at 0x00447149
    push 0x5483ec                                # 00447119
    push 0x63888b                                # 0044711e
    call FUN_0050ca3e                            # 00447123
    add esp, 0x8                                 # 00447128
    push 0x63888b                                # 0044712b
    push 0x548434                                # 00447130
    mov ecx, 0x583979                            # 00447135
    call FUN_0042639d                            # 0044713a
    mov ecx, 0x5cf659                            # 0044713f
    call FUN_004c97b4                            # 00447144
L_00447149:
    # block 0x00447149: entered by jne at 0x00447117, 12 instruction(s), ends with ret
    {load} xor eax, eax                          # 00447149
    mov ecx, dword ptr [ebp - local_c]           # 0044714b
    add ecx, 0x49                                # 0044714e
    mov dword ptr [ecx], eax                     # 00447151
    mov dword ptr [ecx + field_4], eax           # 00447153
    mov dword ptr [ecx + field_8], eax           # 00447156
    mov dword ptr [ecx + field_c], eax           # 00447159
    mov dword ptr [ecx + field_10], eax          # 0044715c
    mov byte ptr [ecx + field_14], al            # 0044715f
    {load} mov esp, ebp                          # 00447162
    pop ebp                                      # 00447164
    ret                                          # 00447165

