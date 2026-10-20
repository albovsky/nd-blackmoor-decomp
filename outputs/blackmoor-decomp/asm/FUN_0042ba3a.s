# FUN_0042ba3a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042ba3a
# extent:       0x0042ba3a-0x0042babf (133 code bytes)
# span:         0x0042ba3a-0x0042babf (code 133, tables 0, padding 0)
# sha256:       066fe5bde9b51c2ee65aa884653d97880ac8d35003ef8ac2338e11d9da9eb909
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         action_core_finish_action
# naming:       native port src/action_core.c:action_core_finish_action (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the note is the acceptance note, a statement about the native port
# name-note:    Matches the pseudocode; the 0x423d33 dependency reset is only reported. Upgraded by FL-8: action_core_original_oracle.py, rerun and recorded executing every byte, compares it via the dispatcher.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00423d33
# track-n:      outputs/blackmoor-decomp/src/action_core.c:action_core_finish_action (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 32 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_00423d33, .text + (0x00423d33 - 0x401000)

.org 0x0042ba3a - 0x401000
.globl FUN_0042ba3a
FUN_0042ba3a:
    # block 0x0042ba3a: entry, 8 instruction(s), ends with jne to 0x0042ba67 (forward)
    push ebp                                     # 0042ba3a
    {load} mov ebp, esp                          # 0042ba3b
    movsx eax, word ptr [ebp + arg_8]            # 0042ba3d
    imul eax, eax, 0x8d                          # 0042ba41
    {load} xor ecx, ecx                          # 0042ba47
    mov cl, byte ptr [eax + 0x5bb5e4]            # 0042ba49
    cmp ecx, 0x1                                 # 0042ba4f
    jne.d8 L_0042ba67                            # 0042ba52
    # block 0x0042ba54: entered by fall-through of jne at 0x0042ba52, 4 instruction(s), ends with forward jump to 0x0042baa9
    movsx edx, word ptr [ebp + arg_8]            # 0042ba54
    imul edx, edx, 0x8d                          # 0042ba58
    mov byte ptr [edx + 0x5bb625], 0x1           # 0042ba5e
    jmp.d8 L_0042baa9                            # 0042ba65
L_0042ba67:
    # block 0x0042ba67: entered by jne at 0x0042ba52, 6 instruction(s), ends with jne to 0x0042baa9 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 0042ba67
    imul eax, eax, 0x8d                          # 0042ba6b
    {load} xor ecx, ecx                          # 0042ba71
    mov cl, byte ptr [eax + 0x5bb5e4]            # 0042ba73
    cmp ecx, 0x2                                 # 0042ba79
    jne.d8 L_0042baa9                            # 0042ba7c
    # block 0x0042ba7e: entered by fall-through of jne at 0x0042ba7c, 9 instruction(s), calls FUN_00423d33, falls into the block at 0x0042baa9
    movsx edx, word ptr [ebp + arg_8]            # 0042ba7e
    imul edx, edx, 0x8d                          # 0042ba82
    mov byte ptr [edx + 0x5bb625], 0x0           # 0042ba88
    movsx eax, word ptr [ebp + arg_8]            # 0042ba8f
    imul eax, eax, 0x8d                          # 0042ba93
    add eax, 0x5bb5e9                            # 0042ba99
    push eax                                     # 0042ba9e
    mov ecx, 0x63786d                            # 0042ba9f
    call FUN_00423d33                            # 0042baa4
L_0042baa9:
    # block 0x0042baa9: entered by jmp at 0x0042ba65; jne at 0x0042ba7c, 5 instruction(s), ends with ret
    movsx ecx, word ptr [ebp + arg_8]            # 0042baa9
    imul ecx, ecx, 0x8d                          # 0042baad
    mov dword ptr [ecx + 0x5bb632], 0x0          # 0042bab3
    pop ebp                                      # 0042babd
    ret                                          # 0042babe

