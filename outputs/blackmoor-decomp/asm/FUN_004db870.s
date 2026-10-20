# FUN_004db870
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db870
# extent:       0x004db870-0x004db993 (291 code bytes)
# span:         0x004db870-0x004db993 (code 291, tables 0, padding 0)
# sha256:       3f6aa40fbd6dc3eb235e07eb563ccee747b9ca2a3712bb639f52113bc1a18adc
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4db870_load_cursor
# naming:       native port src/original_methods_fl31c.c:m4db870_load_cursor (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4dae88 and 0x4daeb5 (returns the local pair or an address), copies the pair into the object and the globals around 0x583102..0x58310e with the word table at 0x5b3790; 73/73 instructions, 2/2 jump directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_8, local_c
# fields:       [eax + n] field_4, field_14, field_18; [ecx + n] field_14, field_18, field_2c, field_30; [edx + n] field_14, field_18, field_1c, field_20, field_24, field_28, field_minus_1
# callees:      calls FUN_004dae88, FUN_004daeb5
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31c.c:m4db870_load_cursor (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 73 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_4, 0x4  # offset +0x4
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_28, 0x28  # offset +0x28
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30

# --- external targets -----------------------------------------------
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004daeb5, .text + (0x004daeb5 - 0x401000)

.org 0x004db870 - 0x401000
.globl FUN_004db870
FUN_004db870:
    # block 0x004db870: entry, 11 instruction(s), calls FUN_004dae88, ends with jne to 0x004db8ab (forward)
    push ebp                                     # 004db870
    {load} mov ebp, esp                          # 004db871
    sub esp, 0xc                                 # 004db873
    mov dword ptr [ebp - local_c], ecx           # 004db876
    push 0x0                                     # 004db879
    push 0x0                                     # 004db87b
    mov ecx, 0x5830a6                            # 004db87d
    call FUN_004dae88                            # 004db882
    movsx eax, word ptr [0x583a29]               # 004db887
    cmp eax, -0x1                                # 004db88e
    jne.d8 L_004db8ab                            # 004db891
    # block 0x004db893: entered by fall-through of jne at 0x004db891, 4 instruction(s), ends with forward jump to 0x004db8c5
    mov dword ptr [0x5b44f0], 0x0                # 004db893
    mov ecx, dword ptr [0x5d0377]                # 004db89d
    mov dword ptr [0x5d162d], ecx                # 004db8a3
    jmp.d8 L_004db8c5                            # 004db8a9
L_004db8ab:
    # block 0x004db8ab: entered by jne at 0x004db891, 5 instruction(s), falls into the block at 0x004db8c5
    movsx edx, word ptr [0x583a29]               # 004db8ab
    add edx, 0x25                                # 004db8b2
    mov dword ptr [0x5b44f0], edx                # 004db8b5
    mov eax, dword ptr [0x571ad3]                # 004db8bb
    mov dword ptr [0x5d162d], eax                # 004db8c0
L_004db8c5:
    # block 0x004db8c5: entered by jmp at 0x004db8a9, 53 instruction(s), calls FUN_004daeb5, ends with ret
    mov dword ptr [0x5b44f4], 0x0                # 004db8c5
    lea ecx, [ebp - local_8]                     # 004db8cf
    push ecx                                     # 004db8d2
    mov ecx, 0x5830a6                            # 004db8d3
    call FUN_004daeb5                            # 004db8d8
    mov edx, dword ptr [eax]                     # 004db8dd
    mov eax, dword ptr [eax + field_4]           # 004db8df
    mov ecx, dword ptr [ebp - local_c]           # 004db8e2
    mov dword ptr [ecx + field_14], edx          # 004db8e5
    mov dword ptr [ecx + field_18], eax          # 004db8e8
    mov edx, dword ptr [ebp - local_c]           # 004db8eb
    mov eax, dword ptr [edx + field_14]          # 004db8ee
    mov ecx, dword ptr [edx + field_18]          # 004db8f1
    mov edx, dword ptr [ebp - local_c]           # 004db8f4
    mov dword ptr [edx + field_1c], eax          # 004db8f7
    mov dword ptr [edx + field_20], ecx          # 004db8fa
    mov eax, dword ptr [ebp - local_c]           # 004db8fd
    mov ecx, dword ptr [eax + field_18]          # 004db900
    mov dword ptr [0x583106], ecx                # 004db903
    mov edx, dword ptr [ebp - local_c]           # 004db909
    mov eax, dword ptr [0x583106]                # 004db90c
    mov dword ptr [edx + field_28], eax          # 004db911
    mov ecx, dword ptr [0x5b44f4]                # 004db914
    shl ecx, 0x2                                 # 004db91a
    mov edx, dword ptr [0x5b44f0]                # 004db91d
    movsx eax, word ptr [ecx + 8*edx + 0x5b3792] # 004db923
    mov ecx, dword ptr [ebp - local_c]           # 004db92b
    mov edx, dword ptr [ecx + field_18]          # 004db92e
    lea eax, [edx + eax - field_minus_1]         # 004db931
    mov dword ptr [0x58310e], eax                # 004db935
    mov ecx, dword ptr [ebp - local_c]           # 004db93a
    mov edx, dword ptr [0x58310e]                # 004db93d
    mov dword ptr [ecx + field_30], edx          # 004db943
    mov eax, dword ptr [ebp - local_c]           # 004db946
    mov ecx, dword ptr [eax + field_14]          # 004db949
    mov dword ptr [0x583102], ecx                # 004db94c
    mov edx, dword ptr [ebp - local_c]           # 004db952
    mov eax, dword ptr [0x583102]                # 004db955
    mov dword ptr [edx + field_24], eax          # 004db95a
    mov ecx, dword ptr [0x5b44f4]                # 004db95d
    shl ecx, 0x2                                 # 004db963
    mov edx, dword ptr [0x5b44f0]                # 004db966
    movsx eax, word ptr [ecx + 8*edx + 0x5b3790] # 004db96c
    mov ecx, dword ptr [ebp - local_c]           # 004db974
    mov edx, dword ptr [ecx + field_14]          # 004db977
    lea eax, [edx + eax - field_minus_1]         # 004db97a
    mov dword ptr [0x58310a], eax                # 004db97e
    mov ecx, dword ptr [ebp - local_c]           # 004db983
    mov edx, dword ptr [0x58310a]                # 004db986
    mov dword ptr [ecx + field_2c], edx          # 004db98c
    {load} mov esp, ebp                          # 004db98f
    pop ebp                                      # 004db991
    ret                                          # 004db992

