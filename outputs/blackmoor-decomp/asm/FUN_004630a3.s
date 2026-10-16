# FUN_004630a3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004630a3
# extent:       0x004630a3-0x004631c1 (286 code bytes)
# span:         0x004630a3-0x004631d1 (code 286, tables 16, padding 0)
# sha256:       e7d4b2916a28e92a71e974b52a16c8165094c5776fbc027835791cbea5634e2b
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004630a3
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_57; [edx + n] field_57
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 58 instruction(s), 3 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_57, 0x57  # offset +0x57

# --- external targets -----------------------------------------------

.org 0x004630a3 - 0x401000
.globl FUN_004630a3
FUN_004630a3:
    # block 0x004630a3: entry, 7 instruction(s), ends with jne to 0x0046310e (forward)
    push ebp                                     # 004630a3
    {load} mov ebp, esp                          # 004630a4
    sub esp, 0x8                                 # 004630a6
    mov dword ptr [ebp - local_4], ecx           # 004630a9
    movsx eax, word ptr [ebp + arg_8]            # 004630ac
    cmp eax, 0x277f                              # 004630b0
    jne.d8 L_0046310e                            # 004630b5
    # block 0x004630b7: entered by fall-through of jne at 0x004630b5, 13 instruction(s), ends with forward jump to 0x004631bb
    mov dword ptr [0x5b44f0], 0x9                # 004630b7
    mov dword ptr [0x5b44f4], 0x1                # 004630c1
    mov ecx, dword ptr [0x5d0377]                # 004630cb
    mov dword ptr [0x5d162d], ecx                # 004630d1
    mov edx, dword ptr [0x5b44f0]                # 004630d7
    shl edx, 0x5                                 # 004630dd
    mov eax, dword ptr [0x5b44f4]                # 004630e0
    shl eax, 0x4                                 # 004630e5
    lea ecx, [edx + eax + 0x5b160c]              # 004630e8
    mov dword ptr [0x5d1631], ecx                # 004630ef
    mov dword ptr [0x5d1639], 0x1                # 004630f5
    mov dword ptr [0x5c39e5], 0x277f             # 004630ff
    jmp.d32 L_004631bb                           # 00463109
L_0046310e:
    # block 0x0046310e: entered by jne at 0x004630b5, 4 instruction(s), ends with jne to 0x00463124 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0046310e
    movsx eax, word ptr [edx + field_57]         # 00463111
    test eax, eax                                # 00463115
    jne.d8 L_00463124                            # 00463117
    # block 0x00463119: entered by fall-through of jne at 0x00463117, 3 instruction(s), falls into the block at 0x00463124
    mov ecx, dword ptr [ebp - local_4]           # 00463119
    mov dx, word ptr [ebp + arg_8]               # 0046311c
    mov word ptr [ecx + field_57], dx            # 00463120
L_00463124:
    # block 0x00463124: entered by jne at 0x00463117, 7 instruction(s), ends with ja to 0x00463175 (forward)
    movsx eax, word ptr [ebp + arg_8]            # 00463124
    mov dword ptr [ebp - local_8], eax           # 00463128
    mov ecx, dword ptr [ebp - local_8]           # 0046312b
    sub ecx, 0x2780                              # 0046312e
    mov dword ptr [ebp - local_8], ecx           # 00463134
    cmp dword ptr [ebp - local_8], 0x3           # 00463137
    ja.d8 L_00463175                             # 0046313b
    # block 0x0046313d: entered by fall-through of ja at 0x0046313b, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4631c1]
    mov edx, dword ptr [ebp - local_8]           # 0046313d
    jmp dword ptr [4*edx + SWTAB_004631c1_VA]    # 00463140
L_00463147:
    # block 0x00463147: entered by switch case, 2 instruction(s), ends with forward jump to 0x00463175
    mov dword ptr [0x5b44f0], 0x19               # 00463147
    jmp.d8 L_00463175                            # 00463151
L_00463153:
    # block 0x00463153: entered by switch case, 2 instruction(s), ends with forward jump to 0x00463175
    mov dword ptr [0x5b44f0], 0x17               # 00463153
    jmp.d8 L_00463175                            # 0046315d
L_0046315f:
    # block 0x0046315f: entered by switch case, 2 instruction(s), ends with forward jump to 0x00463175
    mov dword ptr [0x5b44f0], 0x18               # 0046315f
    jmp.d8 L_00463175                            # 00463169
L_0046316b:
    # block 0x0046316b: entered by switch case, 1 instruction(s), falls into the block at 0x00463175
    mov dword ptr [0x5b44f0], 0x1a               # 0046316b
L_00463175:
    # block 0x00463175: entered by ja at 0x0046313b; jmp at 0x00463151; jmp at 0x0046315d; jmp at 0x00463169, 12 instruction(s), falls into the block at 0x004631bb
    mov dword ptr [0x5b44f4], 0x1                # 00463175
    mov eax, dword ptr [0x5d0377]                # 0046317f
    mov dword ptr [0x5d162d], eax                # 00463184
    mov ecx, dword ptr [0x5b44f0]                # 00463189
    shl ecx, 0x5                                 # 0046318f
    mov edx, dword ptr [0x5b44f4]                # 00463192
    shl edx, 0x4                                 # 00463198
    lea eax, [ecx + edx + 0x5b160c]              # 0046319b
    mov dword ptr [0x5d1631], eax                # 004631a2
    mov dword ptr [0x5d1639], 0x1                # 004631a7
    movsx ecx, word ptr [ebp + arg_8]            # 004631b1
    mov dword ptr [0x5c39e5], ecx                # 004631b5
L_004631bb:
    # block 0x004631bb: entered by jmp at 0x00463109, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004631bb
    pop ebp                                      # 004631bd
    ret 0x4                                      # 004631be

# --- data items (not part of the function) -------------------------
.org 0x004631c1 - 0x401000
SWTAB_004631c1:  # 4 case address(es)
    .long L_00463147 - .text + 0x401000
    .long L_00463153 - .text + 0x401000
    .long L_0046315f - .text + 0x401000
    .long L_0046316b - .text + 0x401000
.set SWTAB_004631c1_VA, SWTAB_004631c1 - .text + 0x401000

