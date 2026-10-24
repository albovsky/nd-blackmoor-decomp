# FUN_004acdc2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004acdc2
# extent:       0x004acdc2-0x004acf45 (387 code bytes)
# span:         0x004acdc2-0x004acf45 (code 387, tables 0, padding 0)
# sha256:       c362635dff707d3adf0e96e40314d1fb2c102b91179acd83ed4119344b2d4f88
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4acdc2_lifted
# naming:       native port src/original_methods_fl41.c:m4acdc2_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 11 seeds; oracle: 125/125 instructions, 0/0 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       5 ebp-relative slot(s): local_4, local_8, local_c, local_10, local_14
# fields:       [eax + n] field_6, field_e, field_14, field_20, field_22, field_24, field_26, field_27, field_2a, field_2e, field_32, field_36 and 5 more; [ecx + n] field_2, field_6, field_a, field_e, field_12, field_16, field_1a, field_1e, field_26, field_c29; [edx + n] field_2, field_6, field_a, field_e, field_18, field_6e, field_c25, field_c29, field_c2d
# callees:      calls FUN_004accab
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m4acdc2_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 125 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ field_2, 0x2  # offset +0x2
.equ field_6, 0x6  # offset +0x6
.equ field_a, 0xa  # offset +0xa
.equ field_e, 0xe  # offset +0xe
.equ field_12, 0x12  # offset +0x12
.equ field_14, 0x14  # offset +0x14
.equ field_16, 0x16  # offset +0x16
.equ field_18, 0x18  # offset +0x18
.equ field_1a, 0x1a  # offset +0x1a
.equ field_1e, 0x1e  # offset +0x1e
.equ field_20, 0x20  # offset +0x20
.equ field_22, 0x22  # offset +0x22
.equ field_24, 0x24  # offset +0x24
.equ field_26, 0x26  # offset +0x26
.equ field_27, 0x27  # offset +0x27
.equ field_2a, 0x2a  # offset +0x2a
.equ field_2e, 0x2e  # offset +0x2e
.equ field_32, 0x32  # offset +0x32
.equ field_36, 0x36  # offset +0x36
.equ field_3a, 0x3a  # offset +0x3a
.equ field_3e, 0x3e  # offset +0x3e
.equ field_42, 0x42  # offset +0x42
.equ field_6e, 0x6e  # offset +0x6e
.equ field_c25, 0xc25  # offset +0xc25
.equ field_c29, 0xc29  # offset +0xc29
.equ field_c2d, 0xc2d  # offset +0xc2d
.equ field_c31, 0xc31  # offset +0xc31

# --- external targets -----------------------------------------------
.set FUN_004accab, .text + (0x004accab - 0x401000)

