# FUN_0045504b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045504b
# extent:       0x0045504b-0x00455180 (309 code bytes)
# span:         0x0045504b-0x00455180 (code 309, tables 0, padding 0)
# sha256:       3e762af4c750f03796f573b3f3732dd80363516f034ff8da3c632fa1af45c9eb
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45504b_lifted
# naming:       native port src/original_methods_fl40.c:m45504b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 8 seeds; oracle 101/101 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_3a, field_3e, field_42, field_46, field_52, field_5a, field_5e, field_62, field_66, field_162, field_166, field_16a and 1 more; [ecx + n] field_4a, field_4e, field_52, field_56, field_6a, field_6e, field_72, field_76, field_15a, field_15e; [edx + n] field_4a, field_4e, field_15a, field_15e, field_16a
# callees:      calls FUN_00454f7c, FUN_00454f29
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m45504b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 101 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3e, 0x3e  # offset +0x3e
.equ field_42, 0x42  # offset +0x42
.equ field_46, 0x46  # offset +0x46
.equ field_4a, 0x4a  # offset +0x4a
.equ field_4e, 0x4e  # offset +0x4e
.equ field_52, 0x52  # offset +0x52
.equ field_56, 0x56  # offset +0x56
.equ field_5a, 0x5a  # offset +0x5a
.equ field_5e, 0x5e  # offset +0x5e
.equ field_62, 0x62  # offset +0x62
.equ field_66, 0x66  # offset +0x66
.equ field_6a, 0x6a  # offset +0x6a
.equ field_6e, 0x6e  # offset +0x6e
.equ field_72, 0x72  # offset +0x72
.equ field_76, 0x76  # offset +0x76
.equ field_15a, 0x15a  # offset +0x15a
.equ field_15e, 0x15e  # offset +0x15e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_16a, 0x16a  # offset +0x16a
.equ field_16c, 0x16c  # offset +0x16c

# --- external targets -----------------------------------------------
.set FUN_00454f29, .text + (0x00454f29 - 0x401000)
.set FUN_00454f7c, .text + (0x00454f7c - 0x401000)

