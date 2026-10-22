# FUN_0042acad
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042acad
# extent:       0x0042acad-0x0042ad27 (122 code bytes)
# span:         0x0042acad-0x0042ad27 (code 122, tables 0, padding 0)
# sha256:       72c80b7796c86654380dc5b7ba5d5012942b44b19bb2e4a0d7c6208ed9de587d
# evidence:     ev_cf85def1568380b2ebf44119180440e99f852bed065d4e3cd26944aa51b63fd1
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42acad_lifted
# naming:       native port src/original_methods_fl40.c:m42acad_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 23/23 instructions executed, 4/4 conditional-jump directions taken, callees as recording stubs.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m42acad_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0042acad - 0x401000
.globl FUN_0042acad
FUN_0042acad:
    # block 0x0042acad: entry, 8 instruction(s), ends with jl to 0x0042acf7 (forward)
    push ebp                                     # 0042acad
    {load} mov ebp, esp                          # 0042acae
    mov ax, word ptr [0x5b15d4]                  # 0042acb0
    .insn 0x66, 0x05, 0x0001{:u16}               # 0042acb6
    mov word ptr [0x5b15d4], ax                  # 0042acba
    movsx ecx, word ptr [0x5b15d4]               # 0042acc0
    test ecx, ecx                                # 0042acc7
    jl.d8 L_0042acf7                             # 0042acc9
    # block 0x0042accb: entered by fall-through of jl at 0x0042acc9, 3 instruction(s), ends with jge to 0x0042acf7 (forward)
    movsx edx, word ptr [0x5b15d4]               # 0042accb
    cmp edx, 0x1                                 # 0042acd2
    jge.d8 L_0042acf7                            # 0042acd5
    # block 0x0042acd7: entered by fall-through of jge at 0x0042acd5, 4 instruction(s), ends with forward jump to 0x0042ad25
    mov dword ptr [0x5d17f5], 0x0                # 0042acd7
    mov dword ptr [0x5d183f], 0x1                # 0042ace1
    mov dword ptr [0x5b15d6], 0x0                # 0042aceb
    jmp.d8 L_0042ad25                            # 0042acf5
L_0042acf7:
    # block 0x0042acf7: entered by jl at 0x0042acc9; jge at 0x0042acd5, 6 instruction(s), falls into the block at 0x0042ad25
    mov dword ptr [0x5d183f], 0x0                # 0042acf7
    mov word ptr [0x5b15d4], 0xffff              # 0042ad01
    mov dword ptr [0x5b15c8], 0x0                # 0042ad0a
    movsx eax, word ptr [ebp + arg_8]            # 0042ad14
    imul eax, eax, 0x8d                          # 0042ad18
    mov byte ptr [eax + 0x5bb625], 0x1           # 0042ad1e
L_0042ad25:
    # block 0x0042ad25: entered by jmp at 0x0042acf5, 2 instruction(s), ends with ret
    pop ebp                                      # 0042ad25
    ret                                          # 0042ad26

