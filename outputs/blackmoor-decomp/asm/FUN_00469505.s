# FUN_00469505
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00469505
# extent:       0x00469505-0x0046957d (120 code bytes)
# span:         0x00469505-0x0046957d (code 120, tables 0, padding 0)
# sha256:       dd01acd6ab182058ec349a6d7b7742e535803532888d2a907bdb51c868453a2a
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00469505
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_7e, field_5d7; [ecx + n] field_7e; [edx + n] field_7e, field_5d5
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_7e, 0x7e  # offset +0x7e
.equ field_5d5, 0x5d5  # offset +0x5d5
.equ field_5d7, 0x5d7  # offset +0x5d7

# --- external targets -----------------------------------------------

.org 0x00469505 - 0x401000
.globl FUN_00469505
FUN_00469505:
    # block 0x00469505: entry, 6 instruction(s), ends with je to 0x00469579 (forward)
    push ebp                                     # 00469505
    {load} mov ebp, esp                          # 00469506
    push ecx                                     # 00469508
    mov dword ptr [ebp - local_4], ecx           # 00469509
    cmp dword ptr [0x5919f4], 0x0                # 0046950c
    je.d8 L_00469579                             # 00469513
    # block 0x00469515: entered by fall-through of je at 0x00469513, 2 instruction(s), ends with je to 0x00469579 (forward)
    cmp dword ptr [0x5919f8], 0x0                # 00469515
    je.d8 L_00469579                             # 0046951c
    # block 0x0046951e: entered by fall-through of je at 0x0046951c, 7 instruction(s), ends with je to 0x00469579 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0046951e
    movsx ecx, word ptr [eax + field_7e]         # 00469521
    imul ecx, ecx, 0x8d                          # 00469525
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 0046952b
    movsx eax, word ptr [edx + field_5d5]        # 00469531
    cmp eax, -0x1                                # 00469538
    je.d8 L_00469579                             # 0046953b
    # block 0x0046953d: entered by fall-through of je at 0x0046953b, 12 instruction(s), falls into the block at 0x00469579
    mov ecx, dword ptr [ebp - local_4]           # 0046953d
    movsx edx, word ptr [ecx + field_7e]         # 00469540
    imul edx, edx, 0x8d                          # 00469544
    mov eax, dword ptr [edx + 0x5bb5e5]          # 0046954a
    {load} xor ecx, ecx                          # 00469550
    mov cl, byte ptr [eax + field_5d7]           # 00469552
    mov edx, dword ptr [ebp - local_4]           # 00469558
    movsx eax, word ptr [edx + field_7e]         # 0046955b
    imul eax, eax, 0x8d                          # 0046955f
    mov edx, dword ptr [eax + 0x5bb5e5]          # 00469565
    movsx eax, word ptr [edx + field_5d5]        # 0046956b
    mov dword ptr [4*eax + 0x585801], ecx        # 00469572
L_00469579:
    # block 0x00469579: entered by je at 0x00469513; je at 0x0046951c; je at 0x0046953b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00469579
    pop ebp                                      # 0046957b
    ret                                          # 0046957c

