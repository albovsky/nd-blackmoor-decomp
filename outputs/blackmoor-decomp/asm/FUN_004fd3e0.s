# FUN_004fd3e0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd3e0
# extent:       0x004fd3e0-0x004fd421 (65 code bytes)
# span:         0x004fd3e0-0x004fd430 (code 65, tables 0, padding 15)
# sha256:       edec8b7f4e99d60d5228c39cc6106e87eb084b5e7d29e4f9b9de5b370b426a2d
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd3e0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_58; [esp + n] stk_8
# callees:      calls FUN_004fd430, FUN_004fcef0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 27 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_58, 0x58  # offset +0x58

# --- external targets -----------------------------------------------
.set FUN_004fcef0, .text + (0x004fcef0 - 0x401000)
.set FUN_004fd430, .text + (0x004fd430 - 0x401000)

.org 0x004fd3e0 - 0x401000
.globl FUN_004fd3e0
FUN_004fd3e0:
    # block 0x004fd3e0: entry, 5 instruction(s), ends with jge to 0x004fd3f2 (forward)
    push esi                                     # 004fd3e0
    mov esi, dword ptr [esp + stk_8]             # 004fd3e1
    mov eax, 0x2                                 # 004fd3e5
    cmp dword ptr [esi + field_58], eax          # 004fd3ea
    jge.d8 L_004fd3f2                            # 004fd3ed
    # block 0x004fd3ef: entered by fall-through of jge at 0x004fd3ed, 1 instruction(s), falls into the block at 0x004fd3f2
    mov dword ptr [esi + field_58], eax          # 004fd3ef
L_004fd3f2:
    # block 0x004fd3f2: entered by jge at 0x004fd3ed, 3 instruction(s), ends with je to 0x004fd41d (forward)
    mov eax, dword ptr [esi + field_4]           # 004fd3f2
    test eax, eax                                # 004fd3f5
    je.d8 L_004fd41d                             # 004fd3f7
    # block 0x004fd3f9: entered by fall-through of je at 0x004fd3f7, 7 instruction(s), calls FUN_004fd430, ends with je to 0x004fd418 (forward)
    push edi                                     # 004fd3f9
    push esi                                     # 004fd3fa
    call FUN_004fd430                            # 004fd3fb
    {load} mov edi, eax                          # 004fd400
    add esp, 0x4                                 # 004fd402
    test edi, edi                                # 004fd405
    je.d8 L_004fd418                             # 004fd407
    # block 0x004fd409: entered by fall-through of je at 0x004fd407, 4 instruction(s), calls FUN_004fcef0, falls into the block at 0x004fd418
    push esi                                     # 004fd409
    mov dword ptr [esi], 0x0                     # 004fd40a
    call FUN_004fcef0                            # 004fd410
    add esp, 0x4                                 # 004fd415
L_004fd418:
    # block 0x004fd418: entered by je at 0x004fd407, 4 instruction(s), ends with ret
    {load} mov eax, edi                          # 004fd418
    pop edi                                      # 004fd41a
    pop esi                                      # 004fd41b
    ret                                          # 004fd41c
L_004fd41d:
    # block 0x004fd41d: entered by je at 0x004fd3f7, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 004fd41d
    pop esi                                      # 004fd41f
    ret                                          # 004fd420

# --- data items (not part of the function) -------------------------
.org 0x004fd421 - 0x401000
PAD_004fd421:  # 15 byte(s) of nop padding
    .fill 15, 1, 0x90

