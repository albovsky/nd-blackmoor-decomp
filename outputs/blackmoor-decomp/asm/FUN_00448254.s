# FUN_00448254
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00448254
# extent:       0x00448254-0x00448354 (256 code bytes)
# span:         0x00448254-0x00448354 (code 256, tables 0, padding 0)
# sha256:       40ce46c956cf40e0f14bbe737be8d047e751a722047fd8d6651f0dba0c50818d
# evidence:     ev_c532ca6fd2b24db6f7392da771f9de1073079eaf8a4051621b7fba1333cc82be
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m448254_lifted
# naming:       native port src/original_methods_fl40.c:m448254_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 9 seeds; oracle 68/68 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       6 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14, local_18
# fields:       [eax + n] field_4, field_8, field_c, field_1e; [ecx + n] field_4, field_8, field_c, field_2b; [edx + n] field_ac
# callees:      calls FUN_004899ca
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m448254_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 68 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_2b, 0x2b  # offset +0x2b
.equ field_ac, 0xac  # offset +0xac

# --- external targets -----------------------------------------------
.set FUN_004899ca, .text + (0x004899ca - 0x401000)

.org 0x00448254 - 0x401000
.globl FUN_00448254
FUN_00448254:
    # block 0x00448254: entry, 7 instruction(s), ends with je to 0x0044834e (forward)
    push ebp                                     # 00448254
    {load} mov ebp, esp                          # 00448255
    sub esp, 0x18                                # 00448257
    mov dword ptr [ebp - local_18], ecx          # 0044825a
    mov eax, dword ptr [ebp - local_18]          # 0044825d
    cmp dword ptr [eax + field_1e], 0x0          # 00448260
    je.d32 L_0044834e                            # 00448264
    # block 0x0044826a: entered by fall-through of je at 0x00448264, 15 instruction(s), ends with forward jump to 0x004482b2
    movsx ecx, word ptr [ebp + arg_8]            # 0044826a
    imul ecx, ecx, 0x8d                          # 0044826e
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00448274
    mov dword ptr [ebp - local_c], edx           # 0044827a
    mov eax, dword ptr [ebp - local_c]           # 0044827d
    add eax, 0x2                                 # 00448280
    mov dword ptr [ebp - local_8], eax           # 00448283
    mov ecx, dword ptr [ebp - local_8]           # 00448286
    mov dword ptr [ebp - local_4], ecx           # 00448289
    mov edx, dword ptr [ebp - local_c]           # 0044828c
    movsx eax, word ptr [edx]                    # 0044828f
    mov cx, word ptr [2*eax + 0x58c9de]          # 00448292
    mov word ptr [ebp - local_14], cx            # 0044829a
    mov word ptr [ebp - local_10], 0x0           # 0044829e
    jmp.d8 L_004482b2                            # 004482a4
L_004482a6:
    # block 0x004482a6: entered by jmp at 0x004482f7, 3 instruction(s), falls into the block at 0x004482b2
    mov dx, word ptr [ebp - local_10]            # 004482a6
    add dx, 0x1                                  # 004482aa
    mov word ptr [ebp - local_10], dx            # 004482ae
L_004482b2:
    # block 0x004482b2: entered by jmp at 0x004482a4, 5 instruction(s), ends with jge to 0x004482f9 (forward)
    movsx eax, word ptr [ebp - local_10]         # 004482b2
    mov ecx, dword ptr [ebp - local_4]           # 004482b6
    movsx edx, word ptr [ecx + field_2b]         # 004482b9
    {load} cmp eax, edx                          # 004482bd
    jge.d8 L_004482f9                            # 004482bf
    # block 0x004482c1: entered by fall-through of jge at 0x004482bf, 17 instruction(s), ends with backward jump to 0x004482a6
    movsx eax, word ptr [ebp - local_14]         # 004482c1
    sub eax, 0x1                                 # 004482c5
    shl eax, 0x4                                 # 004482c8
    add eax, 0x591850                            # 004482cb
    movsx ecx, word ptr [ebp - local_10]         # 004482d0
    shl ecx, 0x4                                 # 004482d4
    mov edx, dword ptr [ebp - local_8]           # 004482d7
    lea ecx, [edx + ecx + field_ac]              # 004482da
    mov edx, dword ptr [eax]                     # 004482e1
    mov dword ptr [ecx], edx                     # 004482e3
    mov edx, dword ptr [eax + field_4]           # 004482e5
    mov dword ptr [ecx + field_4], edx           # 004482e8
    mov edx, dword ptr [eax + field_8]           # 004482eb
    mov dword ptr [ecx + field_8], edx           # 004482ee
    mov eax, dword ptr [eax + field_c]           # 004482f1
    mov dword ptr [ecx + field_c], eax           # 004482f4
    jmp.d8 L_004482a6                            # 004482f7
L_004482f9:
    # block 0x004482f9: entered by jge at 0x004482bf, 18 instruction(s), calls FUN_004899ca, falls into the block at 0x0044834e
    movsx ecx, word ptr [ebp + arg_8]            # 004482f9
    imul ecx, ecx, 0x8d                          # 004482fd
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00448303
    add edx, 0x2                                 # 00448309
    movsx eax, word ptr [ebp + arg_8]            # 0044830c
    imul eax, eax, 0x8d                          # 00448310
    mov dword ptr [eax + 0x5bb5e5], edx          # 00448316
    mov cx, word ptr [ebp + arg_8]               # 0044831c
    push ecx                                     # 00448320
    mov ecx, 0x619935                            # 00448321
    call FUN_004899ca                            # 00448326
    movsx edx, word ptr [ebp + arg_8]            # 0044832b
    imul edx, edx, 0x8d                          # 0044832f
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00448335
    sub eax, 0x2                                 # 0044833b
    movsx ecx, word ptr [ebp + arg_8]            # 0044833e
    imul ecx, ecx, 0x8d                          # 00448342
    mov dword ptr [ecx + 0x5bb5e5], eax          # 00448348
L_0044834e:
    # block 0x0044834e: entered by je at 0x00448264, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 0044834e
    pop ebp                                      # 00448350
    ret 0x4                                      # 00448351

