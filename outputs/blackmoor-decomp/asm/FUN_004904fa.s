# FUN_004904fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004904fa
# extent:       0x004904fa-0x00490547 (77 code bytes)
# span:         0x004904fa-0x00490547 (code 77, tables 0, padding 0)
# sha256:       60737c134c4c5ce657ed114e77604b81cb555b558441af54d79c7d632485f0f0
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4904fa_construct_record
# naming:       native port src/original_methods_fl39f.c:m4904fa_construct_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Straight-line initialiser in the order of the original: 0x51d716(this) (thiscall, 0 arguments), then dword [this+0x0] = 0x52daf8, then dword [this+0x1f77] = 0x0. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_1f77; [edx + n] field_1f7b
# callees:      calls FUN_0051d716
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4904fa_construct_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 25 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1f77, 0x1f77  # offset +0x1f77
.equ field_1f7b, 0x1f7b  # offset +0x1f7b

# --- external targets -----------------------------------------------
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x004904fa - 0x401000
.globl FUN_004904fa
FUN_004904fa:
    # block 0x004904fa: entry, 25 instruction(s), calls FUN_0051d716, ends with ret
    push ebp                                     # 004904fa
    {load} mov ebp, esp                          # 004904fb
    push ecx                                     # 004904fd
    push edi                                     # 004904fe
    mov dword ptr [ebp - local_4], ecx           # 004904ff
    mov ecx, dword ptr [ebp - local_4]           # 00490502
    call FUN_0051d716                            # 00490505
    mov eax, dword ptr [ebp - local_4]           # 0049050a
    mov dword ptr [eax], 0x52daf8                # 0049050d
    mov ecx, dword ptr [ebp - local_4]           # 00490513
    mov dword ptr [ecx + field_1f77], 0x0        # 00490516
    mov edx, dword ptr [ebp - local_4]           # 00490520
    mov dword ptr [edx + field_1f7b], 0x1        # 00490523
    mov ecx, 0x7b2                               # 0049052d
    {load} xor eax, eax                          # 00490532
    mov edi, dword ptr [ebp - local_4]           # 00490534
    add edi, 0x20                                # 00490537
    rep stosd dword ptr es:[edi], eax            # 0049053a
    stosw word ptr es:[edi], ax                  # 0049053c
    stosb byte ptr es:[edi], al                  # 0049053e
    mov eax, dword ptr [ebp - local_4]           # 0049053f
    pop edi                                      # 00490542
    {load} mov esp, ebp                          # 00490543
    pop ebp                                      # 00490545
    ret                                          # 00490546

