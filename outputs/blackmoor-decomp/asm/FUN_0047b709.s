# FUN_0047b709
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b709
# extent:       0x0047b709-0x0047b767 (94 code bytes)
# span:         0x0047b709-0x0047b767 (code 94, tables 0, padding 0)
# sha256:       8dfe643b75b117c5993452baa0a327c9fcde6f6f39a73768e2266de0a82789a0
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047b709
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0047b709 - 0x401000
.globl FUN_0047b709
FUN_0047b709:
    # block 0x0047b709: entry, 20 instruction(s), ends with ret 0x4
    push ebp                                     # 0047b709
    {load} mov ebp, esp                          # 0047b70a
    push ecx                                     # 0047b70c
    mov dword ptr [ebp - local_4], ecx           # 0047b70d
    movsx eax, word ptr [ebp + arg_8]            # 0047b710
    mov dword ptr [0x5c39e5], eax                # 0047b714
    mov dword ptr [0x5b44f0], 0x0                # 0047b719
    mov dword ptr [0x5b44f4], 0x1                # 0047b723
    mov ecx, dword ptr [0x5d0377]                # 0047b72d
    mov dword ptr [0x5d162d], ecx                # 0047b733
    mov edx, dword ptr [0x5b44f0]                # 0047b739
    shl edx, 0x5                                 # 0047b73f
    mov eax, dword ptr [0x5b44f4]                # 0047b742
    shl eax, 0x4                                 # 0047b747
    lea ecx, [edx + eax + 0x5b160c]              # 0047b74a
    mov dword ptr [0x5d1631], ecx                # 0047b751
    mov dword ptr [0x5d1639], 0x1                # 0047b757
    {load} mov esp, ebp                          # 0047b761
    pop ebp                                      # 0047b763
    ret 0x4                                      # 0047b764

