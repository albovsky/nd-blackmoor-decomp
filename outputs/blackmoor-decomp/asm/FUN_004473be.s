# FUN_004473be
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004473be
# extent:       0x004473be-0x00447408 (74 code bytes)
# span:         0x004473be-0x00447418 (code 74, tables 16, padding 0)
# sha256:       39bd0d9fbe3d092df092e3655418532289e1eff1b132ff1f233b1653a12096ee
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         session_exit_controller
# naming:       native port src/session_exit.c:session_exit_controller (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-15); the summary is the acceptance note
# summary:      Stages 0 to 3 and above-3 match. Oracle calls the original for stages 0-4 and 9, states 1-4, types 0-5 and compares effects and cells, 0 mismatches. 0x44753b loop is a host seam; native stops on host failure.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_2d
# callees:      calls FUN_00447418, FUN_004474cf, FUN_0044753b, FUN_004477b2
# track-n:      outputs/blackmoor-decomp/src/session_exit.c:session_exit_controller (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_2d, 0x2d  # offset +0x2d

# --- external targets -----------------------------------------------
.set FUN_00447418, .text + (0x00447418 - 0x401000)
.set FUN_004474cf, .text + (0x004474cf - 0x401000)
.set FUN_0044753b, .text + (0x0044753b - 0x401000)
.set FUN_004477b2, .text + (0x004477b2 - 0x401000)

.org 0x004473be - 0x401000
.globl FUN_004473be
FUN_004473be:
    # block 0x004473be: entry, 9 instruction(s), ends with ja to 0x00447404 (forward)
    push ebp                                     # 004473be
    {load} mov ebp, esp                          # 004473bf
    sub esp, 0x8                                 # 004473c1
    mov dword ptr [ebp - local_4], ecx           # 004473c4
    mov eax, dword ptr [ebp - local_4]           # 004473c7
    mov ecx, dword ptr [eax + field_2d]          # 004473ca
    mov dword ptr [ebp - local_8], ecx           # 004473cd
    cmp dword ptr [ebp - local_8], 0x3           # 004473d0
    ja.d8 L_00447404                             # 004473d4
    # block 0x004473d6: entered by fall-through of ja at 0x004473d4, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x447408]
    mov edx, dword ptr [ebp - local_8]           # 004473d6
    jmp dword ptr [4*edx + SWTAB_00447408_VA]    # 004473d9
L_004473e0:
    # block 0x004473e0: entered by switch case, 3 instruction(s), calls FUN_00447418, ends with forward jump to 0x00447404
    mov ecx, dword ptr [ebp - local_4]           # 004473e0
    call FUN_00447418                            # 004473e3
    jmp.d8 L_00447404                            # 004473e8
L_004473ea:
    # block 0x004473ea: entered by switch case, 2 instruction(s), calls FUN_004474cf, falls into the block at 0x004473f2
    mov ecx, dword ptr [ebp - local_4]           # 004473ea
    call FUN_004474cf                            # 004473ed
L_004473f2:
    # block 0x004473f2: entered by switch case, 3 instruction(s), calls FUN_0044753b, ends with forward jump to 0x00447404
    mov ecx, dword ptr [ebp - local_4]           # 004473f2
    call FUN_0044753b                            # 004473f5
    jmp.d8 L_00447404                            # 004473fa
L_004473fc:
    # block 0x004473fc: entered by switch case, 2 instruction(s), calls FUN_004477b2, falls into the block at 0x00447404
    mov ecx, dword ptr [ebp - local_4]           # 004473fc
    call FUN_004477b2                            # 004473ff
L_00447404:
    # block 0x00447404: entered by ja at 0x004473d4; jmp at 0x004473e8; jmp at 0x004473fa, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00447404
    pop ebp                                      # 00447406
    ret                                          # 00447407

# --- data items (not part of the function) -------------------------
.org 0x00447408 - 0x401000
SWTAB_00447408:  # 4 case address(es)
    .long L_004473e0 - .text + 0x401000
    .long L_004473ea - .text + 0x401000
    .long L_004473f2 - .text + 0x401000
    .long L_004473fc - .text + 0x401000
.set SWTAB_00447408_VA, SWTAB_00447408 - .text + 0x401000

