# FUN_0046458e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046458e
# extent:       0x0046458e-0x0046465d (207 code bytes)
# span:         0x0046458e-0x0046465d (code 207, tables 0, padding 0)
# sha256:       a18ec7db4743187a10675fbf7aebb9dd2cf3b0d9fc7253696218613d766241e8
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046458e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4a, field_4e, field_52, field_56; [ecx + n] field_d2, field_d4; [edx + n] field_4a, field_4e, field_52, field_56
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 63 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_d2, 0xd2  # offset +0xd2
.equ field_d4, 0xd4  # offset +0xd4

# --- external targets -----------------------------------------------

.org 0x0046458e - 0x401000
.globl FUN_0046458e
FUN_0046458e:
    # block 0x0046458e: entry, 8 instruction(s), ends with jge to 0x004645c6 (forward)
    push ebp                                     # 0046458e
    {load} mov ebp, esp                          # 0046458f
    push ecx                                     # 00464591
    mov dword ptr [ebp - local_4], ecx           # 00464592
    mov eax, dword ptr [ebp - local_4]           # 00464595
    mov ecx, dword ptr [eax + field_4e]          # 00464598
    cmp ecx, dword ptr [0x58319a]                # 0046459b
    jge.d8 L_004645c6                            # 004645a1
    # block 0x004645a3: entered by fall-through of jge at 0x004645a1, 10 instruction(s), falls into the block at 0x004645c6
    mov edx, dword ptr [ebp - local_4]           # 004645a3
    mov eax, dword ptr [0x58319a]                # 004645a6
    mov dword ptr [edx + field_4e], eax          # 004645ab
    mov ecx, dword ptr [ebp - local_4]           # 004645ae
    movsx edx, word ptr [ecx + field_d4]         # 004645b1
    mov eax, dword ptr [ebp - local_4]           # 004645b8
    mov ecx, dword ptr [eax + field_4e]          # 004645bb
    {load} add ecx, edx                          # 004645be
    mov edx, dword ptr [ebp - local_4]           # 004645c0
    mov dword ptr [edx + field_56], ecx          # 004645c3
L_004645c6:
    # block 0x004645c6: entered by jge at 0x004645a1, 4 instruction(s), ends with jle to 0x004645f7 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004645c6
    mov ecx, dword ptr [eax + field_56]          # 004645c9
    cmp ecx, dword ptr [0x5831a2]                # 004645cc
    jle.d8 L_004645f7                            # 004645d2
    # block 0x004645d4: entered by fall-through of jle at 0x004645d2, 10 instruction(s), falls into the block at 0x004645f7
    mov edx, dword ptr [ebp - local_4]           # 004645d4
    mov eax, dword ptr [0x5831a2]                # 004645d7
    mov dword ptr [edx + field_56], eax          # 004645dc
    mov ecx, dword ptr [ebp - local_4]           # 004645df
    movsx edx, word ptr [ecx + field_d4]         # 004645e2
    mov eax, dword ptr [ebp - local_4]           # 004645e9
    mov ecx, dword ptr [eax + field_56]          # 004645ec
    {load} sub ecx, edx                          # 004645ef
    mov edx, dword ptr [ebp - local_4]           # 004645f1
    mov dword ptr [edx + field_4e], ecx          # 004645f4
L_004645f7:
    # block 0x004645f7: entered by jle at 0x004645d2, 4 instruction(s), ends with jge to 0x00464628 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004645f7
    mov ecx, dword ptr [eax + field_4a]          # 004645fa
    cmp ecx, dword ptr [0x583196]                # 004645fd
    jge.d8 L_00464628                            # 00464603
    # block 0x00464605: entered by fall-through of jge at 0x00464603, 10 instruction(s), falls into the block at 0x00464628
    mov edx, dword ptr [ebp - local_4]           # 00464605
    mov eax, dword ptr [0x583196]                # 00464608
    mov dword ptr [edx + field_4a], eax          # 0046460d
    mov ecx, dword ptr [ebp - local_4]           # 00464610
    movsx edx, word ptr [ecx + field_d2]         # 00464613
    mov eax, dword ptr [ebp - local_4]           # 0046461a
    mov ecx, dword ptr [eax + field_4a]          # 0046461d
    {load} add ecx, edx                          # 00464620
    mov edx, dword ptr [ebp - local_4]           # 00464622
    mov dword ptr [edx + field_52], ecx          # 00464625
L_00464628:
    # block 0x00464628: entered by jge at 0x00464603, 4 instruction(s), ends with jle to 0x00464659 (forward)
    mov eax, dword ptr [ebp - local_4]           # 00464628
    mov ecx, dword ptr [eax + field_52]          # 0046462b
    cmp ecx, dword ptr [0x58319e]                # 0046462e
    jle.d8 L_00464659                            # 00464634
    # block 0x00464636: entered by fall-through of jle at 0x00464634, 10 instruction(s), falls into the block at 0x00464659
    mov edx, dword ptr [ebp - local_4]           # 00464636
    mov eax, dword ptr [0x58319e]                # 00464639
    mov dword ptr [edx + field_52], eax          # 0046463e
    mov ecx, dword ptr [ebp - local_4]           # 00464641
    movsx edx, word ptr [ecx + field_d2]         # 00464644
    mov eax, dword ptr [ebp - local_4]           # 0046464b
    mov ecx, dword ptr [eax + field_52]          # 0046464e
    {load} sub ecx, edx                          # 00464651
    mov edx, dword ptr [ebp - local_4]           # 00464653
    mov dword ptr [edx + field_4a], ecx          # 00464656
L_00464659:
    # block 0x00464659: entered by jle at 0x00464634, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00464659
    pop ebp                                      # 0046465b
    ret                                          # 0046465c

