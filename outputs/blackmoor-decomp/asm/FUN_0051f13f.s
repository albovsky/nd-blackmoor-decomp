# FUN_0051f13f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f13f
# extent:       0x0051f13f-0x0051f164 (37 code bytes)
# span:         0x0051f13f-0x0051f164 (code 37, tables 0, padding 0)
# sha256:       23106e9cc03c4ff486c5d68314052bd4b98579fa61074db3517f893be47e971a
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         AfxInternalProcessWndProcException
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_8
# callees:      calls USER32.dll!ValidateRect
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
# note:         further_unindexed_code_at:0x0051f164
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0051f13f - 0x401000
.globl FUN_0051f13f
FUN_0051f13f:
    # block 0x0051f13f: entry, 4 instruction(s), ends with jne to 0x0051f150 (forward)
    mov ecx, dword ptr [esp + stk_8]             # 0051f13f
    mov eax, dword ptr [ecx + field_4]           # 0051f143
    cmp eax, 0x1                                 # 0051f146
    jne.d8 L_0051f150                            # 0051f149
    # block 0x0051f14b: entered by fall-through of jne at 0x0051f149, 2 instruction(s), ends with forward jump to 0x0051f161
    or eax, -0x1                                 # 0051f14b
    jmp.d8 L_0051f161                            # 0051f14e
L_0051f150:
    # block 0x0051f150: entered by jne at 0x0051f149, 2 instruction(s), ends with jne to 0x0051f15f (forward)
    cmp eax, 0xf                                 # 0051f150
    jne.d8 L_0051f15f                            # 0051f153
    # block 0x0051f155: entered by fall-through of jne at 0x0051f153, 3 instruction(s), calls USER32.dll!ValidateRect, falls into the block at 0x0051f15f
    push 0x0                                     # 0051f155
    push dword ptr [ecx]                         # 0051f157
    call dword ptr [0x52a364]                    # 0051f159
L_0051f15f:
    # block 0x0051f15f: entered by jne at 0x0051f153, 1 instruction(s), falls into the block at 0x0051f161
    {load} xor eax, eax                          # 0051f15f
L_0051f161:
    # block 0x0051f161: entered by jmp at 0x0051f14e, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 0051f161

