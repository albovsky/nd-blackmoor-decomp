# FUN_0042ae0a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042ae0a
# extent:       0x0042ae0a-0x0042ae73 (105 code bytes)
# span:         0x0042ae0a-0x0042ae73 (code 105, tables 0, padding 0)
# sha256:       9f095a66592bc621ab40d66eaefca00ba6d88794e154c04daedf29c0db966b85
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0042ae0a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0042ae0a - 0x401000
.globl FUN_0042ae0a
FUN_0042ae0a:
    # block 0x0042ae0a: entry, 8 instruction(s), ends with jl to 0x0042ae54 (forward)
    push ebp                                     # 0042ae0a
    {load} mov ebp, esp                          # 0042ae0b
    mov ax, word ptr [0x5b160a]                  # 0042ae0d
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042ae13
    mov word ptr [0x5b160a], ax                  # 0042ae17
    movsx ecx, word ptr [0x5b160a]               # 0042ae1d
    test ecx, ecx                                # 0042ae24
    jl.d8 L_0042ae54                             # 0042ae26
    # block 0x0042ae28: entered by fall-through of jl at 0x0042ae26, 3 instruction(s), ends with jge to 0x0042ae54 (forward)
    movsx edx, word ptr [0x5b160a]               # 0042ae28
    cmp edx, 0x1                                 # 0042ae2f
    jge.d8 L_0042ae54                            # 0042ae32
    # block 0x0042ae34: entered by fall-through of jge at 0x0042ae32, 4 instruction(s), ends with forward jump to 0x0042ae71
    mov dword ptr [0x5d1889], 0x0                # 0042ae34
    mov dword ptr [0x5d18d3], 0x1                # 0042ae3e
    mov dword ptr [0x5b1606], 0x0                # 0042ae48
    jmp.d8 L_0042ae71                            # 0042ae52
L_0042ae54:
    # block 0x0042ae54: entered by jl at 0x0042ae26; jge at 0x0042ae32, 3 instruction(s), falls into the block at 0x0042ae71
    mov dword ptr [0x5d18d3], 0x0                # 0042ae54
    mov word ptr [0x5b160a], 0xffff              # 0042ae5e
    mov dword ptr [0x5b1602], 0x0                # 0042ae67
L_0042ae71:
    # block 0x0042ae71: entered by jmp at 0x0042ae52, 2 instruction(s), ends with ret
    pop ebp                                      # 0042ae71
    ret                                          # 0042ae72

