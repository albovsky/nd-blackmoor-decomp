# FUN_00461740
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00461740
# extent:       0x00461740-0x004617a7 (103 code bytes)
# span:         0x00461740-0x004617a7 (code 103, tables 0, padding 0)
# sha256:       268416e390094af881031283ac5ce752a520b30f530c55b9ed5b9997f5f4df50
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m461740_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m461740_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x5f); returns 0x4617b7(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004617b7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m461740_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_004617b7, .text + (0x004617b7 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00461740 - 0x401000
.globl FUN_00461740
FUN_00461740:
    # block 0x00461740: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00461782 (forward)
    push ebp                                     # 00461740
    {load} mov ebp, esp                          # 00461741
    push -0x1                                    # 00461743
    push 0x52811a                                # 00461745
    mov eax, dword ptr fs:[0x0]                  # 0046174a
    push eax                                     # 00461750
    mov dword ptr fs:[0x0], esp                  # 00461751
    sub esp, 0xc                                 # 00461758
    push 0x5f                                    # 0046175b
    call FUN_0051dc43                            # 0046175d
    add esp, 0x4                                 # 00461762
    mov dword ptr [ebp - local_14], eax          # 00461765
    mov dword ptr [ebp - local_4], 0x0           # 00461768
    cmp dword ptr [ebp - local_14], 0x0          # 0046176f
    je.d8 L_00461782                             # 00461773
    # block 0x00461775: entered by fall-through of je at 0x00461773, 4 instruction(s), calls FUN_004617b7, ends with forward jump to 0x00461789
    mov ecx, dword ptr [ebp - local_14]          # 00461775
    call FUN_004617b7                            # 00461778
    mov dword ptr [ebp - local_18], eax          # 0046177d
    jmp.d8 L_00461789                            # 00461780
L_00461782:
    # block 0x00461782: entered by je at 0x00461773, 1 instruction(s), falls into the block at 0x00461789
    mov dword ptr [ebp - local_18], 0x0          # 00461782
L_00461789:
    # block 0x00461789: entered by jmp at 0x00461780, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00461789
    mov dword ptr [ebp - local_10], eax          # 0046178c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0046178f
    mov eax, dword ptr [ebp - local_10]          # 00461796
    mov ecx, dword ptr [ebp - local_c]           # 00461799
    mov dword ptr fs:[0x0], ecx                  # 0046179c
    {load} mov esp, ebp                          # 004617a3
    pop ebp                                      # 004617a5
    ret                                          # 004617a6

