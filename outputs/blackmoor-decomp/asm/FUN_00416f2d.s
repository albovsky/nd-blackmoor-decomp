# FUN_00416f2d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00416f2d
# extent:       0x00416f2d-0x00416fb6 (137 code bytes)
# span:         0x00416f2d-0x00416fb6 (code 137, tables 0, padding 0)
# sha256:       be029f1b583071744bf6518ef8ed1acd43e8270590beee6109cdd7a83f1bb169
# evidence:     ev_ee34a6178f9dbede580b7391fe3cb5d437b4b7e8eef1f6ac592ff17c28c7115c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00416f2d
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_c, local_10, local_14
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0041a336, FUN_0041a4be, FUN_0051d730
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36d.c:m41a480_scalar_deleting_dtor (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14

# --- external targets -----------------------------------------------
.set FUN_0041a336, .text + (0x0041a336 - 0x401000)
.set FUN_0041a4be, .text + (0x0041a4be - 0x401000)
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00416f2d - 0x401000
.globl FUN_00416f2d
FUN_00416f2d:
    # block 0x00416f2d: entry, 14 instruction(s), ends with forward jump to 0x00416f6f
    push ebp                                     # 00416f2d
    {load} mov ebp, esp                          # 00416f2e
    push -0x1                                    # 00416f30
    push 0x5272db                                # 00416f32
    mov eax, dword ptr fs:[0x0]                  # 00416f37
    push eax                                     # 00416f3d
    mov dword ptr fs:[0x0], esp                  # 00416f3e
    sub esp, 0x8                                 # 00416f45
    mov dword ptr [ebp - local_14], ecx          # 00416f48
    mov eax, dword ptr [ebp - local_14]          # 00416f4b
    mov dword ptr [eax], 0x52c5a0                # 00416f4e
    mov dword ptr [ebp - local_4], 0x1           # 00416f54
    mov word ptr [ebp - local_10], 0x0           # 00416f5b
    jmp.d8 L_00416f6f                            # 00416f61
L_00416f63:
    # block 0x00416f63: entered by jmp at 0x00416f85, 3 instruction(s), falls into the block at 0x00416f6f
    mov cx, word ptr [ebp - local_10]            # 00416f63
    add cx, 0x1                                  # 00416f67
    mov word ptr [ebp - local_10], cx            # 00416f6b
L_00416f6f:
    # block 0x00416f6f: entered by jmp at 0x00416f61, 3 instruction(s), ends with jge to 0x00416f87 (forward)
    movsx edx, word ptr [ebp - local_10]         # 00416f6f
    cmp edx, 0x1e                                # 00416f73
    jge.d8 L_00416f87                            # 00416f76
    # block 0x00416f78: entered by fall-through of jge at 0x00416f76, 5 instruction(s), calls FUN_0041a336, ends with backward jump to 0x00416f63
    mov ax, word ptr [ebp - local_10]            # 00416f78
    push eax                                     # 00416f7c
    mov ecx, dword ptr [ebp - local_14]          # 00416f7d
    call FUN_0041a336                            # 00416f80
    jmp.d8 L_00416f63                            # 00416f85
L_00416f87:
    # block 0x00416f87: entered by jge at 0x00416f76, 12 instruction(s), calls FUN_0041a4be, FUN_0051d730, ends with ret
    mov byte ptr [ebp - local_4], 0x0            # 00416f87
    mov ecx, dword ptr [ebp - local_14]          # 00416f8b
    add ecx, 0x51f                               # 00416f8e
    call FUN_0041a4be                            # 00416f94
    mov dword ptr [ebp - local_4], 0xffffffff    # 00416f99
    mov ecx, dword ptr [ebp - local_14]          # 00416fa0
    call FUN_0051d730                            # 00416fa3
    mov ecx, dword ptr [ebp - local_c]           # 00416fa8
    mov dword ptr fs:[0x0], ecx                  # 00416fab
    {load} mov esp, ebp                          # 00416fb2
    pop ebp                                      # 00416fb4
    ret                                          # 00416fb5

