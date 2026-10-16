# FUN_004d912a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d912a
# extent:       0x004d912a-0x004d920c (226 code bytes)
# span:         0x004d912a-0x004d920c (code 226, tables 0, padding 0)
# sha256:       03ca5d665918c0373c03fe15a22f08950d97db19a76f14e2f66893880508457d
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d912a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_98ac; [ecx + n] field_98ac; [edx + n] field_98ac
# callees:      calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, FUN_0050cf61, FUN_0042639d, FUN_004c97b4, FUN_0050cee4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 64 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_98ac, 0x98ac  # offset +0x98ac

# --- external targets -----------------------------------------------
.set FUN_0042639d, .text + (0x0042639d - 0x401000)
.set FUN_004c97b4, .text + (0x004c97b4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050cf61, .text + (0x0050cf61 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)

.org 0x004d912a - 0x401000
.globl FUN_004d912a
FUN_004d912a:
    # block 0x004d912a: entry, 33 instruction(s), calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004d91a7 (forward)
    push ebp                                     # 004d912a
    {load} mov ebp, esp                          # 004d912b
    push ecx                                     # 004d912d
    mov dword ptr [ebp - local_4], ecx           # 004d912e
    mov eax, dword ptr [ebp - local_4]           # 004d9131
    add eax, 0x2af                               # 004d9134
    push eax                                     # 004d9139
    push 0x55a9a8                                # 004d913a
    mov ecx, dword ptr [ebp - local_4]           # 004d913f
    add ecx, 0x333e3                             # 004d9142
    push ecx                                     # 004d9148
    call FUN_0050ca3e                            # 004d9149
    add esp, 0xc                                 # 004d914e
    mov edx, dword ptr [ebp - local_4]           # 004d9151
    add edx, 0x333e3                             # 004d9154
    push edx                                     # 004d915a
    mov eax, dword ptr [ebp - local_4]           # 004d915b
    add eax, 0x2a5                               # 004d915e
    push eax                                     # 004d9163
    push 0x63a3c9                                # 004d9164
    push 0x63a9b8                                # 004d9169
    push 0x63888b                                # 004d916e
    call FUN_0050cd72                            # 004d9173
    add esp, 0x14                                # 004d9178
    push 0x55a9ac                                # 004d917b
    push 0x63888b                                # 004d9180
    call FUN_0050d0a9                            # 004d9185
    add esp, 0x8                                 # 004d918a
    mov ecx, dword ptr [ebp - local_4]           # 004d918d
    mov dword ptr [ecx + field_98ac], eax        # 004d9190
    mov edx, dword ptr [ebp - local_4]           # 004d9196
    cmp dword ptr [edx + field_98ac], 0x0        # 004d9199
    jne.d8 L_004d91a7                            # 004d91a0
    # block 0x004d91a2: entered by fall-through of jne at 0x004d91a0, 2 instruction(s), ends with forward jump to 0x004d9208
    {load} xor ax, ax                            # 004d91a2
    jmp.d8 L_004d9208                            # 004d91a5
L_004d91a7:
    # block 0x004d91a7: entered by jne at 0x004d91a0, 12 instruction(s), calls FUN_0050cf61, ends with je to 0x004d91f2 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d91a7
    mov ecx, dword ptr [eax + field_98ac]        # 004d91aa
    push ecx                                     # 004d91b0
    push 0x1                                     # 004d91b1
    push 0x905c                                  # 004d91b3
    mov edx, dword ptr [ebp - local_4]           # 004d91b8
    add edx, 0x476                               # 004d91bb
    push edx                                     # 004d91c1
    call FUN_0050cf61                            # 004d91c2
    add esp, 0x10                                # 004d91c7
    cmp eax, 0x1                                 # 004d91ca
    je.d8 L_004d91f2                             # 004d91cd
    # block 0x004d91cf: entered by fall-through of je at 0x004d91cd, 8 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004d9208
    push 0x63888b                                # 004d91cf
    push 0x55a9b0                                # 004d91d4
    mov ecx, 0x583979                            # 004d91d9
    call FUN_0042639d                            # 004d91de
    mov ecx, 0x5cf659                            # 004d91e3
    call FUN_004c97b4                            # 004d91e8
    {load} xor ax, ax                            # 004d91ed
    jmp.d8 L_004d9208                            # 004d91f0
L_004d91f2:
    # block 0x004d91f2: entered by je at 0x004d91cd, 6 instruction(s), calls FUN_0050cee4, falls into the block at 0x004d9208
    mov eax, dword ptr [ebp - local_4]           # 004d91f2
    mov ecx, dword ptr [eax + field_98ac]        # 004d91f5
    push ecx                                     # 004d91fb
    call FUN_0050cee4                            # 004d91fc
    add esp, 0x4                                 # 004d9201
    mov ax, 0x1                                  # 004d9204
L_004d9208:
    # block 0x004d9208: entered by jmp at 0x004d91a5; jmp at 0x004d91f0, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d9208
    pop ebp                                      # 004d920a
    ret                                          # 004d920b

