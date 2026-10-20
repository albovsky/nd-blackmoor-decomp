# FUN_00426063
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00426063
# extent:       0x00426063-0x00426148 (229 code bytes)
# span:         0x00426063-0x00426148 (code 229, tables 0, padding 0)
# sha256:       317680423c820cfaca070eb52e2123bd237d3fce56dbc74a0d4a891f87d5a3b8
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_boot_game_engine
# naming:       INFERRED (lower confidence, not verified): the repository text src/caption_lifecycle.h:8 says "boot 0x426063 BootGameEngine"
# name-note:    BootGameEngine: boot entry that calls init 0x4de227 and poll 0x4de4f9.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_1c
# callees:      calls FUN_0044a2b7, FUN_004faa03, FUN_004c1716, KERNEL32.dll!SetThreadPriority, FUN_004e06c0, FUN_004e0e2b, FUN_004e7700, FUN_004e7970, FUN_004de227, FUN_004de4f9, FUN_004dbfbf
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 57 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)
.set FUN_004c1716, .text + (0x004c1716 - 0x401000)
.set FUN_004dbfbf, .text + (0x004dbfbf - 0x401000)
.set FUN_004de227, .text + (0x004de227 - 0x401000)
.set FUN_004de4f9, .text + (0x004de4f9 - 0x401000)
.set FUN_004e06c0, .text + (0x004e06c0 - 0x401000)
.set FUN_004e0e2b, .text + (0x004e0e2b - 0x401000)
.set FUN_004e7700, .text + (0x004e7700 - 0x401000)
.set FUN_004e7970, .text + (0x004e7970 - 0x401000)
.set FUN_004faa03, .text + (0x004faa03 - 0x401000)

.org 0x00426063 - 0x401000
.globl FUN_00426063
FUN_00426063:
    # block 0x00426063: entry, 6 instruction(s), ends with je to 0x00426081 (forward)
    push ebp                                     # 00426063
    {load} mov ebp, esp                          # 00426064
    sub esp, 0xc                                 # 00426066
    movsx eax, word ptr [0x63a4cd]               # 00426069
    test eax, eax                                # 00426070
    je.d8 L_00426081                             # 00426072
    # block 0x00426074: entered by fall-through of je at 0x00426072, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00426081
    push 0x545358                                # 00426074
    call FUN_0044a2b7                            # 00426079
    add esp, 0x4                                 # 0042607e
L_00426081:
    # block 0x00426081: entered by je at 0x00426072, 2 instruction(s), ends with jne to 0x00426093 (forward)
    cmp dword ptr [0x5703a4], 0x0                # 00426081
    jne.d8 L_00426093                            # 00426088
    # block 0x0042608a: entered by fall-through of jne at 0x00426088, 2 instruction(s), ends with forward jump to 0x0042609f
    mov dword ptr [ebp - local_c], 0x0           # 0042608a
    jmp.d8 L_0042609f                            # 00426091
L_00426093:
    # block 0x00426093: entered by jne at 0x00426088, 3 instruction(s), falls into the block at 0x0042609f
    mov ecx, dword ptr [0x5703a4]                # 00426093
    mov edx, dword ptr [ecx + field_1c]          # 00426099
    mov dword ptr [ebp - local_c], edx           # 0042609c
L_0042609f:
    # block 0x0042609f: entered by jmp at 0x00426091, 35 instruction(s), calls FUN_004faa03, FUN_004c1716, KERNEL32.dll!SetThreadPriority, FUN_004e06c0, FUN_004e0e2b, FUN_004e7..., ends with je to 0x00426144 (forward)
    mov eax, dword ptr [ebp - local_c]           # 0042609f
    mov dword ptr [ebp - local_4], eax           # 004260a2
    mov ecx, dword ptr [ebp - local_4]           # 004260a5
    push ecx                                     # 004260a8
    mov ecx, 0x5c3a67                            # 004260a9
    call FUN_004faa03                            # 004260ae
    mov edx, dword ptr [ebp - local_4]           # 004260b3
    push edx                                     # 004260b6
    mov ecx, 0x5cf659                            # 004260b7
    call FUN_004c1716                            # 004260bc
    movsx eax, word ptr [0x5b016d]               # 004260c1
    mov dword ptr [ebp - local_8], eax           # 004260c8
    mov ecx, dword ptr [ebp - local_8]           # 004260cb
    push ecx                                     # 004260ce
    mov edx, dword ptr [0x5703b0]                # 004260cf
    push edx                                     # 004260d5
    call dword ptr [0x52a2ac]                    # 004260d6
    mov ecx, 0x570508                            # 004260dc
    call FUN_004e06c0                            # 004260e1
    mov ecx, 0x570508                            # 004260e6
    call FUN_004e0e2b                            # 004260eb
    mov ecx, 0x582711                            # 004260f0
    call FUN_004e7700                            # 004260f5
    mov ecx, 0x582711                            # 004260fa
    call FUN_004e7970                            # 004260ff
    mov ecx, 0x61f864                            # 00426104
    call FUN_004de227                            # 00426109
    mov ecx, 0x61f864                            # 0042610e
    call FUN_004de4f9                            # 00426113
    mov dword ptr [0x583981], 0x2                # 00426118
    mov ecx, 0x637e85                            # 00426122
    call FUN_004dbfbf                            # 00426127
    movsx eax, word ptr [0x63a4cd]               # 0042612c
    test eax, eax                                # 00426133
    je.d8 L_00426144                             # 00426135
    # block 0x00426137: entered by fall-through of je at 0x00426135, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x00426144
    push 0x545374                                # 00426137
    call FUN_0044a2b7                            # 0042613c
    add esp, 0x4                                 # 00426141
L_00426144:
    # block 0x00426144: entered by je at 0x00426135, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00426144
    pop ebp                                      # 00426146
    ret                                          # 00426147

