# FUN_0050c028
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050c028
# extent:       0x0050c028-0x0050c07e (86 code bytes)
# span:         0x0050c028-0x0050c07e (code 86, tables 0, padding 0)
# sha256:       1bae6bd22e74f479ea2a61f1962315ca6854166bd248ab8dee61d75c580f4ceb
# evidence:     ev_6b87ed72115c87fed1179d88fa97974f93d6f22889e386bb49899d21464413f2
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050c028
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c; [esp + n] stk_c, stk_10
# callees:      calls FUN_0050bf50; plus 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 32 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050bf50, .text + (0x0050bf50 - 0x401000)

.org 0x0050c028 - 0x401000
.globl FUN_0050c028
FUN_0050c028:
    # block 0x0050c028: entry, 5 instruction(s), calls FUN_0050bf50, ends with je to 0x0050c043 (forward)
    push esi                                     # 0050c028
    push edi                                     # 0050c029
    call FUN_0050bf50                            # 0050c02a
    test eax, eax                                # 0050c02f
    je.d8 L_0050c043                             # 0050c031
    # block 0x0050c033: entered by fall-through of je at 0x0050c031, 4 instruction(s), calls indirect dword ptr [0x63c360], ends with forward jump to 0x0050c079
    push dword ptr [esp + stk_10]                # 0050c033
    push dword ptr [esp + stk_10]                # 0050c037
    call dword ptr [0x63c360]                    # 0050c03b
    jmp.d8 L_0050c079                            # 0050c041
L_0050c043:
    # block 0x0050c043: entered by je at 0x0050c031, 2 instruction(s), ends with jne to 0x0050c074 (forward)
    test byte ptr [esp + stk_10], 0x3            # 0050c043
    jne.d8 L_0050c074                            # 0050c048
    # block 0x0050c04a: entered by fall-through of jne at 0x0050c048, 4 instruction(s), ends with jle to 0x0050c070 (forward)
    mov esi, dword ptr [esp + stk_c]             # 0050c04a
    {load} xor eax, eax                          # 0050c04e
    cmp dword ptr [esi + field_8], eax           # 0050c050
    jle.d8 L_0050c070                            # 0050c053
    # block 0x0050c055: entered by fall-through of jle at 0x0050c053, 2 instruction(s), ends with jle to 0x0050c070 (forward)
    cmp dword ptr [esi + field_c], eax           # 0050c055
    jle.d8 L_0050c070                            # 0050c058
    # block 0x0050c05a: entered by fall-through of jle at 0x0050c058, 5 instruction(s), calls indirect edi, ends with jge to 0x0050c070 (forward)
    mov edi, dword ptr [0x52a498]                # 0050c05a
    push eax                                     # 0050c060
    call edi                                     # 0050c061
    cmp dword ptr [esi], eax                     # 0050c063
    jge.d8 L_0050c070                            # 0050c065
    # block 0x0050c067: entered by fall-through of jge at 0x0050c065, 4 instruction(s), calls indirect edi, ends with jl to 0x0050c074 (forward)
    push 0x1                                     # 0050c067
    call edi                                     # 0050c069
    cmp dword ptr [esi + field_4], eax           # 0050c06b
    jl.d8 L_0050c074                             # 0050c06e
L_0050c070:
    # block 0x0050c070: entered by jle at 0x0050c053; jle at 0x0050c058; jge at 0x0050c065; fall-through of jl at 0x0050c06e, 2 instruction(s), ends with forward jump to 0x0050c079
    {load} xor eax, eax                          # 0050c070
    jmp.d8 L_0050c079                            # 0050c072
L_0050c074:
    # block 0x0050c074: entered by jne at 0x0050c048; jl at 0x0050c06e, 1 instruction(s), falls into the block at 0x0050c079
    mov eax, 0x12340042                          # 0050c074
L_0050c079:
    # block 0x0050c079: entered by jmp at 0x0050c041; jmp at 0x0050c072, 3 instruction(s), ends with ret 0x8
    pop edi                                      # 0050c079
    pop esi                                      # 0050c07a
    ret 0x8                                      # 0050c07b

