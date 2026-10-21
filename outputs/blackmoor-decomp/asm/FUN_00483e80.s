# FUN_00483e80
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00483e80
# extent:       0x00483e80-0x00483eea (106 code bytes)
# span:         0x00483e80-0x00483eea (code 106, tables 0, padding 0)
# sha256:       a0fbb8e8aff62c7ebfad7be3cc9292a8b5e62d14e56cdfa9d2de86b8c8bcce1c
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m483e80_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m483e80_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0xc3b); returns 0x483efa(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00483efa
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m483e80_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_00483efa, .text + (0x00483efa - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00483e80 - 0x401000
.globl FUN_00483e80
FUN_00483e80:
    # block 0x00483e80: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00483ec5 (forward)
    push ebp                                     # 00483e80
    {load} mov ebp, esp                          # 00483e81
    push -0x1                                    # 00483e83
    push 0x5283da                                # 00483e85
    mov eax, dword ptr fs:[0x0]                  # 00483e8a
    push eax                                     # 00483e90
    mov dword ptr fs:[0x0], esp                  # 00483e91
    sub esp, 0xc                                 # 00483e98
    push 0xc3b                                   # 00483e9b
    call FUN_0051dc43                            # 00483ea0
    add esp, 0x4                                 # 00483ea5
    mov dword ptr [ebp - local_14], eax          # 00483ea8
    mov dword ptr [ebp - local_4], 0x0           # 00483eab
    cmp dword ptr [ebp - local_14], 0x0          # 00483eb2
    je.d8 L_00483ec5                             # 00483eb6
    # block 0x00483eb8: entered by fall-through of je at 0x00483eb6, 4 instruction(s), calls FUN_00483efa, ends with forward jump to 0x00483ecc
    mov ecx, dword ptr [ebp - local_14]          # 00483eb8
    call FUN_00483efa                            # 00483ebb
    mov dword ptr [ebp - local_18], eax          # 00483ec0
    jmp.d8 L_00483ecc                            # 00483ec3
L_00483ec5:
    # block 0x00483ec5: entered by je at 0x00483eb6, 1 instruction(s), falls into the block at 0x00483ecc
    mov dword ptr [ebp - local_18], 0x0          # 00483ec5
L_00483ecc:
    # block 0x00483ecc: entered by jmp at 0x00483ec3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00483ecc
    mov dword ptr [ebp - local_10], eax          # 00483ecf
    mov dword ptr [ebp - local_4], 0xffffffff    # 00483ed2
    mov eax, dword ptr [ebp - local_10]          # 00483ed9
    mov ecx, dword ptr [ebp - local_c]           # 00483edc
    mov dword ptr fs:[0x0], ecx                  # 00483edf
    {load} mov esp, ebp                          # 00483ee6
    pop ebp                                      # 00483ee8
    ret                                          # 00483ee9

