# FUN_0050ff80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ff80
# extent:       0x0050ff80-0x0050ffb2 (50 code bytes)
# span:         0x0050ff80-0x0050ffb2 (code 50, tables 0, padding 0)
# sha256:       ba57fdc65b321402c2fcc430b9f2b143f01e34709b476fdc59e2ea9fdc613eed
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ff80
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00510dd3, FUN_0050e8ed, FUN_00510e3a, KERNEL32.dll!ExitThread; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050e8ed, .text + (0x0050e8ed - 0x401000)
.set FUN_00510dd3, .text + (0x00510dd3 - 0x401000)
.set FUN_00510e3a, .text + (0x00510e3a - 0x401000)

.org 0x0050ff80 - 0x401000
.globl FUN_0050ff80
FUN_0050ff80:
    # block 0x0050ff80: entry, 3 instruction(s), ends with je to 0x0050ff8b (forward)
    mov eax, dword ptr [0x567e30]                # 0050ff80
    test eax, eax                                # 0050ff85
    je.d8 L_0050ff8b                             # 0050ff87
    # block 0x0050ff89: entered by fall-through of je at 0x0050ff87, 1 instruction(s), calls indirect eax, falls into the block at 0x0050ff8b
    call eax                                     # 0050ff89
L_0050ff8b:
    # block 0x0050ff8b: entered by je at 0x0050ff87, 5 instruction(s), calls FUN_00510dd3, ends with jne to 0x0050ff9f (forward)
    push esi                                     # 0050ff8b
    call FUN_00510dd3                            # 0050ff8c
    {load} mov esi, eax                          # 0050ff91
    test esi, esi                                # 0050ff93
    jne.d8 L_0050ff9f                            # 0050ff95
    # block 0x0050ff97: entered by fall-through of jne at 0x0050ff95, 3 instruction(s), calls FUN_0050e8ed, falls into the block at 0x0050ff9f
    push 0x10                                    # 0050ff97
    call FUN_0050e8ed                            # 0050ff99
    pop ecx                                      # 0050ff9e
L_0050ff9f:
    # block 0x0050ff9f: entered by jne at 0x0050ff95, 7 instruction(s), calls FUN_00510e3a, KERNEL32.dll!ExitThread, ends with ret
    push esi                                     # 0050ff9f
    call FUN_00510e3a                            # 0050ffa0
    pop ecx                                      # 0050ffa5
    push dword ptr [esp + stk_8]                 # 0050ffa6
    call dword ptr [0x52a160]                    # 0050ffaa
    pop esi                                      # 0050ffb0
    ret                                          # 0050ffb1

