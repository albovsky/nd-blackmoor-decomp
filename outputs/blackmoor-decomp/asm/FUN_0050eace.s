# FUN_0050eace
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050eace
# extent:       0x0050eace-0x0050eb1c (78 code bytes)
# span:         0x0050eace-0x0050eb20 (code 78, tables 0, padding 4)
# sha256:       86b7591b3af8dab1aeaa6e5e74951227588aa6dda7b6890c6009404f8ada9efd
# evidence:     ev_4431af068a3f4ca776e521e2b82a00887220c1221c914635cfd4305c8866eb9e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050eace
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_8
# callees:      calls FUN_00512c18, FUN_005152b9, FUN_00512c79, KERNEL32.dll!HeapAlloc
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 30 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00512c18, .text + (0x00512c18 - 0x401000)
.set FUN_00512c79, .text + (0x00512c79 - 0x401000)
.set FUN_005152b9, .text + (0x005152b9 - 0x401000)

.org 0x0050eace - 0x401000
.globl FUN_0050eace
FUN_0050eace:
    # block 0x0050eace: entry, 5 instruction(s), ends with ja to 0x0050eafd (forward)
    push esi                                     # 0050eace
    mov esi, dword ptr [esp + stk_8]             # 0050eacf
    cmp esi, dword ptr [0x568b78]                # 0050ead3
    push edi                                     # 0050ead9
    ja.d8 L_0050eafd                             # 0050eada
    # block 0x0050eadc: entered by fall-through of ja at 0x0050eada, 10 instruction(s), calls FUN_00512c18, FUN_005152b9, FUN_00512c79, ends with je to 0x0050eafd (forward)
    push 0x9                                     # 0050eadc
    call FUN_00512c18                            # 0050eade
    push esi                                     # 0050eae3
    call FUN_005152b9                            # 0050eae4
    push 0x9                                     # 0050eae9
    {load} mov edi, eax                          # 0050eaeb
    call FUN_00512c79                            # 0050eaed
    add esp, 0xc                                 # 0050eaf2
    test edi, edi                                # 0050eaf5
    je.d8 L_0050eafd                             # 0050eaf7
    # block 0x0050eaf9: entered by fall-through of je at 0x0050eaf7, 2 instruction(s), ends with forward jump to 0x0050eb19
    {load} mov eax, edi                          # 0050eaf9
    jmp.d8 L_0050eb19                            # 0050eafb
L_0050eafd:
    # block 0x0050eafd: entered by ja at 0x0050eada; je at 0x0050eaf7, 2 instruction(s), ends with jne to 0x0050eb04 (forward)
    test esi, esi                                # 0050eafd
    jne.d8 L_0050eb04                            # 0050eaff
    # block 0x0050eb01: entered by fall-through of jne at 0x0050eaff, 2 instruction(s), falls into the block at 0x0050eb04
    push 0x1                                     # 0050eb01
    pop esi                                      # 0050eb03
L_0050eb04:
    # block 0x0050eb04: entered by jne at 0x0050eaff, 6 instruction(s), calls KERNEL32.dll!HeapAlloc, falls into the block at 0x0050eb19
    add esi, 0xf                                 # 0050eb04
    and esi, -0x10                               # 0050eb07
    push esi                                     # 0050eb0a
    push 0x0                                     # 0050eb0b
    push dword ptr [0x63cdd8]                    # 0050eb0d
    call dword ptr [0x52a150]                    # 0050eb13
L_0050eb19:
    # block 0x0050eb19: entered by jmp at 0x0050eafb, 3 instruction(s), ends with ret
    pop edi                                      # 0050eb19
    pop esi                                      # 0050eb1a
    ret                                          # 0050eb1b

# --- data items (not part of the function) -------------------------
.org 0x0050eb1c - 0x401000
PAD_0050eb1c:  # 4 byte(s) of int3 padding
    .fill 4, 1, 0xcc

