# FUN_00457071
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457071
# extent:       0x00457071-0x004570c4 (83 code bytes)
# span:         0x00457071-0x004570c4 (code 83, tables 0, padding 0)
# sha256:       30748eb7ef793428db6af59428950758a15de637f1dd23b51ed9038744519c57
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00457071
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c; [edx + n] field_4, field_8, field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x00457071 - 0x401000
.globl FUN_00457071
FUN_00457071:
    # block 0x00457071: entry, 27 instruction(s), ends with ret 0x8
    push ebp                                     # 00457071
    {load} mov ebp, esp                          # 00457072
    push ecx                                     # 00457074
    mov dword ptr [ebp - local_4], ecx           # 00457075
    mov eax, dword ptr [ebp + arg_8]             # 00457078
    mov ecx, dword ptr [eax + field_4]           # 0045707b
    add ecx, dword ptr [0x58318a]                # 0045707e
    mov edx, dword ptr [ebp + arg_c]             # 00457084
    mov dword ptr [edx + field_4], ecx           # 00457087
    mov eax, dword ptr [ebp + arg_8]             # 0045708a
    mov ecx, dword ptr [eax + field_c]           # 0045708d
    add ecx, dword ptr [0x58318a]                # 00457090
    mov edx, dword ptr [ebp + arg_c]             # 00457096
    mov dword ptr [edx + field_c], ecx           # 00457099
    mov eax, dword ptr [ebp + arg_8]             # 0045709c
    mov ecx, dword ptr [eax]                     # 0045709f
    add ecx, dword ptr [0x583186]                # 004570a1
    mov edx, dword ptr [ebp + arg_c]             # 004570a7
    mov dword ptr [edx], ecx                     # 004570aa
    mov eax, dword ptr [ebp + arg_8]             # 004570ac
    mov ecx, dword ptr [eax + field_8]           # 004570af
    add ecx, dword ptr [0x583186]                # 004570b2
    mov edx, dword ptr [ebp + arg_c]             # 004570b8
    mov dword ptr [edx + field_8], ecx           # 004570bb
    {load} mov esp, ebp                          # 004570be
    pop ebp                                      # 004570c0
    ret 0x8                                      # 004570c1

