# FUN_005230ce
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005230ce
# extent:       0x005230ce-0x005230f0 (34 code bytes)
# span:         0x005230ce-0x005230f0 (code 34, tables 0, padding 0)
# sha256:       94d376545f2b6a256797d082510f6607167f575efeb8eb9bde930197679b71fd
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00523056 (+0x78)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005230ce
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00523056
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00523056, .text + (0x00523056 - 0x401000)

.org 0x005230ce - 0x401000
.globl FUN_005230ce
FUN_005230ce:
    # block 0x005230ce: entry, 3 instruction(s), ends with je to 0x005230ea (forward)
    mov eax, dword ptr [esp + stk_8]             # 005230ce
    test eax, eax                                # 005230d2
    je.d8 L_005230ea                             # 005230d4
    # block 0x005230d6: entered by fall-through of je at 0x005230d4, 2 instruction(s), ends with je to 0x005230ea (forward)
    cmp dword ptr [eax], 0x0                     # 005230d6
    je.d8 L_005230ea                             # 005230d9
    # block 0x005230db: entered by fall-through of je at 0x005230d9, 5 instruction(s), calls FUN_00523056, ends with je to 0x005230ed (forward)
    push 0xe900                                  # 005230db
    push eax                                     # 005230e0
    call FUN_00523056                            # 005230e1
    test eax, eax                                # 005230e6
    je.d8 L_005230ed                             # 005230e8
L_005230ea:
    # block 0x005230ea: entered by je at 0x005230d4; je at 0x005230d9; fall-through of je at 0x005230e8, 2 instruction(s), falls into the block at 0x005230ed
    push 0x1                                     # 005230ea
    pop eax                                      # 005230ec
L_005230ed:
    # block 0x005230ed: entered by je at 0x005230e8, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 005230ed

