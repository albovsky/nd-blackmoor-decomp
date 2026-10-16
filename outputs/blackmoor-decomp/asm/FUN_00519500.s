# FUN_00519500
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00519500
# extent:       0x00519500-0x00519561 (97 code bytes)
# span:         0x00519500-0x00519561 (code 97, tables 0, padding 0)
# sha256:       bd8cdb0475bff318c9f93e5374328f44723f0ed85d3e018dcab2d92ae027c437
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00519500
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4; [esp + n] stk_4, stk_c
# callees:      calls FUN_0050ea7e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050ea7e, .text + (0x0050ea7e - 0x401000)

.org 0x00519500 - 0x401000
.globl FUN_00519500
FUN_00519500:
    # block 0x00519500: entry, 14 instruction(s), ends with jne to 0x00519536 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00519500
    push esi                                     # 00519504
    {load} mov ecx, eax                          # 00519505
    and eax, 0x1f                                # 00519507
    sar ecx, 0x5                                 # 0051950a
    lea eax, [eax + 8*eax]                       # 0051950d
    mov esi, 0x8000                              # 00519510
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 00519515
    lea edx, [ecx + 4*eax + field_4]             # 0051951c
    mov cl, byte ptr [ecx + 4*eax + field_4]     # 00519520
    {load} mov al, cl                            # 00519524
    and eax, 0x80                                # 00519526
    cmp dword ptr [esp + stk_c], esi             # 0051952b
    jne.d8 L_00519536                            # 0051952f
    # block 0x00519531: entered by fall-through of jne at 0x0051952f, 2 instruction(s), ends with forward jump to 0x00519543
    and cl, 0x7f                                 # 00519531
    jmp.d8 L_00519543                            # 00519534
L_00519536:
    # block 0x00519536: entered by jne at 0x0051952f, 2 instruction(s), ends with jne to 0x00519551 (forward)
    cmp dword ptr [esp + stk_c], 0x4000          # 00519536
    jne.d8 L_00519551                            # 0051953e
    # block 0x00519540: entered by fall-through of jne at 0x0051953e, 1 instruction(s), falls into the block at 0x00519543
    or cl, -0x80                                 # 00519540
L_00519543:
    # block 0x00519543: entered by jmp at 0x00519534, 7 instruction(s), ends with ret
    neg eax                                      # 00519543
    {load} sbb eax, eax                          # 00519545
    mov byte ptr [edx], cl                       # 00519547
    .insn 0x66, 0x25, 0xc000{:u16}               # 00519549
    {load} add eax, esi                          # 0051954d
    pop esi                                      # 0051954f
    ret                                          # 00519550
L_00519551:
    # block 0x00519551: entered by jne at 0x0051953e, 5 instruction(s), calls FUN_0050ea7e, ends with ret
    call FUN_0050ea7e                            # 00519551
    mov dword ptr [eax], 0x16                    # 00519556
    or eax, -0x1                                 # 0051955c
    pop esi                                      # 0051955f
    ret                                          # 00519560

