# FUN_004afec1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004afec1
# extent:       0x004afec1-0x004b01d8 (791 code bytes)
# span:         0x004afec1-0x004b01e8 (code 791, tables 16, padding 0)
# sha256:       a7d26d1d3dbceaf71222d2760b63eefc1d93e6fe3c1f9254be9a486e98aed525
# evidence:     ev_7c6d57367e8ac056df8040674f52c35604171c6d5eb562dd00d81d843a97baa7
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004afec1
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_18, field_1e, field_3f, field_41, field_43; [ecx + n] field_18, field_21, field_3f, field_41, field_43, field_1531; [edx + n] field_18, field_23, field_3f, field_41, field_43, field_1533
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 210 instruction(s), 18 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ field_18, 0x18  # offset +0x18
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_23, 0x23  # offset +0x23
.equ field_3f, 0x3f  # offset +0x3f
.equ field_41, 0x41  # offset +0x41
.equ field_43, 0x43  # offset +0x43
.equ field_1531, 0x1531  # offset +0x1531
.equ field_1533, 0x1533  # offset +0x1533

# --- external targets -----------------------------------------------

.org 0x004afec1 - 0x401000
.globl FUN_004afec1
FUN_004afec1:
    # block 0x004afec1: entry, 17 instruction(s), ends with ja to 0x004b01b1 (forward)
    push ebp                                     # 004afec1
    {load} mov ebp, esp                          # 004afec2
    sub esp, 0x10                                # 004afec4
    mov dword ptr [ebp - local_c], ecx           # 004afec7
    mov eax, dword ptr [ebp - local_c]           # 004afeca
    movsx ecx, word ptr [eax + field_1e]         # 004afecd
    imul ecx, ecx, 0x8d                          # 004afed1
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004afed7
    mov dword ptr [ebp - local_8], edx           # 004afedd
    mov dword ptr [ebp - local_4], 0x1           # 004afee0
    movsx eax, word ptr [ebp + arg_8]            # 004afee7
    mov dword ptr [ebp - local_10], eax          # 004afeeb
    mov ecx, dword ptr [ebp - local_10]          # 004afeee
    sub ecx, 0x2794                              # 004afef1
    mov dword ptr [ebp - local_10], ecx          # 004afef7
    cmp dword ptr [ebp - local_10], 0x3          # 004afefa
    ja.d32 L_004b01b1                            # 004afefe
    # block 0x004aff04: entered by fall-through of ja at 0x004afefe, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4b01d8]
    mov edx, dword ptr [ebp - local_10]          # 004aff04
    jmp dword ptr [4*edx + SWTAB_004b01d8_VA]    # 004aff07
L_004aff0e:
    # block 0x004aff0e: entered by switch case, 4 instruction(s), ends with jne to 0x004aff25 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004aff0e
    movsx ecx, word ptr [eax + field_41]         # 004aff11
    test ecx, ecx                                # 004aff15
    jne.d8 L_004aff25                            # 004aff17
    # block 0x004aff19: entered by fall-through of jne at 0x004aff17, 2 instruction(s), ends with forward jump to 0x004affae
    mov dword ptr [ebp - local_4], 0x0           # 004aff19
    jmp.d32 L_004affae                           # 004aff20
L_004aff25:
    # block 0x004aff25: entered by jne at 0x004aff17, 11 instruction(s), ends with jne to 0x004aff55 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004aff25
    movsx eax, word ptr [edx + field_3f]         # 004aff28
    imul eax, eax, 0x1e4                         # 004aff2c
    mov ecx, dword ptr [ebp - local_c]           # 004aff32
    lea edx, [ecx + eax + field_43]              # 004aff35
    mov eax, dword ptr [ebp - local_c]           # 004aff39
    movsx ecx, word ptr [eax + field_41]         # 004aff3c
    sub ecx, 0x1                                 # 004aff40
    imul ecx, ecx, 0x2c                          # 004aff43
    cmp dword ptr [edx + ecx], 0x1               # 004aff46
    jne.d8 L_004aff55                            # 004aff4a
    # block 0x004aff4c: entered by fall-through of jne at 0x004aff4a, 2 instruction(s), ends with forward jump to 0x004affae
    mov dword ptr [ebp - local_4], 0x0           # 004aff4c
    jmp.d8 L_004affae                            # 004aff53
