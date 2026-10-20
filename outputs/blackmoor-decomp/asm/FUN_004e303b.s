# FUN_004e303b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e303b
# extent:       0x004e303b-0x004e3093 (88 code bytes)
# span:         0x004e303b-0x004e3093 (code 88, tables 0, padding 0)
# sha256:       a7de591ad691159fcfed801c68abda65b4bcda49eb94976b502251550933babb
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e303b_close
# naming:       native port src/original_methods_fl17.c:m4e303b_close (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with m4e303b_close; see its leading comment for the stores and calls. Direct test compares the whole object and the ordered host calls; the recorded oracle window executes all 88 bytes.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_6b2
# callees:      calls FUN_004edb97, FUN_004e2faa, FUN_004d36ed, FUN_004c2dfb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl17.c:m4e303b_close (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_6b2, 0x6b2  # offset +0x6b2

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d36ed, .text + (0x004d36ed - 0x401000)
.set FUN_004e2faa, .text + (0x004e2faa - 0x401000)
.set FUN_004edb97, .text + (0x004edb97 - 0x401000)

.org 0x004e303b - 0x401000
.globl FUN_004e303b
FUN_004e303b:
    # block 0x004e303b: entry, 15 instruction(s), calls FUN_004edb97, FUN_004e2faa, FUN_004d36ed, ends with je to 0x004e308f (forward)
    push ebp                                     # 004e303b
    {load} mov ebp, esp                          # 004e303c
    push ecx                                     # 004e303e
    mov dword ptr [ebp - local_4], ecx           # 004e303f
    mov ecx, dword ptr [ebp - local_4]           # 004e3042
    call FUN_004edb97                            # 004e3045
    mov ecx, dword ptr [ebp - local_4]           # 004e304a
    call FUN_004e2faa                            # 004e304d
    mov dword ptr [0x583204], 0x0                # 004e3052
    call FUN_004d36ed                            # 004e305c
    mov dword ptr [0x5bb22a], 0x0                # 004e3061
    mov eax, dword ptr [ebp - local_4]           # 004e306b
    mov word ptr [eax + field_6b2], 0x270f       # 004e306e
    cmp dword ptr [0x5d039f], 0x0                # 004e3077
    je.d8 L_004e308f                             # 004e307e
    # block 0x004e3080: entered by fall-through of je at 0x004e307e, 3 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e308f
    push 0x5d039f                                # 004e3080
    mov ecx, 0x5cf659                            # 004e3085
    call FUN_004c2dfb                            # 004e308a
L_004e308f:
    # block 0x004e308f: entered by je at 0x004e307e, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e308f
    pop ebp                                      # 004e3091
    ret                                          # 004e3092

