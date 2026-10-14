# FUN_004daf3f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004daf3f
# extent:       0x004daf3f-0x004daf6e (47 code bytes)
# span:         0x004daf3f-0x004daf6e (code 47, tables 0, padding 0)
# sha256:       d14f2737a806fb01ffd15002d2d0d291d9bff0f9c77849a4524bc55567db6fcc
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# name:         InputObject::consume_latch_0
# arguments:    thiscall: ecx=this; no stack arguments; plain ret; returns eax=1 if the dword at this+0 was non-zero (and it was consumed), else eax=0
# locals:       [ebp-local_this] = this, spilled from ecx (push ecx reserves the slot, mov overwrites it with ecx)
# fields:       this+0x00: dword read, compared with 0 (any non-zero value counts as set), cleared to 0 when set; this+0x0c: dword cleared to 0 when this+0 was set (store order: +0 first, then +0x0c); no globals touched
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/input_consume.c:input_consume_field0
# unverified:   The receiver's identity (the input object at 0x5830a6 per tasks/S08-3 and S08-4) comes from those packets and the MFC wrappers' ECX setup, not from a caller trace redone here; semantic names of the fields are Track N's labels (input_latch.c / input_consume.c), not proven by these bytes. Whether +0x0c is read anywhere before it is cleared is not part of this routine (it only stores). Callers (reported by tasks/S08-4: 0x43b199) and what the return value means to them are not re-verified here. Field symbol names are descriptive labels chosen from src/input_latch.c and src/input_consume.c offsets (and the neighbouring routines); they assert only the verified displacement, not the field's game meaning.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_this, 0x4  # [ebp - 0x4]

.equ input_state_0c, 0xc  # InputObject+0x0c: latch state dword (INPUT_LATCH_FIELD_0C)

# --- external targets -----------------------------------------------

.org 0x004daf3f - 0x401000
.globl FUN_004daf3f
FUN_004daf3f:
    # block 0x004daf3f: entry: spill this, load dword [this+0]; if it is zero jump to L_not_set_return_0 (je)
    push ebp                                     # 004daf3f
    {load} mov ebp, esp                          # 004daf40
    push ecx                                     # 004daf42
    mov dword ptr [ebp - local_this], ecx           # 004daf43
    mov eax, dword ptr [ebp - local_this]           # 004daf46
    cmp dword ptr [eax], 0x0                     # 004daf49
    je.d8 L_not_set_return_0                             # 004daf4c
    # block 0x004daf4e: latch set (dword [this+0] != 0): store 0 to [this+0], then 0 to [this+0x0c], eax=1, jump to the epilogue
    mov ecx, dword ptr [ebp - local_this]           # 004daf4e
    mov dword ptr [ecx], 0x0                     # 004daf51
    mov edx, dword ptr [ebp - local_this]           # 004daf57
    mov dword ptr [edx + input_state_0c], 0x0               # 004daf5a
    mov eax, 0x1                                 # 004daf61
    jmp.d8 L_epilogue                            # 004daf66
L_not_set_return_0:
    # block 0x004daf68: latch not set: eax = 0 (xor eax,eax)
    {load} xor eax, eax                          # 004daf68
L_epilogue:
    # block 0x004daf6a: shared epilogue: restore the frame and return with a plain ret (eax = 1 or 0)
    {load} mov esp, ebp                          # 004daf6a
    pop ebp                                      # 004daf6c
    ret                                          # 004daf6d
