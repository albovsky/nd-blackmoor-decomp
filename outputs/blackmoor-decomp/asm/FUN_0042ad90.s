# FUN_0042ad90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042ad90
# extent:       0x0042ad90-0x0042ae0a (122 code bytes)
# span:         0x0042ad90-0x0042ae0a (code 122, tables 0, padding 0)
# sha256:       030a3440b7f83e5118fbda38a0cde1007a0fa3b1dd0582ea2de72adc3464854f
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42ad90_lifted
# naming:       native port src/original_methods_fl40.c:m42ad90_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 23/23 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m42ad90_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0042ad90 - 0x401000
.globl FUN_0042ad90
FUN_0042ad90:
    # block 0x0042ad90: entry, 8 instruction(s), ends with jl to 0x0042adda (forward)
    push ebp                                     # 0042ad90
    {load} mov ebp, esp                          # 0042ad91
    mov ax, word ptr [0x5b160a]                  # 0042ad93
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042ad99
    mov word ptr [0x5b160a], ax                  # 0042ad9d
    movsx ecx, word ptr [0x5b160a]               # 0042ada3
    test ecx, ecx                                # 0042adaa
    jl.d8 L_0042adda                             # 0042adac
    # block 0x0042adae: entered by fall-through of jl at 0x0042adac, 3 instruction(s), ends with jge to 0x0042adda (forward)
    movsx edx, word ptr [0x5b160a]               # 0042adae
    cmp edx, 0x1                                 # 0042adb5
    jge.d8 L_0042adda                            # 0042adb8
    # block 0x0042adba: entered by fall-through of jge at 0x0042adb8, 4 instruction(s), ends with forward jump to 0x0042ae08
    mov dword ptr [0x5d1889], 0x0                # 0042adba
    mov dword ptr [0x5d18d3], 0x1                # 0042adc4
    mov dword ptr [0x5b1606], 0x0                # 0042adce
    jmp.d8 L_0042ae08                            # 0042add8
L_0042adda:
    # block 0x0042adda: entered by jl at 0x0042adac; jge at 0x0042adb8, 6 instruction(s), falls into the block at 0x0042ae08
    mov dword ptr [0x5d18d3], 0x0                # 0042adda
    mov word ptr [0x5b160a], 0xffff              # 0042ade4
    mov dword ptr [0x5b1602], 0x0                # 0042aded
    movsx eax, word ptr [ebp + arg_8]            # 0042adf7
    imul eax, eax, 0x8d                          # 0042adfb
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042ae01
L_0042ae08:
    # block 0x0042ae08: entered by jmp at 0x0042add8, 2 instruction(s), ends with ret
    pop ebp                                      # 0042ae08
    ret                                          # 0042ae09