.org 0x0045504b - 0x401000
.globl FUN_0045504b
FUN_0045504b:
    # block 0x0045504b: entry, 101 instruction(s), calls FUN_00454f7c, FUN_00454f29, ends with ret
    push ebp                                     # 0045504b
    {load} mov ebp, esp                          # 0045504c
    sub esp, 0xc                                 # 0045504e
    mov dword ptr [ebp - local_c], ecx           # 00455051
    mov eax, dword ptr [ebp - local_c]           # 00455054
    mov ecx, dword ptr [ebp - local_c]           # 00455057
    mov eax, dword ptr [eax + field_162]         # 0045505a
    sub eax, dword ptr [ecx + field_15a]         # 00455060
    cdq                                          # 00455066
    {load} sub eax, edx                          # 00455067
    sar eax                                      # 00455069
    mov edx, dword ptr [ebp - local_c]           # 0045506b
    add eax, dword ptr [edx + field_15a]         # 0045506e
    mov dword ptr [ebp - local_8], eax           # 00455074
    mov eax, dword ptr [ebp - local_c]           # 00455077
    mov ecx, dword ptr [ebp - local_c]           # 0045507a
    mov eax, dword ptr [eax + field_166]         # 0045507d
    sub eax, dword ptr [ecx + field_15e]         # 00455083
    cdq                                          # 00455089
    {load} sub eax, edx                          # 0045508a
    sar eax                                      # 0045508c
    mov edx, dword ptr [ebp - local_c]           # 0045508e
    add eax, dword ptr [edx + field_15e]         # 00455091
    mov dword ptr [ebp - local_4], eax           # 00455097
    mov eax, dword ptr [ebp - local_c]           # 0045509a
    mov ecx, dword ptr [ebp - local_c]           # 0045509d
    mov edx, dword ptr [ecx + field_4e]          # 004550a0
    mov dword ptr [eax + field_3e], edx          # 004550a3
    mov eax, dword ptr [ebp - local_c]           # 004550a6
    mov ecx, dword ptr [ebp - local_c]           # 004550a9
    mov edx, dword ptr [ecx + field_56]          # 004550ac
    mov dword ptr [eax + field_46], edx          # 004550af
    mov eax, dword ptr [ebp - local_c]           # 004550b2
    mov ecx, dword ptr [ebp - local_c]           # 004550b5
    mov edx, dword ptr [ecx + field_4a]          # 004550b8
    mov dword ptr [eax + field_3a], edx          # 004550bb
    mov eax, dword ptr [ebp - local_c]           # 004550be
    mov ecx, dword ptr [ebp - local_c]           # 004550c1
    mov edx, dword ptr [ecx + field_52]          # 004550c4
    mov dword ptr [eax + field_42], edx          # 004550c7
    mov eax, dword ptr [ebp - local_c]           # 004550ca
    mov ecx, dword ptr [ebp - local_c]           # 004550cd
    mov edx, dword ptr [ecx + field_6e]          # 004550d0
    mov dword ptr [eax + field_5e], edx          # 004550d3
    mov eax, dword ptr [ebp - local_c]           # 004550d6
    mov ecx, dword ptr [ebp - local_c]           # 004550d9
    mov edx, dword ptr [ecx + field_76]          # 004550dc
    mov dword ptr [eax + field_66], edx          # 004550df
    mov eax, dword ptr [ebp - local_c]           # 004550e2
    mov ecx, dword ptr [ebp - local_c]           # 004550e5
    mov edx, dword ptr [ecx + field_6a]          # 004550e8
    mov dword ptr [eax + field_5a], edx          # 004550eb
    mov eax, dword ptr [ebp - local_c]           # 004550ee
    mov ecx, dword ptr [ebp - local_c]           # 004550f1
    mov edx, dword ptr [ecx + field_72]          # 004550f4
    mov dword ptr [eax + field_62], edx          # 004550f7
    mov eax, dword ptr [ebp - local_c]           # 004550fa
    movsx eax, word ptr [eax + field_16c]        # 004550fd
    cdq                                          # 00455104
    {load} sub eax, edx                          # 00455105
    sar eax                                      # 00455107
    mov ecx, dword ptr [ebp - local_4]           # 00455109
    {load} sub ecx, eax                          # 0045510c
    mov edx, dword ptr [ebp - local_c]           # 0045510e
    mov dword ptr [edx + field_4e], ecx          # 00455111
    mov eax, dword ptr [ebp - local_c]           # 00455114
    movsx eax, word ptr [eax + field_16a]        # 00455117
    cdq                                          # 0045511e
    {load} sub eax, edx                          # 0045511f
    sar eax                                      # 00455121
    mov ecx, dword ptr [ebp - local_8]           # 00455123
    {load} sub ecx, eax                          # 00455126
    mov edx, dword ptr [ebp - local_c]           # 00455128
    mov dword ptr [edx + field_4a], ecx          # 0045512b
    mov eax, dword ptr [ebp - local_c]           # 0045512e
    movsx ecx, word ptr [eax + field_16c]        # 00455131
    mov edx, dword ptr [ebp - local_c]           # 00455138
    mov eax, dword ptr [edx + field_4e]          # 0045513b
    {load} add eax, ecx                          # 0045513e
    mov ecx, dword ptr [ebp - local_c]           # 00455140
    mov dword ptr [ecx + field_56], eax          # 00455143
    mov edx, dword ptr [ebp - local_c]           # 00455146
    movsx eax, word ptr [edx + field_16a]        # 00455149
    mov ecx, dword ptr [ebp - local_c]           # 00455150
    mov edx, dword ptr [ecx + field_4a]          # 00455153
    {load} add edx, eax                          # 00455156
    mov eax, dword ptr [ebp - local_c]           # 00455158
    mov dword ptr [eax + field_52], edx          # 0045515b
    mov ecx, dword ptr [ebp - local_c]           # 0045515e
    call FUN_00454f7c                            # 00455161
    mov ecx, dword ptr [ebp - local_c]           # 00455166
    add ecx, 0x6a                                # 00455169
    push ecx                                     # 0045516c
    mov edx, dword ptr [ebp - local_c]           # 0045516d
    add edx, 0x4a                                # 00455170
    push edx                                     # 00455173
    mov ecx, dword ptr [ebp - local_c]           # 00455174
    call FUN_00454f29                            # 00455177
    {load} mov esp, ebp                          # 0045517c
    pop ebp                                      # 0045517e
    ret                                          # 0045517f

