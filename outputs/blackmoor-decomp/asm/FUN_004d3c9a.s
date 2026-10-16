# FUN_004d3c9a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3c9a
# extent:       0x004d3c9a-0x004d3cba (32 code bytes)
# span:         0x004d3c9a-0x004d3cba (code 32, tables 0, padding 0)
# sha256:       f111b879458ee8358f9988d7bd6f9e4a07679c4e34ca42f5dcf92be2696aca40
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3c9a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004d3c9a - 0x401000
.globl FUN_004d3c9a
FUN_004d3c9a:
    # block 0x004d3c9a: entry, 8 instruction(s), ends with jne to 0x004d3cb6 (forward)
    push ebp                                     # 004d3c9a
    {load} mov ebp, esp                          # 004d3c9b
    push ecx                                     # 004d3c9d
    mov dword ptr [ebp - local_4], ecx           # 004d3c9e
    {load} xor eax, eax                          # 004d3ca1
    mov al, byte ptr [0x61c6ae]                  # 004d3ca3
    test eax, eax                                # 004d3ca8
    jne.d8 L_004d3cb6                            # 004d3caa
    # block 0x004d3cac: entered by fall-through of jne at 0x004d3caa, 1 instruction(s), falls into the block at 0x004d3cb6
    mov dword ptr [0x5d1c4b], 0x0                # 004d3cac
L_004d3cb6:
    # block 0x004d3cb6: entered by jne at 0x004d3caa, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d3cb6
    pop ebp                                      # 004d3cb8
    ret                                          # 004d3cb9

