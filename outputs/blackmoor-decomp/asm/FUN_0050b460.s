# FUN_0050b460
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b460
# extent:       0x0050b460-0x0050b4a4 (68 code bytes)
# span:         0x0050b460-0x0050b4b0 (code 68, tables 0, padding 12)
# sha256:       f17493405cc5362574d17a16ad3ea9b1144b0aa9f1538cd4869a6203548a8cb9
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b460
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_20; [esi + n] field_10, field_14, field_18, field_1c; [esp + n] stk_8
# callees:      calls FUN_0050ebca
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 26 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0050ebca, .text + (0x0050ebca - 0x401000)

.org 0x0050b460 - 0x401000
.globl FUN_0050b460
FUN_0050b460:
    # block 0x0050b460: entry, 8 instruction(s), ends with jg to 0x0050b4a2 (forward)
    mov ecx, dword ptr [esp + stk_8]             # 0050b460
    push esi                                     # 0050b464
    mov esi, dword ptr [esp + stk_8]             # 0050b465
    mov edx, dword ptr [esi + field_1c]          # 0050b469
    mov eax, dword ptr [esi + field_18]          # 0050b46c
    {load} add edx, ecx                          # 0050b46f
    {load} cmp eax, edx                          # 0050b471
    jg.d8 L_0050b4a2                             # 0050b473
    # block 0x0050b475: entered by fall-through of jg at 0x0050b473, 16 instruction(s), calls FUN_0050ebca, falls into the block at 0x0050b4a2
    lea eax, [eax + ecx + field_20]              # 0050b475
    mov ecx, dword ptr [esi + field_10]          # 0050b479
    mov dword ptr [esi + field_18], eax          # 0050b47c
    shl eax, 0x2                                 # 0050b47f
    push eax                                     # 0050b482
    push ecx                                     # 0050b483
    call FUN_0050ebca                            # 0050b484
    mov edx, dword ptr [esi + field_18]          # 0050b489
    mov dword ptr [esi + field_10], eax          # 0050b48c
    mov eax, dword ptr [esi + field_14]          # 0050b48f
    shl edx, 0x3                                 # 0050b492
    push edx                                     # 0050b495
    push eax                                     # 0050b496
    call FUN_0050ebca                            # 0050b497
    add esp, 0x10                                # 0050b49c
    mov dword ptr [esi + field_14], eax          # 0050b49f
L_0050b4a2:
    # block 0x0050b4a2: entered by jg at 0x0050b473, 2 instruction(s), ends with ret
    pop esi                                      # 0050b4a2
    ret                                          # 0050b4a3

# --- data items (not part of the function) -------------------------
.org 0x0050b4a4 - 0x401000
PAD_0050b4a4:  # 12 byte(s) of nop padding
    .fill 12, 1, 0x90

