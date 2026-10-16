# FUN_004dfdc9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dfdc9
# extent:       0x004dfdc9-0x004dfed2 (265 code bytes)
# span:         0x004dfdc9-0x004dfed2 (code 265, tables 0, padding 0)
# sha256:       7a6f6fdcb40fff01a6934576240ec7e421ab813d5db029fc6498703530c98185
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dfdc9
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0043dbd5, FUN_004db870, FUN_004dfed2, FUN_004c9b25, FUN_0050ce04, FUN_004fcd4d, FUN_004fcd69, FUN_004fcd85, FUN_004de6fc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 52 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004c9b25, .text + (0x004c9b25 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)
.set FUN_004de6fc, .text + (0x004de6fc - 0x401000)
.set FUN_004dfed2, .text + (0x004dfed2 - 0x401000)
.set FUN_004fcd4d, .text + (0x004fcd4d - 0x401000)
.set FUN_004fcd69, .text + (0x004fcd69 - 0x401000)
.set FUN_004fcd85, .text + (0x004fcd85 - 0x401000)
.set FUN_0050ce04, .text + (0x0050ce04 - 0x401000)

.org 0x004dfdc9 - 0x401000
.globl FUN_004dfdc9
FUN_004dfdc9:
    # block 0x004dfdc9: entry, 9 instruction(s), calls FUN_0043dbd5, ends with jne to 0x004dfdf4 (forward)
    push ebp                                     # 004dfdc9
    {load} mov ebp, esp                          # 004dfdca
    push ecx                                     # 004dfdcc
    mov dword ptr [ebp - local_4], ecx           # 004dfdcd
    mov eax, dword ptr [0x583985]                # 004dfdd0
    mov dword ptr [0x583981], eax                # 004dfdd5
    call FUN_0043dbd5                            # 004dfdda
    cmp dword ptr [0x583985], 0x6                # 004dfddf
    jne.d8 L_004dfdf4                            # 004dfde6
    # block 0x004dfde8: entered by fall-through of jne at 0x004dfde6, 2 instruction(s), ends with forward jump to 0x004dfe07
    mov dword ptr [0x5839a1], 0x0                # 004dfde8
    jmp.d8 L_004dfe07                            # 004dfdf2
L_004dfdf4:
    # block 0x004dfdf4: entered by jne at 0x004dfde6, 2 instruction(s), ends with jne to 0x004dfe07 (forward)
    cmp dword ptr [0x583985], 0xe                # 004dfdf4
    jne.d8 L_004dfe07                            # 004dfdfb
    # block 0x004dfdfd: entered by fall-through of jne at 0x004dfdfb, 2 instruction(s), calls FUN_004db870, falls into the block at 0x004dfe07
    mov ecx, 0x5830ce                            # 004dfdfd
    call FUN_004db870                            # 004dfe02
L_004dfe07:
    # block 0x004dfe07: entered by jmp at 0x004dfdf2; jne at 0x004dfdfb, 12 instruction(s), calls FUN_004dfed2, ends with je to 0x004dfe72 (forward)
    mov dword ptr [0x583985], 0x8                # 004dfe07
    mov dword ptr [0x5d2825], 0x0                # 004dfe11
    mov dword ptr [0x5d286f], 0x0                # 004dfe1b
    mov dword ptr [0x5d28b9], 0x0                # 004dfe25
    mov dword ptr [0x5d2903], 0x0                # 004dfe2f
    mov dword ptr [0x5d294d], 0x0                # 004dfe39
    mov dword ptr [0x5d2997], 0x0                # 004dfe43
    mov dword ptr [0x5d29e1], 0x1                # 004dfe4d
    mov ecx, dword ptr [ebp - local_4]           # 004dfe57
    call FUN_004dfed2                            # 004dfe5a
    cmp dword ptr [0x5d02ab], 0x0                # 004dfe5f
    je.d8 L_004dfe72                             # 004dfe66
    # block 0x004dfe68: entered by fall-through of je at 0x004dfe66, 2 instruction(s), calls FUN_004c9b25, falls into the block at 0x004dfe72
    mov ecx, 0x5cf659                            # 004dfe68
    call FUN_004c9b25                            # 004dfe6d
L_004dfe72:
    # block 0x004dfe72: entered by je at 0x004dfe66, 23 instruction(s), calls FUN_0050ce04, FUN_004fcd4d, FUN_004fcd69, FUN_004fcd85, FUN_004de6fc, ends with ret
    fld dword ptr [0x5cf1cb]                     # 004dfe72
    fmul dword ptr [0x52cbec]                    # 004dfe78
    call FUN_0050ce04                            # 004dfe7e
    push eax                                     # 004dfe83
    mov ecx, 0x5c3a67                            # 004dfe84
    call FUN_004fcd4d                            # 004dfe89
    fld dword ptr [0x5cf1cf]                     # 004dfe8e
    fmul dword ptr [0x52cbec]                    # 004dfe94
    call FUN_0050ce04                            # 004dfe9a
    push eax                                     # 004dfe9f
    mov ecx, 0x5c3a67                            # 004dfea0
    call FUN_004fcd69                            # 004dfea5
    fld dword ptr [0x5cf1d3]                     # 004dfeaa
    fmul dword ptr [0x52cbec]                    # 004dfeb0
    call FUN_0050ce04                            # 004dfeb6
    push eax                                     # 004dfebb
    mov ecx, 0x5c3a67                            # 004dfebc
    call FUN_004fcd85                            # 004dfec1
    mov ecx, dword ptr [ebp - local_4]           # 004dfec6
    call FUN_004de6fc                            # 004dfec9
    {load} mov esp, ebp                          # 004dfece
    pop ebp                                      # 004dfed0
    ret                                          # 004dfed1