.org 0x004acdc2 - 0x401000
.globl FUN_004acdc2
FUN_004acdc2:
    # block 0x004acdc2: entry, 125 instruction(s), calls FUN_004accab, ends with ret
    push ebp                                     # 004acdc2
    {load} mov ebp, esp                          # 004acdc3
    sub esp, 0x14                                # 004acdc5
    mov dword ptr [ebp - local_14], ecx          # 004acdc8
    mov eax, dword ptr [ebp - local_14]          # 004acdcb
    movsx ecx, word ptr [eax + field_24]         # 004acdce
    imul ecx, ecx, 0xc7                          # 004acdd2
    mov edx, dword ptr [ebp - local_14]          # 004acdd8
    lea eax, [edx + ecx + field_6e]              # 004acddb
    mov dword ptr [ebp - local_10], eax          # 004acddf
    mov ecx, dword ptr [ebp - local_10]          # 004acde2
    {load} xor edx, edx                          # 004acde5
    mov dl, byte ptr [ecx + field_26]            # 004acde7
    imul edx, edx, 0x28                          # 004acdea
    mov eax, dword ptr [ebp - local_10]          # 004acded
    lea ecx, [eax + edx + field_27]              # 004acdf0
    mov dword ptr [ebp - local_8], ecx           # 004acdf4
    mov edx, dword ptr [ebp - local_14]          # 004acdf7
    mov eax, dword ptr [ebp - local_14]          # 004acdfa
    mov ecx, dword ptr [edx + field_c2d]         # 004acdfd
    sub ecx, dword ptr [eax + field_c25]         # 004ace03
    {load} mov eax, ecx                          # 004ace09
    cdq                                          # 004ace0b
    {load} sub eax, edx                          # 004ace0c
    sar eax                                      # 004ace0e
    mov edx, dword ptr [ebp - local_14]          # 004ace10
    add eax, dword ptr [edx + field_c25]         # 004ace13
    mov dword ptr [ebp - local_c], eax           # 004ace19
    mov eax, dword ptr [ebp - local_14]          # 004ace1c
    mov ecx, dword ptr [ebp - local_14]          # 004ace1f
    mov eax, dword ptr [eax + field_c31]         # 004ace22
    sub eax, dword ptr [ecx + field_c29]         # 004ace28
    cdq                                          # 004ace2e
    {load} sub eax, edx                          # 004ace2f
    sar eax                                      # 004ace31
    mov edx, dword ptr [ebp - local_14]          # 004ace33
    add eax, dword ptr [edx + field_c29]         # 004ace36
    mov dword ptr [ebp - local_4], eax           # 004ace3c
    mov eax, dword ptr [ebp - local_14]          # 004ace3f
    mov ecx, dword ptr [ebp - local_10]          # 004ace42
    mov edx, dword ptr [ecx + field_6]           # 004ace45
    mov dword ptr [eax + field_2a], edx          # 004ace48
    mov eax, dword ptr [ebp - local_14]          # 004ace4b
    mov ecx, dword ptr [ebp - local_10]          # 004ace4e
    mov edx, dword ptr [ecx + field_e]           # 004ace51
    mov dword ptr [eax + field_32], edx          # 004ace54
    mov eax, dword ptr [ebp - local_14]          # 004ace57
    mov ecx, dword ptr [ebp - local_10]          # 004ace5a
    mov edx, dword ptr [ecx + field_2]           # 004ace5d
    mov dword ptr [eax + field_26], edx          # 004ace60
    mov eax, dword ptr [ebp - local_14]          # 004ace63
    mov ecx, dword ptr [ebp - local_10]          # 004ace66
    mov edx, dword ptr [ecx + field_a]           # 004ace69
    mov dword ptr [eax + field_2e], edx          # 004ace6c
    mov eax, dword ptr [ebp - local_14]          # 004ace6f
    mov ecx, dword ptr [ebp - local_10]          # 004ace72
    mov edx, dword ptr [ecx + field_16]          # 004ace75
    mov dword ptr [eax + field_3a], edx          # 004ace78
    mov eax, dword ptr [ebp - local_14]          # 004ace7b
    mov ecx, dword ptr [ebp - local_10]          # 004ace7e
    mov edx, dword ptr [ecx + field_1e]          # 004ace81
    mov dword ptr [eax + field_42], edx          # 004ace84
    mov eax, dword ptr [ebp - local_14]          # 004ace87
    mov ecx, dword ptr [ebp - local_10]          # 004ace8a
    mov edx, dword ptr [ecx + field_12]          # 004ace8d
    mov dword ptr [eax + field_36], edx          # 004ace90
    mov eax, dword ptr [ebp - local_14]          # 004ace93
    mov ecx, dword ptr [ebp - local_10]          # 004ace96
    mov edx, dword ptr [ecx + field_1a]          # 004ace99
    mov dword ptr [eax + field_3e], edx          # 004ace9c
    mov eax, dword ptr [ebp - local_8]           # 004ace9f
    movsx eax, word ptr [eax + field_22]         # 004acea2
    cdq                                          # 004acea6
    {load} sub eax, edx                          # 004acea7
    sar eax                                      # 004acea9
    mov ecx, dword ptr [ebp - local_4]           # 004aceab
    {load} sub ecx, eax                          # 004aceae
    mov edx, dword ptr [ebp - local_10]          # 004aceb0
    mov dword ptr [edx + field_6], ecx           # 004aceb3
    mov eax, dword ptr [ebp - local_8]           # 004aceb6
    movsx eax, word ptr [eax + field_20]         # 004aceb9
    cdq                                          # 004acebd
    {load} sub eax, edx                          # 004acebe
    sar eax                                      # 004acec0
    mov ecx, dword ptr [ebp - local_c]           # 004acec2
    {load} sub ecx, eax                          # 004acec5
    mov edx, dword ptr [ebp - local_10]          # 004acec7
    mov dword ptr [edx + field_2], ecx           # 004aceca
    mov eax, dword ptr [ebp - local_10]          # 004acecd
    mov ecx, dword ptr [eax + field_6]           # 004aced0
    mov edx, dword ptr [ebp - local_8]           # 004aced3
    add ecx, dword ptr [edx + field_18]          # 004aced6
    mov eax, dword ptr [ebp - local_10]          # 004aced9
    mov dword ptr [eax + field_e], ecx           # 004acedc
    mov ecx, dword ptr [ebp - local_10]          # 004acedf
    mov edx, dword ptr [ecx + field_2]           # 004acee2
    mov eax, dword ptr [ebp - local_8]           # 004acee5
    add edx, dword ptr [eax + field_14]          # 004acee8
    mov ecx, dword ptr [ebp - local_10]          # 004aceeb
    mov dword ptr [ecx + field_a], edx           # 004aceee
    mov ecx, dword ptr [ebp - local_14]          # 004acef1
    call FUN_004accab                            # 004acef4
    mov edx, dword ptr [ebp - local_10]          # 004acef9
    mov eax, dword ptr [edx + field_6]           # 004acefc
    add eax, dword ptr [0x58318a]                # 004aceff
    mov ecx, dword ptr [ebp - local_10]          # 004acf05
    mov dword ptr [ecx + field_16], eax          # 004acf08
    mov edx, dword ptr [ebp - local_10]          # 004acf0b
    mov eax, dword ptr [edx + field_e]           # 004acf0e
    add eax, dword ptr [0x58318a]                # 004acf11
    mov ecx, dword ptr [ebp - local_10]          # 004acf17
    mov dword ptr [ecx + field_1e], eax          # 004acf1a
    mov edx, dword ptr [ebp - local_10]          # 004acf1d
    mov eax, dword ptr [edx + field_2]           # 004acf20
    add eax, dword ptr [0x583186]                # 004acf23
    mov ecx, dword ptr [ebp - local_10]          # 004acf29
    mov dword ptr [ecx + field_12], eax          # 004acf2c
    mov edx, dword ptr [ebp - local_10]          # 004acf2f
    mov eax, dword ptr [edx + field_a]           # 004acf32
    add eax, dword ptr [0x583186]                # 004acf35
    mov ecx, dword ptr [ebp - local_10]          # 004acf3b
    mov dword ptr [ecx + field_1a], eax          # 004acf3e
    {load} mov esp, ebp                          # 004acf41
    pop ebp                                      # 004acf43
    ret                                          # 004acf44

