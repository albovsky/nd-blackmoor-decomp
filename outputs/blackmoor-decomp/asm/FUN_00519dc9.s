# FUN_00519dc9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519dc9
# extent:       0x00519dc9-0x00519e19 (80 code bytes)
# span:         0x00519dc9-0x00519e19 (code 80, tables 0, padding 0)
# sha256:       14e457a336713bb2c807d450c846f49caa350d5affa2233c488671c2df66025f
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519dc9
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1c, field_3c, field_50; [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_50, field_5c
# callees:      calls FUN_0050f978, FUN_0051dc43, FUN_00519daa
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_1c, 0x1c  # offset +0x1c
.equ field_3c, 0x3c  # offset +0x3c
.equ field_50, 0x50  # offset +0x50
.equ field_5c, 0x5c  # offset +0x5c

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00519daa, .text + (0x00519daa - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00519dc9 - 0x401000
.globl FUN_00519dc9
FUN_00519dc9:
    # block 0x00519dc9: entry, 13 instruction(s), calls FUN_0050f978, FUN_0051dc43, ends with je to 0x00519df9 (forward)
    mov eax, 0x529179                            # 00519dc9
    call FUN_0050f978                            # 00519dce
    push ecx                                     # 00519dd3
    push esi                                     # 00519dd4
    {load} mov esi, ecx                          # 00519dd5
    push 0xa4                                    # 00519dd7
    call FUN_0051dc43                            # 00519ddc
    pop ecx                                      # 00519de1
    {load} mov ecx, eax                          # 00519de2
    mov dword ptr [ebp - field_minus_10], ecx    # 00519de4
    and dword ptr [ebp - field_minus_4], 0x0     # 00519de7
    test ecx, ecx                                # 00519deb
    je.d8 L_00519df9                             # 00519ded
    # block 0x00519def: entered by fall-through of je at 0x00519ded, 3 instruction(s), calls FUN_00519daa, ends with forward jump to 0x00519dfb
    push dword ptr [esi + field_5c]              # 00519def
    call FUN_00519daa                            # 00519df2
    jmp.d8 L_00519dfb                            # 00519df7
L_00519df9:
    # block 0x00519df9: entered by je at 0x00519ded, 1 instruction(s), falls into the block at 0x00519dfb
    {load} xor eax, eax                          # 00519df9
L_00519dfb:
    # block 0x00519dfb: entered by jmp at 0x00519df7, 9 instruction(s), ends with ret
    and dword ptr [eax + field_1c], 0x0          # 00519dfb
    mov ecx, dword ptr [esi + field_50]          # 00519dff
    mov dword ptr [eax + field_50], ecx          # 00519e02
    mov ecx, dword ptr [ebp - field_minus_c]     # 00519e05
    mov dword ptr [eax + field_3c], 0x7009       # 00519e08
    pop esi                                      # 00519e0f
    mov dword ptr fs:[0x0], ecx                  # 00519e10
    leave                                        # 00519e17
    ret                                          # 00519e18

