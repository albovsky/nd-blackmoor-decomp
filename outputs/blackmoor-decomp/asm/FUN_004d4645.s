# FUN_004d4645
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d4645
# extent:       0x004d4645-0x004d46b3 (110 code bytes)
# span:         0x004d4645-0x004d46b3 (code 110, tables 0, padding 0)
# sha256:       b17f3b29308f75147693d9980cd04c2e3a64cc179605885c703dbcf21d2a4190
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d4645
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c2dfb, FUN_0043dbd5, FUN_004dad60, FUN_004db870
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_0043dbd5, .text + (0x0043dbd5 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)
.set FUN_004db870, .text + (0x004db870 - 0x401000)

.org 0x004d4645 - 0x401000
.globl FUN_004d4645
FUN_004d4645:
    # block 0x004d4645: entry, 15 instruction(s), calls FUN_004c2dfb, FUN_0043dbd5, FUN_004dad60, ends with jne to 0x004d4694 (forward)
    push ebp                                     # 004d4645
    {load} mov ebp, esp                          # 004d4646
    push 0x5d0387                                # 004d4648
    mov ecx, 0x5cf659                            # 004d464d
    call FUN_004c2dfb                            # 004d4652
    push 0x5d038b                                # 004d4657
    mov ecx, 0x5cf659                            # 004d465c
    call FUN_004c2dfb                            # 004d4661
    call FUN_0043dbd5                            # 004d4666
    mov ecx, 0x5830a6                            # 004d466b
    call FUN_004dad60                            # 004d4670
    mov eax, dword ptr [0x583985]                # 004d4675
    mov dword ptr [0x583981], eax                # 004d467a
    cmp dword ptr [0x583985], 0x6                # 004d467f
    jne.d8 L_004d4694                            # 004d4686
    # block 0x004d4688: entered by fall-through of jne at 0x004d4686, 2 instruction(s), ends with forward jump to 0x004d46a7
    mov dword ptr [0x5839a1], 0x0                # 004d4688
    jmp.d8 L_004d46a7                            # 004d4692
L_004d4694:
    # block 0x004d4694: entered by jne at 0x004d4686, 2 instruction(s), ends with jne to 0x004d46a7 (forward)
    cmp dword ptr [0x583985], 0xe                # 004d4694
    jne.d8 L_004d46a7                            # 004d469b
    # block 0x004d469d: entered by fall-through of jne at 0x004d469b, 2 instruction(s), calls FUN_004db870, falls into the block at 0x004d46a7
    mov ecx, 0x5830ce                            # 004d469d
    call FUN_004db870                            # 004d46a2
L_004d46a7:
    # block 0x004d46a7: entered by jmp at 0x004d4692; jne at 0x004d469b, 3 instruction(s), ends with ret
    mov dword ptr [0x583985], 0x5                # 004d46a7
    pop ebp                                      # 004d46b1
    ret                                          # 004d46b2

