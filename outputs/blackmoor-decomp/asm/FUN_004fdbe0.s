# FUN_004fdbe0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fdbe0
# extent:       0x004fdbe0-0x004fdc00 (32 code bytes)
# span:         0x004fdbe0-0x004fdc00 (code 32, tables 0, padding 0)
# sha256:       642b4c90dc111df771daf7f586a6888753cacb8e46e131942d06b0812a5bbe48
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_004fdb90 (+0x50)
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fdbe0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_10
# callees:      calls FUN_0050ce2b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050ce2b, .text + (0x0050ce2b - 0x401000)

.org 0x004fdbe0 - 0x401000
.globl FUN_004fdbe0
FUN_004fdbe0:
    # block 0x004fdbe0: entry, 3 instruction(s), ends with jne to 0x004fdbec (forward)
    mov eax, dword ptr [esp + stk_4]             # 004fdbe0
    test eax, eax                                # 004fdbe4
    jne.d8 L_004fdbec                            # 004fdbe6
    # block 0x004fdbe8: entered by fall-through of jne at 0x004fdbe6, 2 instruction(s), ends with ret
    or eax, -0x1                                 # 004fdbe8
    ret                                          # 004fdbeb
L_004fdbec:
    # block 0x004fdbec: entered by jne at 0x004fdbe6, 8 instruction(s), calls FUN_0050ce2b, ends with ret
    mov ecx, dword ptr [esp + stk_10]            # 004fdbec
    mov edx, dword ptr [esp + stk_8]             # 004fdbf0
    push ecx                                     # 004fdbf4
    push edx                                     # 004fdbf5
    push eax                                     # 004fdbf6
    call FUN_0050ce2b                            # 004fdbf7
    add esp, 0xc                                 # 004fdbfc
    ret                                          # 004fdbff

