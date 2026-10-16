# FUN_004e71da
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e71da
# extent:       0x004e71da-0x004e7243 (105 code bytes)
# span:         0x004e71da-0x004e7253 (code 105, tables 16, padding 0)
# sha256:       9b89aa7c9b5a94231e900dc269bf107261455cbdc6ab4e7fb28417cae9253565
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e71da
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004e71da - 0x401000
.globl FUN_004e71da
FUN_004e71da:
    # block 0x004e71da: entry, 13 instruction(s), ends with ja to 0x004e723d (forward)
    push ebp                                     # 004e71da
    {load} mov ebp, esp                          # 004e71db
    sub esp, 0xc                                 # 004e71dd
    mov dword ptr [ebp - local_8], ecx           # 004e71e0
    movsx eax, word ptr [ebp + arg_8]            # 004e71e3
    imul eax, eax, 0x8d                          # 004e71e7
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004e71ed
    mov dword ptr [ebp - local_4], ecx           # 004e71f3
    mov edx, dword ptr [ebp - local_4]           # 004e71f6
    movsx eax, word ptr [edx]                    # 004e71f9
    mov dword ptr [ebp - local_c], eax           # 004e71fc
    cmp dword ptr [ebp - local_c], 0x3           # 004e71ff
    ja.d8 L_004e723d                             # 004e7203
    # block 0x004e7205: entered by fall-through of ja at 0x004e7203, 2 instruction(s), ends with indirect jump dword ptr [4*ecx + 0x4e7243]
    mov ecx, dword ptr [ebp - local_c]           # 004e7205
    jmp dword ptr [4*ecx + SWTAB_004e7243_VA]    # 004e7208
L_004e720f:
    # block 0x004e720f: entered by switch case, 2 instruction(s), ends with forward jump to 0x004e723d
    mov dword ptr [0x5a1e54], 0x0                # 004e720f
    jmp.d8 L_004e723d                            # 004e7219
L_004e721b:
    # block 0x004e721b: entered by switch case, 2 instruction(s), ends with forward jump to 0x004e723d
    mov dword ptr [0x5a1e54], 0x1                # 004e721b
    jmp.d8 L_004e723d                            # 004e7225
L_004e7227:
    # block 0x004e7227: entered by switch case, 2 instruction(s), ends with forward jump to 0x004e723d
    mov dword ptr [0x5a1e58], 0x0                # 004e7227
    jmp.d8 L_004e723d                            # 004e7231
L_004e7233:
    # block 0x004e7233: entered by switch case, 1 instruction(s), falls into the block at 0x004e723d
    mov dword ptr [0x5a1e58], 0x1                # 004e7233
L_004e723d:
    # block 0x004e723d: entered by ja at 0x004e7203; jmp at 0x004e7219; jmp at 0x004e7225; jmp at 0x004e7231, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004e723d
    pop ebp                                      # 004e723f
    ret 0x4                                      # 004e7240

# --- data items (not part of the function) -------------------------
.org 0x004e7243 - 0x401000
SWTAB_004e7243:  # 4 case address(es)
    .long L_004e720f - .text + 0x401000
    .long L_004e721b - .text + 0x401000
    .long L_004e7227 - .text + 0x401000
    .long L_004e7233 - .text + 0x401000
.set SWTAB_004e7243_VA, SWTAB_004e7243 - .text + 0x401000

