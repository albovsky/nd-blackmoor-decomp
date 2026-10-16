# FUN_0050a9a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050a9a0
# extent:       0x0050a9a0-0x0050a9bf (31 code bytes)
# span:         0x0050a9a0-0x0050a9c0 (code 31, tables 0, padding 1)
# sha256:       39aa1f0afd5dd85d2aae4cca04ccbe42aa1f8b9758c107ff04582cf3101add6f
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050a9a0
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

.org 0x0050a9a0 - 0x401000
.globl FUN_0050a9a0
FUN_0050a9a0:
    # block 0x0050a9a0: entry, 3 instruction(s), ends with je to 0x0050a9be (forward)
    mov edx, dword ptr [esp + stk_4]             # 0050a9a0
    test edx, edx                                # 0050a9a4
    je.d8 L_0050a9be                             # 0050a9a6
    # block 0x0050a9a8: entered by fall-through of je at 0x0050a9a6, 9 instruction(s), calls FUN_0050e936, falls into the block at 0x0050a9be
    push edi                                     # 0050a9a8
    mov ecx, 0x18                                # 0050a9a9
    {load} xor eax, eax                          # 0050a9ae
    {load} mov edi, edx                          # 0050a9b0
    rep stosd dword ptr es:[edi], eax            # 0050a9b2
    push edx                                     # 0050a9b4
    call FUN_0050e936                            # 0050a9b5
    add esp, 0x4                                 # 0050a9ba
    pop edi                                      # 0050a9bd
L_0050a9be:
    # block 0x0050a9be: entered by je at 0x0050a9a6, 1 instruction(s), ends with ret
    ret                                          # 0050a9be

# --- data items (not part of the function) -------------------------
.org 0x0050a9bf - 0x401000
PAD_0050a9bf:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

