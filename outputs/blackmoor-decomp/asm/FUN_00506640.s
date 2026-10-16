# FUN_00506640
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00506640
# extent:       0x00506640-0x00506650 (16 code bytes)
# span:         0x00506640-0x00506650 (code 16, tables 0, padding 0)
# sha256:       ed7de48ca153233cef6b2de6c12628357cb11bfb7a2b0e87d95c877e60535de4
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00506640
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_005051b0
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 7 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_005051b0, .text + (0x005051b0 - 0x401000)

.org 0x00506640 - 0x401000
.globl FUN_00506640
FUN_00506640:
    # block 0x00506640: entry, 3 instruction(s), ends with je to 0x0050664f (forward)
    mov eax, dword ptr [esp + stk_4]             # 00506640
    test eax, eax                                # 00506644
    je.d8 L_0050664f                             # 00506646
    # block 0x00506648: entered by fall-through of je at 0x00506646, 3 instruction(s), calls FUN_005051b0, falls into the block at 0x0050664f
    push eax                                     # 00506648
    call FUN_005051b0                            # 00506649
    pop ecx                                      # 0050664e
L_0050664f:
    # block 0x0050664f: entered by je at 0x00506646, 1 instruction(s), ends with ret
    ret                                          # 0050664f

