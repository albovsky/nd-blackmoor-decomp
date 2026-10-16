# FUN_00514467
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00514467
# extent:       0x00514467-0x005144ef (136 code bytes)
# span:         0x00514467-0x005144ef (code 136, tables 0, padding 0)
# sha256:       907cb47f56cf2cf5991ea1f5187f56eb233fb15770bf720db692c47b9499e60f
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00514467
# arguments:    9 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18, arg_1c, arg_20, arg_24, arg_28; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       8 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18, local_1c, local_20
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00514517, FUN_005146dc, FUN_005188cb, FUN_005144ef
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 49 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1c, 0x1c  # offset -0x1c
.equ local_20, 0x20  # offset -0x20
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18
.equ arg_1c, 0x1c  # offset +0x1c
.equ arg_20, 0x20  # offset +0x20
.equ arg_24, 0x24  # offset +0x24
.equ arg_28, 0x28  # offset +0x28

# --- external targets -----------------------------------------------
.set FUN_005144ef, .text + (0x005144ef - 0x401000)
.set FUN_00514517, .text + (0x00514517 - 0x401000)
.set FUN_005146dc, .text + (0x005146dc - 0x401000)
.set FUN_005188cb, .text + (0x005188cb - 0x401000)

.org 0x00514467 - 0x401000
.globl FUN_00514467
FUN_00514467:
    # block 0x00514467: entry, 9 instruction(s), calls FUN_00514517, ends with je to 0x005144d2 (forward)
    push ebp                                     # 00514467
    {load} mov ebp, esp                          # 00514468
    sub esp, 0x20                                # 0051446a
    push dword ptr [ebp + arg_c]                 # 0051446d
    call FUN_00514517                            # 00514470
    test eax, eax                                # 00514475
    pop ecx                                      # 00514477
    mov dword ptr [ebp - local_1c], eax          # 00514478
    je.d8 L_005144d2                             # 0051447b
    # block 0x0051447d: entered by fall-through of je at 0x0051447b, 24 instruction(s), calls FUN_005146dc, FUN_005188cb, ends with jne to 0x005144cc (forward)
    mov eax, dword ptr [ebp + arg_10]            # 0051447d
    push esi                                     # 00514480
    mov dword ptr [ebp - local_18], eax          # 00514481
    mov eax, dword ptr [ebp + arg_14]            # 00514484
    mov dword ptr [ebp - local_14], eax          # 00514487
    mov eax, dword ptr [ebp + arg_18]            # 0051448a
    mov esi, dword ptr [ebp + arg_8]             # 0051448d
    mov dword ptr [ebp - local_10], eax          # 00514490
    mov eax, dword ptr [ebp + arg_1c]            # 00514493
    push 0xffff                                  # 00514496
    push dword ptr [ebp + arg_28]                # 0051449b
    mov dword ptr [ebp - local_c], eax           # 0051449e
    mov eax, dword ptr [ebp + arg_20]            # 005144a1
    mov dword ptr [ebp - local_20], esi          # 005144a4
    mov dword ptr [ebp - local_8], eax           # 005144a7
    mov eax, dword ptr [ebp + arg_24]            # 005144aa
    mov dword ptr [ebp - local_4], eax           # 005144ad
    call FUN_005146dc                            # 005144b0
    lea eax, [ebp - local_20]                    # 005144b5
    push eax                                     # 005144b8
    call FUN_005188cb                            # 005144b9
    add esp, 0xc                                 # 005144be
    test eax, eax                                # 005144c1
    jne.d8 L_005144cc                            # 005144c3
    # block 0x005144c5: entered by fall-through of jne at 0x005144c3, 3 instruction(s), calls FUN_005144ef, falls into the block at 0x005144cc
    push esi                                     # 005144c5
    call FUN_005144ef                            # 005144c6
    pop ecx                                      # 005144cb
L_005144cc:
    # block 0x005144cc: entered by jne at 0x005144c3, 4 instruction(s), ends with ret
    fld qword ptr [ebp - local_8]                # 005144cc
    pop esi                                      # 005144cf
    leave                                        # 005144d0
    ret                                          # 005144d1
L_005144d2:
    # block 0x005144d2: entered by je at 0x0051447b, 9 instruction(s), calls FUN_005146dc, FUN_005144ef, ends with ret
    push 0xffff                                  # 005144d2
    push dword ptr [ebp + arg_28]                # 005144d7
    call FUN_005146dc                            # 005144da
    push dword ptr [ebp + arg_8]                 # 005144df
    call FUN_005144ef                            # 005144e2
    fld qword ptr [ebp + arg_20]                 # 005144e7
    add esp, 0xc                                 # 005144ea
    leave                                        # 005144ed
    ret                                          # 005144ee

