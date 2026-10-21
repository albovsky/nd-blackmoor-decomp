# FUN_004144c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004144c0
# extent:       0x004144c0-0x00414527 (103 code bytes)
# span:         0x004144c0-0x00414527 (code 103, tables 0, padding 0)
# sha256:       e9b56f85de321a12b30c326890085981f6c2f6fd63ffe1d32006ce90ba85ffd8
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4144c0_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m4144c0_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x28); returns 0x414537(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00414537
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m4144c0_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00414537, .text + (0x00414537 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004144c0 - 0x401000
.globl FUN_004144c0
FUN_004144c0:
    # block 0x004144c0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00414502 (forward)
    push ebp                                     # 004144c0
    {load} mov ebp, esp                          # 004144c1
    push -0x1                                    # 004144c3
    push 0x52728a                                # 004144c5
    mov eax, dword ptr fs:[0x0]                  # 004144ca
    push eax                                     # 004144d0
    mov dword ptr fs:[0x0], esp                  # 004144d1
    sub esp, 0xc                                 # 004144d8
    push 0x28                                    # 004144db
    call FUN_0051dc43                            # 004144dd
    add esp, 0x4                                 # 004144e2
    mov dword ptr [ebp - local_14], eax          # 004144e5
    mov dword ptr [ebp - local_4], 0x0           # 004144e8
    cmp dword ptr [ebp - local_14], 0x0          # 004144ef
    je.d8 L_00414502                             # 004144f3
    # block 0x004144f5: entered by fall-through of je at 0x004144f3, 4 instruction(s), calls FUN_00414537, ends with forward jump to 0x00414509
    mov ecx, dword ptr [ebp - local_14]          # 004144f5
    call FUN_00414537                            # 004144f8
    mov dword ptr [ebp - local_18], eax          # 004144fd
    jmp.d8 L_00414509                            # 00414500
L_00414502:
    # block 0x00414502: entered by je at 0x004144f3, 1 instruction(s), falls into the block at 0x00414509
    mov dword ptr [ebp - local_18], 0x0          # 00414502
L_00414509:
    # block 0x00414509: entered by jmp at 0x00414500, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00414509
    mov dword ptr [ebp - local_10], eax          # 0041450c
    mov dword ptr [ebp - local_4], 0xffffffff    # 0041450f
    mov eax, dword ptr [ebp - local_10]          # 00414516
    mov ecx, dword ptr [ebp - local_c]           # 00414519
    mov dword ptr fs:[0x0], ecx                  # 0041451c
    {load} mov esp, ebp                          # 00414523
    pop ebp                                      # 00414525
    ret                                          # 00414526

