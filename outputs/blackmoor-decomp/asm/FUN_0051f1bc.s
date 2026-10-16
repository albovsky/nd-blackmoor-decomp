# FUN_0051f1bc
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f1bc
# extent:       0x0051f1bc-0x0051f207 (75 code bytes)
# span:         0x0051f1bc-0x0051f207 (code 75, tables 0, padding 0)
# sha256:       f73188c756d3f1e3f3400f5720fe33321a011e3227d759f77681d06416150416
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f1bc
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c; [esp + n] stk_4
# callees:      none direct; 3 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x0051f1bc - 0x401000
.globl FUN_0051f1bc
FUN_0051f1bc:
    # block 0x0051f1bc: entry, 4 instruction(s), ends with jne to 0x0051f201 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0051f1bc
    push esi                                     # 0051f1c0
    cmp dword ptr [eax + field_4], 0x100         # 0051f1c1
    jne.d8 L_0051f201                            # 0051f1c8
    # block 0x0051f1ca: entered by fall-through of jne at 0x0051f1c8, 2 instruction(s), ends with jne to 0x0051f201 (forward)
    cmp dword ptr [eax + field_8], 0x70          # 0051f1ca
    jne.d8 L_0051f201                            # 0051f1ce
    # block 0x0051f1d0: entered by fall-through of jne at 0x0051f1ce, 4 instruction(s), ends with jne to 0x0051f201 (forward)
    mov eax, dword ptr [eax + field_c]           # 0051f1d0
    shr eax, 0x10                                # 0051f1d3
    test ah, 0x40                                # 0051f1d6
    jne.d8 L_0051f201                            # 0051f1d9
    # block 0x0051f1db: entered by fall-through of jne at 0x0051f1d9, 5 instruction(s), calls indirect esi, ends with jl to 0x0051f201 (forward)
    mov esi, dword ptr [0x52a4b8]                # 0051f1db
    push 0x10                                    # 0051f1e1
    call esi                                     # 0051f1e3
    test ax, ax                                  # 0051f1e5
    jl.d8 L_0051f201                             # 0051f1e8
    # block 0x0051f1ea: entered by fall-through of jl at 0x0051f1e8, 4 instruction(s), calls indirect esi, ends with jl to 0x0051f201 (forward)
    push 0x11                                    # 0051f1ea
    call esi                                     # 0051f1ec
    test ax, ax                                  # 0051f1ee
    jl.d8 L_0051f201                             # 0051f1f1
    # block 0x0051f1f3: entered by fall-through of jl at 0x0051f1f1, 4 instruction(s), calls indirect esi, ends with jl to 0x0051f201 (forward)
    push 0x12                                    # 0051f1f3
    call esi                                     # 0051f1f5
    test ax, ax                                  # 0051f1f7
    jl.d8 L_0051f201                             # 0051f1fa
    # block 0x0051f1fc: entered by fall-through of jl at 0x0051f1fa, 3 instruction(s), ends with forward jump to 0x0051f203
    push 0x1                                     # 0051f1fc
    pop eax                                      # 0051f1fe
    jmp.d8 L_0051f203                            # 0051f1ff
L_0051f201:
    # block 0x0051f201: entered by jne at 0x0051f1c8; jne at 0x0051f1ce; jne at 0x0051f1d9; jl at 0x0051f1e8; more, 1 instruction(s), falls into the block at 0x0051f203
    {load} xor eax, eax                          # 0051f201
L_0051f203:
    # block 0x0051f203: entered by jmp at 0x0051f1ff, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051f203
    ret 0x4                                      # 0051f204

