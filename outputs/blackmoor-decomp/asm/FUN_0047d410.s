# FUN_0047d410
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047d410
# extent:       0x0047d410-0x0047d477 (103 code bytes)
# span:         0x0047d410-0x0047d477 (code 103, tables 0, padding 0)
# sha256:       180e339f26a8a5d6939a28a41399ca25118cdd78f9df742753299b8b850caaf6
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m47d410_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m47d410_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x58); returns 0x47d487(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0047d487
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m47d410_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_0047d487, .text + (0x0047d487 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0047d410 - 0x401000
.globl FUN_0047d410
FUN_0047d410:
    # block 0x0047d410: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0047d452 (forward)
    push ebp                                     # 0047d410
    {load} mov ebp, esp                          # 0047d411
    push -0x1                                    # 0047d413
    push 0x52832a                                # 0047d415
    mov eax, dword ptr fs:[0x0]                  # 0047d41a
    push eax                                     # 0047d420
    mov dword ptr fs:[0x0], esp                  # 0047d421
    sub esp, 0xc                                 # 0047d428
    push 0x58                                    # 0047d42b
    call FUN_0051dc43                            # 0047d42d
    add esp, 0x4                                 # 0047d432
    mov dword ptr [ebp - local_14], eax          # 0047d435
    mov dword ptr [ebp - local_4], 0x0           # 0047d438
    cmp dword ptr [ebp - local_14], 0x0          # 0047d43f
    je.d8 L_0047d452                             # 0047d443
    # block 0x0047d445: entered by fall-through of je at 0x0047d443, 4 instruction(s), calls FUN_0047d487, ends with forward jump to 0x0047d459
    mov ecx, dword ptr [ebp - local_14]          # 0047d445
    call FUN_0047d487                            # 0047d448
    mov dword ptr [ebp - local_18], eax          # 0047d44d
    jmp.d8 L_0047d459                            # 0047d450
L_0047d452:
    # block 0x0047d452: entered by je at 0x0047d443, 1 instruction(s), falls into the block at 0x0047d459
    mov dword ptr [ebp - local_18], 0x0          # 0047d452
L_0047d459:
    # block 0x0047d459: entered by jmp at 0x0047d450, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0047d459
    mov dword ptr [ebp - local_10], eax          # 0047d45c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0047d45f
    mov eax, dword ptr [ebp - local_10]          # 0047d466
    mov ecx, dword ptr [ebp - local_c]           # 0047d469
    mov dword ptr fs:[0x0], ecx                  # 0047d46c
    {load} mov esp, ebp                          # 0047d473
    pop ebp                                      # 0047d475
    ret                                          # 0047d476

