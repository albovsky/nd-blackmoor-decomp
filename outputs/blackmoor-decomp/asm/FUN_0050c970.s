# FUN_0050c970
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c970
# extent:       0x0050c970-0x0050c992 (34 code bytes)
# span:         0x0050c970-0x0050c992 (code 34, tables 0, padding 0)
# sha256:       acab246fa724e03d54a6f2365e1b7cad7356227fab8b38038b127f95e385873e
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0050c950 (+0x20)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c970
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4, stk_8, stk_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0050c970 - 0x401000
.globl FUN_0050c970
FUN_0050c970:
    # block 0x0050c970: entry, 4 instruction(s), ends with je to 0x0050c991 (forward)
    mov ecx, dword ptr [esp + stk_4]             # 0050c970
    test dword ptr [ecx + field_4], 0x6          # 0050c974
    mov eax, 0x1                                 # 0050c97b
    je.d8 L_0050c991                             # 0050c980
    # block 0x0050c982: entered by fall-through of je at 0x0050c980, 4 instruction(s), falls into the block at 0x0050c991
    mov eax, dword ptr [esp + stk_8]             # 0050c982
    mov edx, dword ptr [esp + stk_10]            # 0050c986
    mov dword ptr [edx], eax                     # 0050c98a
    mov eax, 0x3                                 # 0050c98c
L_0050c991:
    # block 0x0050c991: entered by je at 0x0050c980, 1 instruction(s), ends with ret
    ret                                          # 0050c991

