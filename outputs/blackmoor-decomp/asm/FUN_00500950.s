# FUN_00500950
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00500950
# extent:       0x00500950-0x00500979 (41 code bytes)
# span:         0x00500950-0x00500980 (code 41, tables 0, padding 7)
# sha256:       7369d4be895ceddbf7b2d44f9abeab120d2c68c83dca29de0d37d5fe2b353167
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00500950
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

.org 0x00500950 - 0x401000
.globl FUN_00500950
FUN_00500950:
    # block 0x00500950: entry, 5 instruction(s), falls into the block at 0x00500960
    mov ecx, dword ptr [esp + stk_4]             # 00500950
    mov edx, dword ptr [esp + stk_8]             # 00500954
    push esi                                     # 00500958
    {load} sub edx, ecx                          # 00500959
    mov esi, 0x38                                # 0050095b
L_00500960:
    # block 0x00500960: entered by jne at 0x00500975, 5 instruction(s), ends with jne to 0x00500971 (forward)
    fld dword ptr [edx + ecx]                    # 00500960
    fcomp dword ptr [ecx]                        # 00500963
    fnstsw ax                                    # 00500965
    test ah, 0x41                                # 00500967
    jne.d8 L_00500971                            # 0050096a
    # block 0x0050096c: entered by fall-through of jne at 0x0050096a, 2 instruction(s), falls into the block at 0x00500971
    mov eax, dword ptr [edx + ecx]               # 0050096c
    mov dword ptr [ecx], eax                     # 0050096f
L_00500971:
    # block 0x00500971: entered by jne at 0x0050096a, 3 instruction(s), ends with jne to 0x00500960 (backward)
    add ecx, 0x4                                 # 00500971
    dec esi                                      # 00500974
    jne.d8 L_00500960                            # 00500975
    # block 0x00500977: entered by fall-through of jne at 0x00500975, 2 instruction(s), ends with ret
    pop esi                                      # 00500977
    ret                                          # 00500978

# --- data items (not part of the function) -------------------------
.org 0x00500979 - 0x401000
PAD_00500979:  # 7 byte(s) of nop padding
    .fill 7, 1, 0x90

