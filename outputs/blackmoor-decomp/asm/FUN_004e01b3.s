# FUN_004e01b3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e01b3
# extent:       0x004e01b3-0x004e01fb (72 code bytes)
# span:         0x004e01b3-0x004e01fb (code 72, tables 0, padding 0)
# sha256:       406b985665e472c752e363792bf569cd0f3050d2723d6f5bff054b03058841c0
# evidence:     ev_9518a8d38812b37051c445b712839a110fe36a23c18959a042dc948141dd9772
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e01b3_lifted
# naming:       native port src/original_methods_fl39d.c:m4e01b3_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (14 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c5377, FUN_004e2b99, FUN_004eff03
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4e01b3_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_004c5377, .text + (0x004c5377 - 0x401000)
.set FUN_004e2b99, .text + (0x004e2b99 - 0x401000)
.set FUN_004eff03, .text + (0x004eff03 - 0x401000)

.org 0x004e01b3 - 0x401000
.globl FUN_004e01b3
FUN_004e01b3:
    # block 0x004e01b3: entry, 4 instruction(s), ends with je to 0x004e01f9 (forward)
    push ebp                                     # 004e01b3
    {load} mov ebp, esp                          # 004e01b4
    cmp dword ptr [0x5d02ab], 0x0                # 004e01b6
    je.d8 L_004e01f9                             # 004e01bd
    # block 0x004e01bf: entered by fall-through of je at 0x004e01bd, 13 instruction(s), calls FUN_004c5377, FUN_004e2b99, FUN_004eff03, falls into the block at 0x004e01f9
    push 0x55ba74                                # 004e01bf
    push 0x5833fd                                # 004e01c4
    push 0x5833ed                                # 004e01c9
    mov eax, dword ptr [0x5cf665]                # 004e01ce
    push eax                                     # 004e01d3
    mov ecx, dword ptr [0x5d03b7]                # 004e01d4
    push ecx                                     # 004e01da
    mov ecx, 0x5cf659                            # 004e01db
    call FUN_004c5377                            # 004e01e0
    mov ecx, 0x583624                            # 004e01e5
    call FUN_004e2b99                            # 004e01ea
    mov ecx, 0x5837b3                            # 004e01ef
    call FUN_004eff03                            # 004e01f4
L_004e01f9:
    # block 0x004e01f9: entered by je at 0x004e01bd, 2 instruction(s), ends with ret
    pop ebp                                      # 004e01f9
    ret                                          # 004e01fa

