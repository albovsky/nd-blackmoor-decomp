# FUN_004ffc10
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ffc10
# extent:       0x004ffc10-0x004ffc2f (31 code bytes)
# span:         0x004ffc10-0x004ffc30 (code 31, tables 0, padding 1)
# sha256:       ada1e5174358d83d6a2e781040a12e8336fe604596603e493c0ec5473737d0f4
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ffc10
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x004ffc10 - 0x401000
.globl FUN_004ffc10
FUN_004ffc10:
    # block 0x004ffc10: entry, 3 instruction(s), ends with je to 0x004ffc2e (forward)
    mov edx, dword ptr [esp + stk_4]             # 004ffc10
    test edx, edx                                # 004ffc14
    je.d8 L_004ffc2e                             # 004ffc16
    # block 0x004ffc18: entered by fall-through of je at 0x004ffc16, 9 instruction(s), calls FUN_0050e936, falls into the block at 0x004ffc2e
    push edi                                     # 004ffc18
    mov ecx, 0x9                                 # 004ffc19
    {load} xor eax, eax                          # 004ffc1e
    {load} mov edi, edx                          # 004ffc20
    rep stosd dword ptr es:[edi], eax            # 004ffc22
    push edx                                     # 004ffc24
    call FUN_0050e936                            # 004ffc25
    add esp, 0x4                                 # 004ffc2a
    pop edi                                      # 004ffc2d
L_004ffc2e:
    # block 0x004ffc2e: entered by je at 0x004ffc16, 1 instruction(s), ends with ret
    ret                                          # 004ffc2e

# --- data items (not part of the function) -------------------------
.org 0x004ffc2f - 0x401000
PAD_004ffc2f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

