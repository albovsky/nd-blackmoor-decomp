# FUN_004474cf
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004474cf
# extent:       0x004474cf-0x0044753b (108 code bytes)
# span:         0x004474cf-0x0044753b (code 108, tables 0, padding 0)
# sha256:       7ee53eea9f519dc4ccbaa2e25ac0a0de41f22822cea786caed8bc54fc430d7c1
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004474cf
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_49; [ecx + n] field_2d, field_35; [edx + n] field_2d, field_35
# callees:      calls FUN_00447ac7
# track-n:      outputs/blackmoor-decomp/src/session_exit.c:controller_capture_destination (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 36 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_2d, 0x2d  # offset +0x2d
.equ field_35, 0x35  # offset +0x35
.equ field_49, 0x49  # offset +0x49

# --- external targets -----------------------------------------------
.set FUN_00447ac7, .text + (0x00447ac7 - 0x401000)

.org 0x004474cf - 0x401000
.globl FUN_004474cf
FUN_004474cf:
    # block 0x004474cf: entry, 9 instruction(s), ends with je to 0x004474ef (forward)
    push ebp                                     # 004474cf
    {load} mov ebp, esp                          # 004474d0
    sub esp, 0x8                                 # 004474d2
    mov dword ptr [ebp - local_4], ecx           # 004474d5
    mov eax, dword ptr [ebp - local_4]           # 004474d8
    mov cl, byte ptr [eax + field_49]            # 004474db
    mov byte ptr [ebp - local_8], cl             # 004474de
    cmp byte ptr [ebp - local_8], 0x2            # 004474e1
    je.d8 L_004474ef                             # 004474e5
    # block 0x004474e7: entered by fall-through of je at 0x004474e5, 2 instruction(s), ends with je to 0x00447511 (forward)
    cmp byte ptr [ebp - local_8], 0x3            # 004474e7
    je.d8 L_00447511                             # 004474eb
    # block 0x004474ed: entered by fall-through of je at 0x004474eb, 1 instruction(s), ends with forward jump to 0x00447537
    jmp.d8 L_00447537                            # 004474ed
L_004474ef:
    # block 0x004474ef: entered by je at 0x004474e5, 10 instruction(s), calls FUN_00447ac7, ends with forward jump to 0x00447537
    mov edx, dword ptr [ebp - local_4]           # 004474ef
    mov eax, dword ptr [edx + field_35]          # 004474f2
    push eax                                     # 004474f5
    mov ecx, dword ptr [0x5cf665]                # 004474f6
    push ecx                                     # 004474fc
    mov ecx, dword ptr [ebp - local_4]           # 004474fd
    call FUN_00447ac7                            # 00447500
    mov edx, dword ptr [ebp - local_4]           # 00447505
    mov dword ptr [edx + field_2d], 0x2          # 00447508
    jmp.d8 L_00447537                            # 0044750f
L_00447511:
    # block 0x00447511: entered by je at 0x004474eb, 11 instruction(s), calls FUN_00447ac7, falls into the block at 0x00447537
    mov eax, dword ptr [ebp - local_4]           # 00447511
    mov byte ptr [eax + field_49], 0x2           # 00447514
    mov ecx, dword ptr [ebp - local_4]           # 00447518
    mov edx, dword ptr [ecx + field_35]          # 0044751b
    push edx                                     # 0044751e
    mov eax, dword ptr [0x5cf665]                # 0044751f
    push eax                                     # 00447524
    mov ecx, dword ptr [ebp - local_4]           # 00447525
    call FUN_00447ac7                            # 00447528
    mov ecx, dword ptr [ebp - local_4]           # 0044752d
    mov dword ptr [ecx + field_2d], 0x2          # 00447530
L_00447537:
    # block 0x00447537: entered by jmp at 0x004474ed; jmp at 0x0044750f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00447537
    pop ebp                                      # 00447539
    ret                                          # 0044753a

