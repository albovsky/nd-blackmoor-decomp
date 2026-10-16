# FUN_0050b180
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b180
# extent:       0x0050b180-0x0050b257 (215 code bytes)
# span:         0x0050b180-0x0050b260 (code 215, tables 0, padding 9)
# sha256:       994b71bf22f62345af6e46498618f515dbbacb64490b509c5ed7a3c407b7293b
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b180
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_6, field_7, field_8, field_9, field_a, field_b, field_c, field_d; [esp + n] stk_4
# callees:      calls FUN_0050f7e0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 89 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_6, 0x6  # offset +0x6
.equ field_7, 0x7  # offset +0x7
.equ field_8, 0x8  # offset +0x8
.equ field_9, 0x9  # offset +0x9
.equ field_a, 0xa  # offset +0xa
.equ field_b, 0xb  # offset +0xb
.equ field_c, 0xc  # offset +0xc
.equ field_d, 0xd  # offset +0xd

# --- external targets -----------------------------------------------
.set FUN_0050f7e0, .text + (0x0050f7e0 - 0x401000)

.org 0x0050b180 - 0x401000
.globl FUN_0050b180
FUN_0050b180:
    # block 0x0050b180: entry, 89 instruction(s), calls FUN_0050f7e0, ends with ret
    mov eax, dword ptr [esp + stk_4]             # 0050b180
    push ebx                                     # 0050b184
    push esi                                     # 0050b185
    push edi                                     # 0050b186
    mov esi, dword ptr [eax]                     # 0050b187
    {load} xor eax, eax                          # 0050b189
    mov ecx, 0x8                                 # 0050b18b
    mov al, byte ptr [esi + field_d]             # 0050b190
    cdq                                          # 0050b193
    call FUN_0050f7e0                            # 0050b194
    {load} mov edi, eax                          # 0050b199
    {load} xor eax, eax                          # 0050b19b
    mov al, byte ptr [esi + field_c]             # 0050b19d
    {load} mov ebx, edx                          # 0050b1a0
    cdq                                          # 0050b1a2
    {load} or edi, eax                           # 0050b1a3
    {load} or ebx, edx                           # 0050b1a5
    mov ecx, 0x8                                 # 0050b1a7
    {load} mov eax, edi                          # 0050b1ac
    {load} mov edx, ebx                          # 0050b1ae
    call FUN_0050f7e0                            # 0050b1b0
    {load} mov edi, eax                          # 0050b1b5
    {load} xor eax, eax                          # 0050b1b7
    mov al, byte ptr [esi + field_b]             # 0050b1b9
    {load} mov ebx, edx                          # 0050b1bc
    cdq                                          # 0050b1be
    {load} or edi, eax                           # 0050b1bf
    {load} or ebx, edx                           # 0050b1c1
    mov ecx, 0x8                                 # 0050b1c3
    {load} mov eax, edi                          # 0050b1c8
    {load} mov edx, ebx                          # 0050b1ca
    call FUN_0050f7e0                            # 0050b1cc
    {load} mov edi, eax                          # 0050b1d1
    {load} xor eax, eax                          # 0050b1d3
    mov al, byte ptr [esi + field_a]             # 0050b1d5
    {load} mov ebx, edx                          # 0050b1d8
    cdq                                          # 0050b1da
    {load} or edi, eax                           # 0050b1db
    {load} or ebx, edx                           # 0050b1dd
    mov ecx, 0x8                                 # 0050b1df
    {load} mov eax, edi                          # 0050b1e4
    {load} mov edx, ebx                          # 0050b1e6
    call FUN_0050f7e0                            # 0050b1e8
    {load} mov edi, eax                          # 0050b1ed
    {load} xor eax, eax                          # 0050b1ef
    mov al, byte ptr [esi + field_9]             # 0050b1f1
    {load} mov ebx, edx                          # 0050b1f4
    cdq                                          # 0050b1f6
    {load} or edi, eax                           # 0050b1f7
    {load} or ebx, edx                           # 0050b1f9
    mov ecx, 0x8                                 # 0050b1fb
    {load} mov eax, edi                          # 0050b200
    {load} mov edx, ebx                          # 0050b202
    call FUN_0050f7e0                            # 0050b204
    {load} mov edi, eax                          # 0050b209
    {load} xor eax, eax                          # 0050b20b
    mov al, byte ptr [esi + field_8]             # 0050b20d
    {load} mov ebx, edx                          # 0050b210
    cdq                                          # 0050b212
    {load} or edi, eax                           # 0050b213
    {load} or ebx, edx                           # 0050b215
    mov ecx, 0x8                                 # 0050b217
    {load} mov eax, edi                          # 0050b21c
    {load} mov edx, ebx                          # 0050b21e
    call FUN_0050f7e0                            # 0050b220
    {load} mov edi, eax                          # 0050b225
    {load} xor eax, eax                          # 0050b227
    mov al, byte ptr [esi + field_7]             # 0050b229
    {load} mov ebx, edx                          # 0050b22c
    cdq                                          # 0050b22e
    {load} or edi, eax                           # 0050b22f
    {load} or ebx, edx                           # 0050b231
    mov ecx, 0x8                                 # 0050b233
    {load} mov eax, edi                          # 0050b238
    {load} mov edx, ebx                          # 0050b23a
    call FUN_0050f7e0                            # 0050b23c
    {load} mov ecx, eax                          # 0050b241
    {load} xor eax, eax                          # 0050b243
    mov al, byte ptr [esi + field_6]             # 0050b245
    {load} mov edi, edx                          # 0050b248
    cdq                                          # 0050b24a
    {load} or edi, edx                           # 0050b24b
    {load} or ecx, eax                           # 0050b24d
    {load} mov edx, edi                          # 0050b24f
    pop edi                                      # 0050b251
    pop esi                                      # 0050b252
    {load} mov eax, ecx                          # 0050b253
    pop ebx                                      # 0050b255
    ret                                          # 0050b256

# --- data items (not part of the function) -------------------------
.org 0x0050b257 - 0x401000
PAD_0050b257:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

