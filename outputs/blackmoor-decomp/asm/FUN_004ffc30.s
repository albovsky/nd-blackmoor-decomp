# FUN_004ffc30
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ffc30
# extent:       0x004ffc30-0x004ffc4f (31 code bytes)
# span:         0x004ffc30-0x004ffc50 (code 31, tables 0, padding 1)
# sha256:       2fc80250d67d9bb4d63d13435df59fc4cb225005048142a5230f830bff222c4b
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ffc30
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_0050e936
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x004ffc30 - 0x401000
.globl FUN_004ffc30
FUN_004ffc30:
    # block 0x004ffc30: entry, 3 instruction(s), ends with je to 0x004ffc4e (forward)
    mov edx, dword ptr [esp + stk_4]             # 004ffc30
    test edx, edx                                # 004ffc34
    je.d8 L_004ffc4e                             # 004ffc36
    # block 0x004ffc38: entered by fall-through of je at 0x004ffc36, 9 instruction(s), calls FUN_0050e936, falls into the block at 0x004ffc4e
    push edi                                     # 004ffc38
    mov ecx, 0x83                                # 004ffc39
    {load} xor eax, eax                          # 004ffc3e
    {load} mov edi, edx                          # 004ffc40
    rep stosd dword ptr es:[edi], eax            # 004ffc42
    push edx                                     # 004ffc44
    call FUN_0050e936                            # 004ffc45
    add esp, 0x4                                 # 004ffc4a
    pop edi                                      # 004ffc4d
L_004ffc4e:
    # block 0x004ffc4e: entered by je at 0x004ffc36, 1 instruction(s), ends with ret
    ret                                          # 004ffc4e

# --- data items (not part of the function) -------------------------
.org 0x004ffc4f - 0x401000
PAD_004ffc4f:  # 1 byte(s) of nop padding
    .fill 1, 1, 0x90

