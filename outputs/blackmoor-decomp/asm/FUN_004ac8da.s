# FUN_004ac8da
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac8da
# extent:       0x004ac8da-0x004ac97d (163 code bytes)
# span:         0x004ac8da-0x004ac97d (code 163, tables 0, padding 0)
# sha256:       dc0f6d4aaba44092c6d349487c7cbb6fd1366117a999e2de013aafef25165417
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4ac8da_init_record
# naming:       native port src/original_methods_fl39f.c:m4ac8da_init_record (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Straight-line initialiser in the order of the original: word [this+0x1e] = 0xffff, then word [this+0x1c] = 0xffff, then dword [this+0xc1b] = 0x0, then dword [this+0xc17] = 0x0. All instructions run; both jump directions taken.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_20, field_6a, field_c17; [ecx + n] field_1c, field_24, field_c1f, field_c35; [edx + n] field_46, field_c1b, field_c24
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39f.c:m4ac8da_init_record (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 42 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_24, 0x24  # offset +0x24
.equ field_46, 0x46  # offset +0x46
.equ field_6a, 0x6a  # offset +0x6a
.equ field_c17, 0xc17  # offset +0xc17
.equ field_c1b, 0xc1b  # offset +0xc1b
.equ field_c1f, 0xc1f  # offset +0xc1f
.equ field_c24, 0xc24  # offset +0xc24
.equ field_c35, 0xc35  # offset +0xc35

# --- external targets -----------------------------------------------

.org 0x004ac8da - 0x401000
.globl FUN_004ac8da
FUN_004ac8da:
    # block 0x004ac8da: entry, 42 instruction(s), ends with ret
    push ebp                                     # 004ac8da
    {load} mov ebp, esp                          # 004ac8db
    push ecx                                     # 004ac8dd
    push edi                                     # 004ac8de
    mov dword ptr [ebp - local_4], ecx           # 004ac8df
    mov eax, dword ptr [ebp - local_4]           # 004ac8e2
    mov word ptr [eax + field_1e], 0xffff        # 004ac8e5
    mov ecx, dword ptr [ebp - local_4]           # 004ac8eb
    mov word ptr [ecx + field_1c], 0xffff        # 004ac8ee
    mov edx, dword ptr [ebp - local_4]           # 004ac8f4
    mov dword ptr [edx + field_c1b], 0x0         # 004ac8f7
    mov eax, dword ptr [ebp - local_4]           # 004ac901
    mov dword ptr [eax + field_c17], 0x0         # 004ac904
    mov ecx, dword ptr [ebp - local_4]           # 004ac90e
    mov byte ptr [ecx + field_c1f], 0x0          # 004ac911
    mov edx, dword ptr [ebp - local_4]           # 004ac918
    mov byte ptr [edx + field_c24], 0x0          # 004ac91b
    mov eax, dword ptr [ebp - local_4]           # 004ac922
    mov dword ptr [eax + field_20], 0x0          # 004ac925
    mov ecx, dword ptr [ebp - local_4]           # 004ac92c
    mov word ptr [ecx + field_24], 0xffff        # 004ac92f
    mov edx, dword ptr [ebp - local_4]           # 004ac935
    mov dword ptr [edx + field_46], 0x0          # 004ac938
    mov eax, dword ptr [ebp - local_4]           # 004ac93f
    mov dword ptr [eax + field_6a], 0x0          # 004ac942
    mov ecx, dword ptr [ebp - local_4]           # 004ac949
    mov dword ptr [ecx + field_c35], 0x0         # 004ac94c
    mov ecx, 0x2ea                               # 004ac956
    {load} xor eax, eax                          # 004ac95b
    mov edi, dword ptr [ebp - local_4]           # 004ac95d
    add edi, 0x6e                                # 004ac960
    rep stosd dword ptr es:[edi], eax            # 004ac963
    stosb byte ptr es:[edi], al                  # 004ac965
    mov ecx, 0xc                                 # 004ac966
    {load} xor eax, eax                          # 004ac96b
    mov edi, dword ptr [ebp - local_4]           # 004ac96d
    add edi, 0xe59                               # 004ac970
    rep stosd dword ptr es:[edi], eax            # 004ac976
    pop edi                                      # 004ac978
    {load} mov esp, ebp                          # 004ac979
    pop ebp                                      # 004ac97b
    ret                                          # 004ac97c

