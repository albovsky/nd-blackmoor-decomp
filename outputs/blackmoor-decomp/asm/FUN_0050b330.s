# FUN_0050b330
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050b330
# extent:       0x0050b330-0x0050b377 (71 code bytes)
# span:         0x0050b330-0x0050b380 (code 71, tables 0, padding 9)
# sha256:       a3746043c78131df1c74c24689d1c72bbbdb87a3a62ad3ff153198367bc9f0bc
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050b330
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_10, field_14; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x0050b330 - 0x401000
.globl FUN_0050b330
FUN_0050b330:
    # block 0x0050b330: entry, 4 instruction(s), ends with je to 0x0050b373 (forward)
    push edi                                     # 0050b330
    mov edi, dword ptr [esp + stk_8]             # 0050b331
    test edi, edi                                # 0050b335
    je.d8 L_0050b373                             # 0050b337
    # block 0x0050b339: entered by fall-through of je at 0x0050b337, 3 instruction(s), ends with je to 0x0050b348 (forward)
    mov eax, dword ptr [edi]                     # 0050b339
    test eax, eax                                # 0050b33b
    je.d8 L_0050b348                             # 0050b33d
    # block 0x0050b33f: entered by fall-through of je at 0x0050b33d, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x0050b348
    push eax                                     # 0050b33f
    call FUN_0050e936                            # 0050b340
    add esp, 0x4                                 # 0050b345
L_0050b348:
    # block 0x0050b348: entered by je at 0x0050b33d, 3 instruction(s), ends with je to 0x0050b358 (forward)
    mov eax, dword ptr [edi + field_10]          # 0050b348
    test eax, eax                                # 0050b34b
    je.d8 L_0050b358                             # 0050b34d
    # block 0x0050b34f: entered by fall-through of je at 0x0050b34d, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x0050b358
    push eax                                     # 0050b34f
    call FUN_0050e936                            # 0050b350
    add esp, 0x4                                 # 0050b355
L_0050b358:
    # block 0x0050b358: entered by je at 0x0050b34d, 3 instruction(s), ends with je to 0x0050b368 (forward)
    mov eax, dword ptr [edi + field_14]          # 0050b358
    test eax, eax                                # 0050b35b
    je.d8 L_0050b368                             # 0050b35d
    # block 0x0050b35f: entered by fall-through of je at 0x0050b35d, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x0050b368
    push eax                                     # 0050b35f
    call FUN_0050e936                            # 0050b360
    add esp, 0x4                                 # 0050b365
L_0050b368:
    # block 0x0050b368: entered by je at 0x0050b35d, 4 instruction(s), falls into the block at 0x0050b373
    mov ecx, 0x59                                # 0050b368
    {load} xor eax, eax                          # 0050b36d
    rep stosd dword ptr es:[edi], eax            # 0050b36f
    stosw word ptr es:[edi], ax                  # 0050b371
L_0050b373:
    # block 0x0050b373: entered by je at 0x0050b337, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050b373
    pop edi                                      # 0050b375
    ret                                          # 0050b376

# --- data items (not part of the function) -------------------------
.org 0x0050b377 - 0x401000
PAD_0050b377:  # 9 byte(s) of nop padding
    .fill 9, 1, 0x90