L_004aff55:
    # block 0x004aff55: entered by jne at 0x004aff4a, 11 instruction(s), ends with jne to 0x004affae (forward)
    mov edx, dword ptr [ebp - local_c]           # 004aff55
    movsx eax, word ptr [edx + field_3f]         # 004aff58
    imul eax, eax, 0x1e4                         # 004aff5c
    mov ecx, dword ptr [ebp - local_c]           # 004aff62
    lea edx, [ecx + eax + field_43]              # 004aff65
    mov eax, dword ptr [ebp - local_c]           # 004aff69
    movsx ecx, word ptr [eax + field_41]         # 004aff6c
    imul ecx, ecx, 0x2c                          # 004aff70
    movsx edx, word ptr [edx + ecx + field_18]   # 004aff73
    cmp edx, 0x5                                 # 004aff78
    jne.d8 L_004affae                            # 004aff7b
    # block 0x004aff7d: entered by fall-through of jne at 0x004aff7b, 12 instruction(s), ends with jne to 0x004affae (forward)
    mov eax, dword ptr [ebp - local_c]           # 004aff7d
    movsx ecx, word ptr [eax + field_3f]         # 004aff80
    add ecx, 0x1                                 # 004aff84
    imul ecx, ecx, 0x1e4                         # 004aff87
    mov edx, dword ptr [ebp - local_c]           # 004aff8d
    lea eax, [edx + ecx + field_43]              # 004aff90
    mov ecx, dword ptr [ebp - local_c]           # 004aff94
    movsx edx, word ptr [ecx + field_41]         # 004aff97
    sub edx, 0x1                                 # 004aff9b
    imul edx, edx, 0x2c                          # 004aff9e
    cmp dword ptr [eax + edx], 0x1               # 004affa1
    jne.d8 L_004affae                            # 004affa5
    # block 0x004affa7: entered by fall-through of jne at 0x004affa5, 1 instruction(s), falls into the block at 0x004affae
    mov dword ptr [ebp - local_4], 0x0           # 004affa7
L_004affae:
    # block 0x004affae: entered by jmp at 0x004aff20; jmp at 0x004aff53; jne at 0x004aff7b; jne at 0x004affa5, 1 instruction(s), ends with forward jump to 0x004b01b1
    jmp.d32 L_004b01b1                           # 004affae
L_004affb3:
    # block 0x004affb3: entered by switch case, 7 instruction(s), ends with jne to 0x004affd4 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004affb3
    movsx ecx, word ptr [eax + field_41]         # 004affb6
    mov edx, dword ptr [ebp - local_8]           # 004affba
    movsx eax, word ptr [edx + field_23]         # 004affbd
    sub eax, 0x1                                 # 004affc1
    {load} cmp ecx, eax                          # 004affc4
    jne.d8 L_004affd4                            # 004affc6
    # block 0x004affc8: entered by fall-through of jne at 0x004affc6, 2 instruction(s), ends with forward jump to 0x004b005d
    mov dword ptr [ebp - local_4], 0x0           # 004affc8
    jmp.d32 L_004b005d                           # 004affcf
L_004affd4:
    # block 0x004affd4: entered by jne at 0x004affc6, 11 instruction(s), ends with jne to 0x004b0004 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004affd4
    movsx edx, word ptr [ecx + field_3f]         # 004affd7
    imul edx, edx, 0x1e4                         # 004affdb
    mov eax, dword ptr [ebp - local_c]           # 004affe1
    lea ecx, [eax + edx + field_43]              # 004affe4
    mov edx, dword ptr [ebp - local_c]           # 004affe8
    movsx eax, word ptr [edx + field_41]         # 004affeb
    add eax, 0x1                                 # 004affef
    imul eax, eax, 0x2c                          # 004afff2
    cmp dword ptr [ecx + eax], 0x1               # 004afff5
    jne.d8 L_004b0004                            # 004afff9
    # block 0x004afffb: entered by fall-through of jne at 0x004afff9, 2 instruction(s), ends with forward jump to 0x004b005d
    mov dword ptr [ebp - local_4], 0x0           # 004afffb
    jmp.d8 L_004b005d                            # 004b0002
