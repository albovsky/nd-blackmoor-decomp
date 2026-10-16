# FUN_004fd650
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fd650
# extent:       0x004fd650-0x004fd686 (54 code bytes)
# span:         0x004fd650-0x004fd690 (code 54, tables 0, padding 10)
# sha256:       4490dd45d98a7c3117bac4cb911109042de9f677e9459b5797c564549723af65
# evidence:     ev_edb26fcf7b21a4e4f4785e0b56b76960182762a5eae671897573c39f3cf8c11e
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fd650
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_8, field_c, field_2b2; [esp + n] stk_8, stk_10, stk_18
# callees:      calls FUN_0050b9e0; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10
.equ stk_18, 0x18  # offset +0x18
.equ field_2b2, 0x2b2  # offset +0x2b2

# --- external targets -----------------------------------------------
.set FUN_0050b9e0, .text + (0x0050b9e0 - 0x401000)

.org 0x004fd650 - 0x401000
.globl FUN_004fd650
FUN_004fd650:
    # block 0x004fd650: entry, 5 instruction(s), ends with je to 0x004fd684 (forward)
    push esi                                     # 004fd650
    mov esi, dword ptr [esp + stk_8]             # 004fd651
    mov eax, dword ptr [esi]                     # 004fd655
    test eax, eax                                # 004fd657
    je.d8 L_004fd684                             # 004fd659
    # block 0x004fd65b: entered by fall-through of je at 0x004fd659, 17 instruction(s), calls indirect dword ptr [esi + 0x2b2], FUN_0050b9e0, falls into the block at 0x004fd684
    push ebx                                     # 004fd65b
    mov ebx, dword ptr [esp + stk_10]            # 004fd65c
    push edi                                     # 004fd660
    mov edi, dword ptr [esp + stk_18]            # 004fd661
    push 0x0                                     # 004fd665
    push edi                                     # 004fd667
    push ebx                                     # 004fd668
    push eax                                     # 004fd669
    call dword ptr [esi + field_2b2]             # 004fd66a
    mov dword ptr [esi + field_8], ebx           # 004fd670
    mov dword ptr [esi + field_c], edi           # 004fd673
    add esi, 0x18                                # 004fd676
    push esi                                     # 004fd679
    call FUN_0050b9e0                            # 004fd67a
    add esp, 0x14                                # 004fd67f
    pop edi                                      # 004fd682
    pop ebx                                      # 004fd683
L_004fd684:
    # block 0x004fd684: entered by je at 0x004fd659, 2 instruction(s), ends with ret
    pop esi                                      # 004fd684
    ret                                          # 004fd685

# --- data items (not part of the function) -------------------------
.org 0x004fd686 - 0x401000
PAD_004fd686:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

