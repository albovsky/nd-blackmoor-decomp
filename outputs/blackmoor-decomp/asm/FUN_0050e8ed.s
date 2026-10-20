# FUN_0050e8ed
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050e8ed
# extent:       0x0050e8ed-0x0050e912 (37 code bytes)
# span:         0x0050e8ed-0x0050e912 (code 37, tables 0, padding 0)
# sha256:       bee78432f12e8f89b72a523f1040bcf0642ddc9b5e2fed61fbad1bbb69a2deef
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         __amsg_exit
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      calls FUN_00514d99, FUN_00514dd2; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_00514d99, .text + (0x00514d99 - 0x401000)
.set FUN_00514dd2, .text + (0x00514dd2 - 0x401000)

.org 0x0050e8ed - 0x401000
.globl FUN_0050e8ed
FUN_0050e8ed:
    # block 0x0050e8ed: entry, 2 instruction(s), ends with jne to 0x0050e8fb (forward)
    cmp dword ptr [0x63ca70], 0x1                # 0050e8ed
    jne.d8 L_0050e8fb                            # 0050e8f4
    # block 0x0050e8f6: entered by fall-through of jne at 0x0050e8f4, 1 instruction(s), calls FUN_00514d99, falls into the block at 0x0050e8fb
    call FUN_00514d99                            # 0050e8f6
L_0050e8fb:
    # block 0x0050e8fb: entered by jne at 0x0050e8f4, 7 instruction(s), calls FUN_00514dd2, indirect dword ptr [0x567e7c], ends with ret
    push dword ptr [esp + stk_4]                 # 0050e8fb
    call FUN_00514dd2                            # 0050e8ff
    push 0xff                                    # 0050e904
    call dword ptr [0x567e7c]                    # 0050e909
    pop ecx                                      # 0050e90f
    pop ecx                                      # 0050e910
    ret                                          # 0050e911

