# FUN_0044d107
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0044d107
# extent:       0x0044d107-0x0044d154 (77 code bytes)
# span:         0x0044d107-0x0044d154 (code 77, tables 0, padding 0)
# sha256:       b8659b6b25caa4c455d2b9622920b146da78eff2e4e21ca2cdaa827d7556d096
# evidence:     ev_d54384a81422438ce41408b3d09c0b74870a458e28d3ae9119129a4b7b6a2bf0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0044d107
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_49; [ecx + n] field_1c, field_4a; [edx + n] field_25
# callees:      calls FUN_004d3c31, FUN_004d3d20
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_25, 0x25  # offset +0x25
.equ field_49, 0x49  # offset +0x49
.equ field_4a, 0x4a  # offset +0x4a

# --- external targets -----------------------------------------------
.set FUN_004d3c31, .text + (0x004d3c31 - 0x401000)
.set FUN_004d3d20, .text + (0x004d3d20 - 0x401000)

.org 0x0044d107 - 0x401000
.globl FUN_0044d107
FUN_0044d107:
    # block 0x0044d107: entry, 18 instruction(s), calls FUN_004d3c31, ends with je to 0x0044d150 (forward)
    push ebp                                     # 0044d107
    {load} mov ebp, esp                          # 0044d108
    push ecx                                     # 0044d10a
    mov dword ptr [ebp - local_4], ecx           # 0044d10b
    mov eax, dword ptr [ebp - local_4]           # 0044d10e
    mov word ptr [eax + field_1e], 0xffff        # 0044d111
    mov ecx, dword ptr [ebp - local_4]           # 0044d117
    mov word ptr [ecx + field_1c], 0xffff        # 0044d11a
    mov edx, dword ptr [ebp - local_4]           # 0044d120
    mov dword ptr [edx + field_25], 0x0          # 0044d123
    mov eax, dword ptr [ebp - local_4]           # 0044d12a
    mov byte ptr [eax + field_49], 0x0           # 0044d12d
    mov ecx, dword ptr [ebp - local_4]           # 0044d131
    mov byte ptr [ecx + field_4a], 0x0           # 0044d134
    mov ecx, 0x61c387                            # 0044d138
    call FUN_004d3c31                            # 0044d13d
    test eax, eax                                # 0044d142
    je.d8 L_0044d150                             # 0044d144
    # block 0x0044d146: entered by fall-through of je at 0x0044d144, 2 instruction(s), calls FUN_004d3d20, falls into the block at 0x0044d150
    mov ecx, 0x61c387                            # 0044d146
    call FUN_004d3d20                            # 0044d14b
L_0044d150:
    # block 0x0044d150: entered by je at 0x0044d144, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0044d150
    pop ebp                                      # 0044d152
    ret                                          # 0044d153

