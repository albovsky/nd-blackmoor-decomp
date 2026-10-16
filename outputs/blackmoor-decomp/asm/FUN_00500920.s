# FUN_00500920
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00500920
# extent:       0x00500920-0x00500949 (41 code bytes)
# span:         0x00500920-0x00500950 (code 41, tables 0, padding 7)
# sha256:       58e2c8db23efe441b852998a0bd7c14150ab6ce0e80a27b1f8899bf16a634928
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00500920
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 17 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00500920 - 0x401000
.globl FUN_00500920
FUN_00500920:
    # block 0x00500920: entry, 5 instruction(s), falls into the block at 0x00500930
    mov ecx, dword ptr [esp + stk_4]             # 00500920
    mov edx, dword ptr [esp + stk_8]             # 00500924
    push esi                                     # 00500928
    {load} sub edx, ecx                          # 00500929
    mov esi, 0x38                                # 0050092b
L_00500930:
    # block 0x00500930: entered by jne at 0x00500945, 5 instruction(s), ends with je to 0x00500941 (forward)
    fld dword ptr [edx + ecx]                    # 00500930
    fcomp dword ptr [ecx]                        # 00500933
    fnstsw ax                                    # 00500935
    test ah, 0x1                                 # 00500937
    je.d8 L_00500941                             # 0050093a
    # block 0x0050093c: entered by fall-through of je at 0x0050093a, 2 instruction(s), falls into the block at 0x00500941
    mov eax, dword ptr [edx + ecx]               # 0050093c
    mov dword ptr [ecx], eax                     # 0050093f
L_00500941:
    # block 0x00500941: entered by je at 0x0050093a, 3 instruction(s), ends with jne to 0x00500930 (backward)
    add ecx, 0x4                                 # 00500941
    dec esi                                      # 00500944
    jne.d8 L_00500930                            # 00500945
    # block 0x00500947: entered by fall-through of jne at 0x00500945, 2 instruction(s), ends with ret
    pop esi                                      # 00500947
    ret                                          # 00500948

# --- data items (not part of the function) -------------------------
.org 0x00500949 - 0x401000
PAD_00500949:  # 7 byte(s) of nop padding
    .fill 7, 1, 0x90