L_004b0004:
    # block 0x004b0004: entered by jne at 0x004afff9, 11 instruction(s), ends with jne to 0x004b005d (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b0004
    movsx edx, word ptr [ecx + field_3f]         # 004b0007
    imul edx, edx, 0x1e4                         # 004b000b
    mov eax, dword ptr [ebp - local_c]           # 004b0011
    lea ecx, [eax + edx + field_43]              # 004b0014
    mov edx, dword ptr [ebp - local_c]           # 004b0018
    movsx eax, word ptr [edx + field_41]         # 004b001b
    imul eax, eax, 0x2c                          # 004b001f
    movsx ecx, word ptr [ecx + eax + field_18]   # 004b0022
    cmp ecx, 0x5                                 # 004b0027
    jne.d8 L_004b005d                            # 004b002a
    # block 0x004b002c: entered by fall-through of jne at 0x004b002a, 12 instruction(s), ends with jne to 0x004b005d (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b002c
    movsx eax, word ptr [edx + field_3f]         # 004b002f
    sub eax, 0x1                                 # 004b0033
    imul eax, eax, 0x1e4                         # 004b0036
    mov ecx, dword ptr [ebp - local_c]           # 004b003c
    lea edx, [ecx + eax + field_43]              # 004b003f
    mov eax, dword ptr [ebp - local_c]           # 004b0043
    movsx ecx, word ptr [eax + field_41]         # 004b0046
    add ecx, 0x1                                 # 004b004a
    imul ecx, ecx, 0x2c                          # 004b004d
    cmp dword ptr [edx + ecx], 0x1               # 004b0050
    jne.d8 L_004b005d                            # 004b0054
    # block 0x004b0056: entered by fall-through of jne at 0x004b0054, 1 instruction(s), falls into the block at 0x004b005d
    mov dword ptr [ebp - local_4], 0x0           # 004b0056
L_004b005d:
    # block 0x004b005d: entered by jmp at 0x004affcf; jmp at 0x004b0002; jne at 0x004b002a; jne at 0x004b0054, 1 instruction(s), ends with forward jump to 0x004b01b1
    jmp.d32 L_004b01b1                           # 004b005d
L_004b0062:
    # block 0x004b0062: entered by switch case, 4 instruction(s), ends with jne to 0x004b0079 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b0062
    movsx eax, word ptr [edx + field_3f]         # 004b0065
    test eax, eax                                # 004b0069
    jne.d8 L_004b0079                            # 004b006b
    # block 0x004b006d: entered by fall-through of jne at 0x004b006b, 2 instruction(s), ends with forward jump to 0x004b0102
    mov dword ptr [ebp - local_4], 0x0           # 004b006d
    jmp.d32 L_004b0102                           # 004b0074
L_004b0079:
    # block 0x004b0079: entered by jne at 0x004b006b, 11 instruction(s), ends with jne to 0x004b00a9 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b0079
    movsx edx, word ptr [ecx + field_3f]         # 004b007c
    sub edx, 0x1                                 # 004b0080
    imul edx, edx, 0x1e4                         # 004b0083
    mov eax, dword ptr [ebp - local_c]           # 004b0089
    lea ecx, [eax + edx + field_43]              # 004b008c
    mov edx, dword ptr [ebp - local_c]           # 004b0090
    movsx eax, word ptr [edx + field_41]         # 004b0093
    imul eax, eax, 0x2c                          # 004b0097
    cmp dword ptr [ecx + eax], 0x1               # 004b009a
    jne.d8 L_004b00a9                            # 004b009e
    # block 0x004b00a0: entered by fall-through of jne at 0x004b009e, 2 instruction(s), ends with forward jump to 0x004b0102
    mov dword ptr [ebp - local_4], 0x0           # 004b00a0
    jmp.d8 L_004b0102                            # 004b00a7
