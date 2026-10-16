# FUN_0050b430
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b430
# extent:       0x0050b430-0x0050b45f (47 code bytes)
# span:         0x0050b430-0x0050b460 (code 47, tables 0, padding 1)
# sha256:       7e36835b6bb62072f4eebaa1c6720e38d06eaa9d25df880fffc67e6087072134
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b430
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_400; [esi + n] field_4, field_8; [esp + n] stk_8
# callees:      calls FUN_0050ebca
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_400, 0x400  # offset +0x400

# --- external targets -----------------------------------------------
.set FUN_0050ebca, .text + (0x0050ebca - 0x401000)

.org 0x0050b430 - 0x401000
.globl FUN_0050b430
FUN_0050b430:
    # block 0x0050b430: entry, 8 instruction(s), ends with jg to 0x0050b45d (forward)
    mov ecx, dword ptr [esp + stk_8]             # 0050b430
    push esi                                     # 0050b434
    mov esi, dword ptr [esp + stk_8]             # 0050b435
    mov edx, dword ptr [esi + field_8]           # 0050b439
    mov eax, dword ptr [esi + field_4]           # 0050b43c
    {load} add edx, ecx                          # 0050b43f
    {load} cmp eax, edx                          # 0050b441
    jg.d8 L_0050b45d                             # 0050b443
    # block 0x0050b445: entered by fall-through of jg at 0x0050b443, 8 instruction(s), calls FUN_0050ebca, falls into the block at 0x0050b45d
    lea eax, [eax + ecx + field_400]             # 0050b445
    mov dword ptr [esi + field_4], eax           # 0050b44c
    push eax                                     # 0050b44f
    mov eax, dword ptr [esi]                     # 0050b450
    push eax                                     # 0050b452
    call FUN_0050ebca                            # 0050b453
    add esp, 0x8                                 # 0050b458
    mov dword ptr [esi], eax                     # 0050b45b
L_0050b45d:
    # block 0x0050b45d: entered by jg at 0x0050b443, 2 instruction(s), ends with ret
    pop esi                                      # 0050b45d
    ret                                          # 0050b45e

# --- data items (not part of the function) -------------------------
.org 0x0050b45f - 0x401000
PAD_0050b45f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

