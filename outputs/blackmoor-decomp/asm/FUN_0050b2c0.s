# FUN_0050b2c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b2c0
# extent:       0x0050b2c0-0x0050b324 (100 code bytes)
# span:         0x0050b2c0-0x0050b330 (code 100, tables 0, padding 12)
# sha256:       02dd63005eaf813300d0de83ca646597fe55df3873f8ac3b61cef3329ba2d3d7
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b2c0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_10, field_14, field_18, field_14e; [esp + n] stk_8, stk_1c
# callees:      calls FUN_0050ea90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ stk_1c, 0x1c  # offset +0x1c
.equ field_14e, 0x14e  # offset +0x14e

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x0050b2c0 - 0x401000
.globl FUN_0050b2c0
FUN_0050b2c0:
    # block 0x0050b2c0: entry, 4 instruction(s), ends with je to 0x0050b31f (forward)
    push esi                                     # 0050b2c0
    mov esi, dword ptr [esp + stk_8]             # 0050b2c1
    test esi, esi                                # 0050b2c5
    je.d8 L_0050b31f                             # 0050b2c7
    # block 0x0050b2c9: entered by fall-through of je at 0x0050b2c7, 26 instruction(s), calls FUN_0050ea90, ends with ret
    push edi                                     # 0050b2c9
    mov ecx, 0x59                                # 0050b2ca
    {load} xor eax, eax                          # 0050b2cf
    {load} mov edi, esi                          # 0050b2d1
    rep stosd dword ptr es:[edi], eax            # 0050b2d3
    stosw word ptr es:[edi], ax                  # 0050b2d5
    push 0x4000                                  # 0050b2d7
    mov dword ptr [esi + field_4], 0x4000        # 0050b2dc
    call FUN_0050ea90                            # 0050b2e3
    push 0x1000                                  # 0050b2e8
    mov dword ptr [esi], eax                     # 0050b2ed
    mov dword ptr [esi + field_18], 0x400        # 0050b2ef
    call FUN_0050ea90                            # 0050b2f6
    mov dword ptr [esi + field_10], eax          # 0050b2fb
    mov eax, dword ptr [esi + field_18]          # 0050b2fe
    shl eax, 0x3                                 # 0050b301
    push eax                                     # 0050b304
    call FUN_0050ea90                            # 0050b305
    mov ecx, dword ptr [esp + stk_1c]            # 0050b30a
    add esp, 0xc                                 # 0050b30e
    mov dword ptr [esi + field_14], eax          # 0050b311
    mov dword ptr [esi + field_14e], ecx         # 0050b314
    pop edi                                      # 0050b31a
    {load} xor eax, eax                          # 0050b31b
    pop esi                                      # 0050b31d
    ret                                          # 0050b31e
L_0050b31f:
    # block 0x0050b31f: entered by je at 0x0050b2c7, 3 instruction(s), ends with ret
    or eax, -0x1                                 # 0050b31f
    pop esi                                      # 0050b322
    ret                                          # 0050b323

# --- data items (not part of the function) -------------------------
.org 0x0050b324 - 0x401000
PAD_0050b324:  # 12 byte(s) of nop padding
    .fill 12, 1, 0x90