L_004b00a9:
    # block 0x004b00a9: entered by jne at 0x004b009e, 11 instruction(s), ends with jne to 0x004b0102 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b00a9
    movsx edx, word ptr [ecx + field_3f]         # 004b00ac
    imul edx, edx, 0x1e4                         # 004b00b0
    mov eax, dword ptr [ebp - local_c]           # 004b00b6
    lea ecx, [eax + edx + field_43]              # 004b00b9
    mov edx, dword ptr [ebp - local_c]           # 004b00bd
    movsx eax, word ptr [edx + field_41]         # 004b00c0
    imul eax, eax, 0x2c                          # 004b00c4
    movsx ecx, word ptr [ecx + eax + field_18]   # 004b00c7
    cmp ecx, 0x5                                 # 004b00cc
    jne.d8 L_004b0102                            # 004b00cf
    # block 0x004b00d1: entered by fall-through of jne at 0x004b00cf, 12 instruction(s), ends with jne to 0x004b0102 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b00d1
    movsx eax, word ptr [edx + field_3f]         # 004b00d4
    sub eax, 0x1                                 # 004b00d8
    imul eax, eax, 0x1e4                         # 004b00db
    mov ecx, dword ptr [ebp - local_c]           # 004b00e1
    lea edx, [ecx + eax + field_43]              # 004b00e4
    mov eax, dword ptr [ebp - local_c]           # 004b00e8
    movsx ecx, word ptr [eax + field_41]         # 004b00eb
    sub ecx, 0x1                                 # 004b00ef
    imul ecx, ecx, 0x2c                          # 004b00f2
    cmp dword ptr [edx + ecx], 0x1               # 004b00f5
    jne.d8 L_004b0102                            # 004b00f9
    # block 0x004b00fb: entered by fall-through of jne at 0x004b00f9, 1 instruction(s), falls into the block at 0x004b0102
    mov dword ptr [ebp - local_4], 0x0           # 004b00fb
L_004b0102:
    # block 0x004b0102: entered by jmp at 0x004b0074; jmp at 0x004b00a7; jne at 0x004b00cf; jne at 0x004b00f9, 1 instruction(s), ends with forward jump to 0x004b01b1
    jmp.d32 L_004b01b1                           # 004b0102
L_004b0107:
    # block 0x004b0107: entered by switch case, 7 instruction(s), ends with jne to 0x004b0128 (forward)
    mov edx, dword ptr [ebp - local_c]           # 004b0107
    movsx eax, word ptr [edx + field_3f]         # 004b010a
    mov ecx, dword ptr [ebp - local_8]           # 004b010e
    movsx edx, word ptr [ecx + field_21]         # 004b0111
    sub edx, 0x1                                 # 004b0115
    {load} cmp eax, edx                          # 004b0118
    jne.d8 L_004b0128                            # 004b011a
    # block 0x004b011c: entered by fall-through of jne at 0x004b011a, 2 instruction(s), ends with forward jump to 0x004b01b1
    mov dword ptr [ebp - local_4], 0x0           # 004b011c
    jmp.d32 L_004b01b1                           # 004b0123
L_004b0128:
    # block 0x004b0128: entered by jne at 0x004b011a, 11 instruction(s), ends with jne to 0x004b0158 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004b0128
    movsx ecx, word ptr [eax + field_3f]         # 004b012b
    add ecx, 0x1                                 # 004b012f
    imul ecx, ecx, 0x1e4                         # 004b0132
    mov edx, dword ptr [ebp - local_c]           # 004b0138
    lea eax, [edx + ecx + field_43]              # 004b013b
    mov ecx, dword ptr [ebp - local_c]           # 004b013f
    movsx edx, word ptr [ecx + field_41]         # 004b0142
    imul edx, edx, 0x2c                          # 004b0146
    cmp dword ptr [eax + edx], 0x1               # 004b0149
    jne.d8 L_004b0158                            # 004b014d
    # block 0x004b014f: entered by fall-through of jne at 0x004b014d, 2 instruction(s), ends with forward jump to 0x004b01b1
    mov dword ptr [ebp - local_4], 0x0           # 004b014f
    jmp.d8 L_004b01b1                            # 004b0156
