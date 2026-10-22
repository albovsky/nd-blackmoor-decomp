# FUN_004d920c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d920c
# extent:       0x004d920c-0x004d9302 (246 code bytes)
# span:         0x004d920c-0x004d9302 (code 246, tables 0, padding 0)
# sha256:       30755483bae1035a816e39ba85b6421c76fc35068545b42d547182bb8fc0770d
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d920c_lifted
# naming:       native port src/original_methods_fl39d.c:m4d920c_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (14 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_98ac; [ecx + n] field_98ac; [edx + n] field_98ac
# callees:      calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, FUN_0042639d, FUN_004c97b4, FUN_0050e493, FUN_0050cee4
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d920c_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 67 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050e493, .text + (0x0050e493 - 0x401000)

.org 0x004d920c - 0x401000
.globl FUN_004d920c
FUN_004d920c:
    # block 0x004d920c: entry, 33 instruction(s), calls FUN_0050ca3e, FUN_0050cd72, FUN_0050d0a9, ends with jne to 0x004d92a4 (forward)
    push ebp                                     # 004d920c
    {load} mov ebp, esp                          # 004d920d
    push ecx                                     # 004d920f
    mov dword ptr [ebp - local_4], ecx           # 004d9210
    mov eax, dword ptr [ebp - local_4]           # 004d9213
    add eax, 0x2af                               # 004d9216
    push eax                                     # 004d921b
    push 0x55a9c8                                # 004d921c
    mov ecx, dword ptr [ebp - local_4]           # 004d9221
    add ecx, 0x333e3                             # 004d9224
    push ecx                                     # 004d922a
    call FUN_0050ca3e                            # 004d922b
    add esp, 0xc                                 # 004d9230
    mov edx, dword ptr [ebp - local_4]           # 004d9233
    add edx, 0x333e3                             # 004d9236
    push edx                                     # 004d923c
    mov eax, dword ptr [ebp - local_4]           # 004d923d
    add eax, 0x2a5                               # 004d9240
    push eax                                     # 004d9245
    push 0x63a3c9                                # 004d9246
    push 0x63a9bc                                # 004d924b
    push 0x63888b                                # 004d9250
    call FUN_0050cd72                            # 004d9255
    add esp, 0x14                                # 004d925a
    push 0x55a9cc                                # 004d925d
    push 0x63888b                                # 004d9262
    call FUN_0050d0a9                            # 004d9267
    add esp, 0x8                                 # 004d926c
    mov ecx, dword ptr [ebp - local_4]           # 004d926f
    mov dword ptr [ecx + field_98ac], eax        # 004d9272
    mov edx, dword ptr [ebp - local_4]           # 004d9278
    cmp dword ptr [edx + field_98ac], 0x0        # 004d927b
    jne.d8 L_004d92a4                            # 004d9282
    # block 0x004d9284: entered by fall-through of jne at 0x004d9282, 7 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004d92fe
    push 0x63888b                                # 004d9284
    push 0x55a9d0                                # 004d9289
    mov ecx, 0x583979                            # 004d928e
    call FUN_0042639d                            # 004d9293
    mov ecx, 0x5cf659                            # 004d9298
    call FUN_004c97b4                            # 004d929d
    jmp.d8 L_004d92fe                            # 004d92a2
L_004d92a4:
    # block 0x004d92a4: entered by jne at 0x004d9282, 12 instruction(s), calls FUN_0050e493, ends with je to 0x004d92ec (forward)
    mov eax, dword ptr [ebp - local_4]           # 004d92a4
    mov ecx, dword ptr [eax + field_98ac]        # 004d92a7
    push ecx                                     # 004d92ad
    push 0x1                                     # 004d92ae
    push 0x905c                                  # 004d92b0
    mov edx, dword ptr [ebp - local_4]           # 004d92b5
    add edx, 0x476                               # 004d92b8
    push edx                                     # 004d92be
    call FUN_0050e493                            # 004d92bf
    add esp, 0x10                                # 004d92c4
    cmp eax, 0x1                                 # 004d92c7
    je.d8 L_004d92ec                             # 004d92ca
    # block 0x004d92cc: entered by fall-through of je at 0x004d92ca, 7 instruction(s), calls FUN_0042639d, FUN_004c97b4, ends with forward jump to 0x004d92fe
    push 0x63888b                                # 004d92cc
    push 0x55aa04                                # 004d92d1
    mov ecx, 0x583979                            # 004d92d6
    call FUN_0042639d                            # 004d92db
    mov ecx, 0x5cf659                            # 004d92e0
    call FUN_004c97b4                            # 004d92e5
    jmp.d8 L_004d92fe                            # 004d92ea
L_004d92ec:
    # block 0x004d92ec: entered by je at 0x004d92ca, 5 instruction(s), calls FUN_0050cee4, falls into the block at 0x004d92fe
    mov eax, dword ptr [ebp - local_4]           # 004d92ec
    mov ecx, dword ptr [eax + field_98ac]        # 004d92ef
    push ecx                                     # 004d92f5
    call FUN_0050cee4                            # 004d92f6
    add esp, 0x4                                 # 004d92fb
L_004d92fe:
    # block 0x004d92fe: entered by jmp at 0x004d92a2; jmp at 0x004d92ea, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d92fe
    pop ebp                                      # 004d9300
    ret                                          # 004d9301

