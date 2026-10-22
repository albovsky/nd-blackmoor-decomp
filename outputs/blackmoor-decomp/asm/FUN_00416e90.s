# FUN_00416e90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00416e90
# extent:       0x00416e90-0x00416f2d (157 code bytes)
# span:         0x00416e90-0x00416f2d (code 157, tables 0, padding 0)
# sha256:       5f4ffcc6912a014130917e0723a858621be3a6834d695a341166288dcfef339a
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m416e90_lifted
# naming:       native port src/original_methods_fl40.c:m416e90_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 1 seeds; oracle 45/45 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_c, local_10, local_14
# fields:       [esi + n] field_57f
# callees:      calls FUN_0051d716, FUN_0041a4b0
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m416e90_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 45 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_57f, 0x57f  # offset +0x57f

# --- external targets -----------------------------------------------
.set FUN_0041a4b0, .text + (0x0041a4b0 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x00416e90 - 0x401000
.globl FUN_00416e90
FUN_00416e90:
    # block 0x00416e90: entry, 21 instruction(s), calls FUN_0051d716, FUN_0041a4b0, ends with forward jump to 0x00416eea
    push ebp                                     # 00416e90
    {load} mov ebp, esp                          # 00416e91
    push -0x1                                    # 00416e93
    push 0x5272b9                                # 00416e95
    mov eax, dword ptr fs:[0x0]                  # 00416e9a
    push eax                                     # 00416ea0
    mov dword ptr fs:[0x0], esp                  # 00416ea1
    sub esp, 0x8                                 # 00416ea8
    push esi                                     # 00416eab
    push edi                                     # 00416eac
    mov dword ptr [ebp - local_14], ecx          # 00416ead
    mov ecx, dword ptr [ebp - local_14]          # 00416eb0
    call FUN_0051d716                            # 00416eb3
    mov dword ptr [ebp - local_4], 0x0           # 00416eb8
    mov ecx, dword ptr [ebp - local_14]          # 00416ebf
    add ecx, 0x51f                               # 00416ec2
    call FUN_0041a4b0                            # 00416ec8
    mov eax, dword ptr [ebp - local_14]          # 00416ecd
    mov dword ptr [eax], 0x52c5a0                # 00416ed0
    mov word ptr [ebp - local_10], 0x0           # 00416ed6
    jmp.d8 L_00416eea                            # 00416edc
L_00416ede:
    # block 0x00416ede: entered by jmp at 0x00416f11, 3 instruction(s), falls into the block at 0x00416eea
    mov cx, word ptr [ebp - local_10]            # 00416ede
    add cx, 0x1                                  # 00416ee2
    mov word ptr [ebp - local_10], cx            # 00416ee6
L_00416eea:
    # block 0x00416eea: entered by jmp at 0x00416edc, 3 instruction(s), ends with jge to 0x00416f13 (forward)
    movsx edx, word ptr [ebp - local_10]         # 00416eea
    cmp edx, 0x1e                                # 00416eee
    jge.d8 L_00416f13                            # 00416ef1
    # block 0x00416ef3: entered by fall-through of jge at 0x00416ef1, 9 instruction(s), ends with backward jump to 0x00416ede
    mov ecx, 0x213                               # 00416ef3
    {load} xor eax, eax                          # 00416ef8
    movsx edx, word ptr [ebp - local_10]         # 00416efa
    imul edx, edx, 0x84d                         # 00416efe
    mov esi, dword ptr [ebp - local_14]          # 00416f04
    lea edi, [esi + edx + field_57f]             # 00416f07
    rep stosd dword ptr es:[edi], eax            # 00416f0e
    stosb byte ptr es:[edi], al                  # 00416f10
    jmp.d8 L_00416ede                            # 00416f11
L_00416f13:
    # block 0x00416f13: entered by jge at 0x00416ef1, 9 instruction(s), ends with ret
    mov dword ptr [ebp - local_4], 0xffffffff    # 00416f13
    mov eax, dword ptr [ebp - local_14]          # 00416f1a
    mov ecx, dword ptr [ebp - local_c]           # 00416f1d
    mov dword ptr fs:[0x0], ecx                  # 00416f20
    pop edi                                      # 00416f27
    pop esi                                      # 00416f28
    {load} mov esp, ebp                          # 00416f29
    pop ebp                                      # 00416f2b
    ret                                          # 00416f2c