L_004b0158:
    # block 0x004b0158: entered by jne at 0x004b014d, 11 instruction(s), ends with jne to 0x004b01b1 (forward)
    mov eax, dword ptr [ebp - local_c]           # 004b0158
    movsx ecx, word ptr [eax + field_3f]         # 004b015b
    imul ecx, ecx, 0x1e4                         # 004b015f
    mov edx, dword ptr [ebp - local_c]           # 004b0165
    lea eax, [edx + ecx + field_43]              # 004b0168
    mov ecx, dword ptr [ebp - local_c]           # 004b016c
    movsx edx, word ptr [ecx + field_41]         # 004b016f
    imul edx, edx, 0x2c                          # 004b0173
    movsx eax, word ptr [eax + edx + field_18]   # 004b0176
    cmp eax, 0x5                                 # 004b017b
    jne.d8 L_004b01b1                            # 004b017e
    # block 0x004b0180: entered by fall-through of jne at 0x004b017e, 12 instruction(s), ends with jne to 0x004b01b1 (forward)
    mov ecx, dword ptr [ebp - local_c]           # 004b0180
    movsx edx, word ptr [ecx + field_3f]         # 004b0183
    add edx, 0x1                                 # 004b0187
    imul edx, edx, 0x1e4                         # 004b018a
    mov eax, dword ptr [ebp - local_c]           # 004b0190
    lea ecx, [eax + edx + field_43]              # 004b0193
    mov edx, dword ptr [ebp - local_c]           # 004b0197
    movsx eax, word ptr [edx + field_41]         # 004b019a
    add eax, 0x1                                 # 004b019e
    imul eax, eax, 0x2c                          # 004b01a1
    cmp dword ptr [ecx + eax], 0x1               # 004b01a4
    jne.d8 L_004b01b1                            # 004b01a8
    # block 0x004b01aa: entered by fall-through of jne at 0x004b01a8, 1 instruction(s), falls into the block at 0x004b01b1
    mov dword ptr [ebp - local_4], 0x0           # 004b01aa
L_004b01b1:
    # block 0x004b01b1: entered by ja at 0x004afefe; jmp at 0x004affae; jmp at 0x004b005d; jmp at 0x004b0102; more, 2 instruction(s), ends with jne to 0x004b01cf (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 004b01b1
    jne.d8 L_004b01cf                            # 004b01b5
    # block 0x004b01b7: entered by fall-through of jne at 0x004b01b5, 4 instruction(s), falls into the block at 0x004b01cf
    mov ecx, dword ptr [ebp - local_c]           # 004b01b7
    mov word ptr [ecx + field_1531], 0x0         # 004b01ba
    mov edx, dword ptr [ebp - local_c]           # 004b01c3
    mov word ptr [edx + field_1533], 0x0         # 004b01c6
L_004b01cf:
    # block 0x004b01cf: entered by jne at 0x004b01b5, 4 instruction(s), ends with ret 0x4
    mov eax, dword ptr [ebp - local_4]           # 004b01cf
    {load} mov esp, ebp                          # 004b01d2
    pop ebp                                      # 004b01d4
    ret 0x4                                      # 004b01d5

# --- data items (not part of the function) -------------------------
.org 0x004b01d8 - 0x401000
SWTAB_004b01d8:  # 4 case address(es)
    .long L_004aff0e - .text + 0x401000
    .long L_004b0062 - .text + 0x401000
    .long L_004b0107 - .text + 0x401000
    .long L_004affb3 - .text + 0x401000
.set SWTAB_004b01d8_VA, SWTAB_004b01d8 - .text + 0x401000

