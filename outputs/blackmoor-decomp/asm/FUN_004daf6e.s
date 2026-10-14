# FUN_004daf6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf6e
# extent:       0x004daf6e-0x004daf9f (49 code bytes)
# span:         0x004daf6e-0x004daf9f (code 49, tables 0, padding 0)
# sha256:       c9d366738b9dd578e5b9ba5ea0e3c507ef84d16e5bcb7f2838bc71082ebead67
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         InputObject::consume_latch_4
# arguments:    thiscall: ecx=this; no stack arguments; plain ret; returns eax=1 if the dword at this+4 was non-zero (and it was consumed), else eax=0
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x04: dword read, compared with 0 (any non-zero value counts as set), cleared to 0 when set; this+0x10: dword cleared to 0 when this+4 was set (store order: +4 first, then +0x10); no globals touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/input_consume.c:input_consume_field4
# unverified:   The receiver's identity (the input object at 0x5830a6 per tasks/S08-3 and S08-4) comes from those packets and the MFC wrappers' ECX setup, not from a caller trace redone here; semantic names of the fields are Track N's labels (input_latch.c / input_consume.c), not proven by these bytes. Callers (tasks/S08-4 reports 0x43c0d6) and what the return value means to them are not re-verified here.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]

.equ field_4, 0x4  # offset
.equ field_10, 0x10  # offset

# --- external targets -----------------------------------------------

.org 0x004daf6e - 0x401000
.globl FUN_004daf6e
FUN_004daf6e:
    # block 0x004daf6e: entry: spill this, load dword [this+4]; if it is zero jump to L_not_set_return_0 (je)
    push ebp                                     # 004daf6e
    {load} mov ebp, esp                          # 004daf6f
    push ecx                                     # 004daf71
    mov dword ptr [ebp - local_this], ecx           # 004daf72
    mov eax, dword ptr [ebp - local_this]           # 004daf75
    cmp dword ptr [eax + field_4], 0x0               # 004daf78
    je.d8 L_not_set_return_0                             # 004daf7c
    # block 0x004daf7e: latch set (dword [this+4] != 0): store 0 to [this+4], then 0 to [this+0x10], eax=1, jump to the epilogue
    mov ecx, dword ptr [ebp - local_this]           # 004daf7e
    mov dword ptr [ecx + field_4], 0x0               # 004daf81
    mov edx, dword ptr [ebp - local_this]           # 004daf88
    mov dword ptr [edx + field_10], 0x0              # 004daf8b
    mov eax, 0x1                                 # 004daf92
    jmp.d8 L_epilogue                            # 004daf97
L_not_set_return_0:
    # block 0x004daf99: latch not set: eax = 0 (xor eax,eax)
    {load} xor eax, eax                          # 004daf99
L_epilogue:
    # block 0x004daf9b: shared epilogue: restore the frame and return with a plain ret (eax = 1 or 0)
    {load} mov esp, ebp                          # 004daf9b
    pop ebp                                      # 004daf9d
    ret                                          # 004daf9e
