# FUN_004d3b95
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3b95
# extent:       0x004d3b95-0x004d3bef (90 code bytes)
# span:         0x004d3b95-0x004d3bef (code 90, tables 0, padding 0)
# sha256:       ac630d55b02795eb3f4424a5b442a2806bf1579be890cea4cbca76954b1e5a98
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3b95_lifted
# naming:       native port src/original_methods_fl39d.c:m4d3b95_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the instruction stream by the FL-39 lifter (11 recipes, original bytes run under Unicorn; golden vectors in the direct test); Not original source structure. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_444, field_45e; [ecx + n] field_43e, field_440; [edx + n] field_1c
# callees:      calls FUN_004d3bef
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4d3b95_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_43e, 0x43e  # offset +0x43e
.equ field_440, 0x440  # offset +0x440
.equ field_444, 0x444  # offset +0x444
.equ field_45e, 0x45e  # offset +0x45e

# --- external targets -----------------------------------------------
.set FUN_004d3bef, .text + (0x004d3bef - 0x401000)

.org 0x004d3b95 - 0x401000
.globl FUN_004d3b95
FUN_004d3b95:
    # block 0x004d3b95: entry, 20 instruction(s), calls FUN_004d3bef, ends with ret
    push ebp                                     # 004d3b95
    {load} mov ebp, esp                          # 004d3b96
    push ecx                                     # 004d3b98
    mov dword ptr [ebp - local_4], ecx           # 004d3b99
    mov eax, dword ptr [ebp - local_4]           # 004d3b9c
    mov dword ptr [eax + field_444], 0x1         # 004d3b9f
    mov ecx, dword ptr [ebp - local_4]           # 004d3ba9
    mov word ptr [ecx + field_43e], 0x0          # 004d3bac
    mov edx, dword ptr [ebp - local_4]           # 004d3bb5
    mov dword ptr [edx + field_1c], 0x0          # 004d3bb8
    mov eax, dword ptr [ebp - local_4]           # 004d3bbf
    mov dword ptr [eax + field_45e], 0x0         # 004d3bc2
    mov dword ptr [0x5d1c4b], 0x0                # 004d3bcc
    mov ecx, dword ptr [ebp - local_4]           # 004d3bd6
    mov dword ptr [ecx + field_440], 0x0         # 004d3bd9
    mov ecx, dword ptr [ebp - local_4]           # 004d3be3
    call FUN_004d3bef                            # 004d3be6
    {load} mov esp, ebp                          # 004d3beb
    pop ebp                                      # 004d3bed
    ret                                          # 004d3bee

