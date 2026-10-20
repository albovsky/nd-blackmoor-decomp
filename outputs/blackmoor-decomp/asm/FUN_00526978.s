# FUN_00526978
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00526978
# extent:       0x00526978-0x0052699b (35 code bytes)
# span:         0x00526978-0x0052699b (code 35, tables 0, padding 0)
# sha256:       ef11d00828ac966995d2812a1a2c0cfded72b38f5d52cbd0904fa5436983e430
# evidence:     ev_32e70435e0f93fa23474409ec6f8f2149ef102be09e1d26950abf41be9f26959
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         AfxPostQuitMessage
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_54; [esp + n] stk_4
# callees:      calls FUN_0051ec6f, USER32.dll!PostQuitMessage; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0052699b
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)

.org 0x00526978 - 0x401000
.globl FUN_00526978
FUN_00526978:
    # block 0x00526978: entry, 3 instruction(s), calls FUN_0051ec6f, ends with je to 0x0052698e (forward)
    call FUN_0051ec6f                            # 00526978
    test eax, eax                                # 0052697d
    je.d8 L_0052698e                             # 0052697f
    # block 0x00526981: entered by fall-through of je at 0x0052697f, 3 instruction(s), ends with je to 0x0052698e (forward)
    mov eax, dword ptr [eax + field_54]          # 00526981
    test eax, eax                                # 00526984
    je.d8 L_0052698e                             # 00526986
    # block 0x00526988: entered by fall-through of je at 0x00526986, 3 instruction(s), calls indirect eax, falls into the block at 0x0052698e
    push 0x1                                     # 00526988
    push 0x1                                     # 0052698a
    call eax                                     # 0052698c
L_0052698e:
    # block 0x0052698e: entered by je at 0x0052697f; je at 0x00526986, 3 instruction(s), calls USER32.dll!PostQuitMessage, ends with ret 0x4
    push dword ptr [esp + stk_4]                 # 0052698e
    call dword ptr [0x52a48c]                    # 00526992
    ret 0x4                                      # 00526998

