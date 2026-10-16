# FUN_004570c4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004570c4
# extent:       0x004570c4-0x004571e1 (285 code bytes)
# span:         0x004570c4-0x004571e1 (code 285, tables 0, padding 0)
# sha256:       ed5d98a6ef6d57a535aa7146e7cfb362194e2e71f6b86551a5a335a7e5397473
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004570c4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1e, field_28, field_29, field_242; [ecx + n] field_27, field_28, field_29, field_2a, field_240, field_246, field_250; [edx + n] field_2a, field_244
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 66 instruction(s), 6 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1e, 0x1e  # offset +0x1e
.equ field_27, 0x27  # offset +0x27
.equ field_28, 0x28  # offset +0x28
.equ field_29, 0x29  # offset +0x29
.equ field_2a, 0x2a  # offset +0x2a
.equ field_240, 0x240  # offset +0x240
.equ field_242, 0x242  # offset +0x242
.equ field_244, 0x244  # offset +0x244
.equ field_246, 0x246  # offset +0x246
.equ field_250, 0x250  # offset +0x250

# --- external targets -----------------------------------------------

.org 0x004570c4 - 0x401000
.globl FUN_004570c4
FUN_004570c4:
    # block 0x004570c4: entry, 16 instruction(s), ends with jne to 0x0045715b (forward)
    push ebp                                     # 004570c4
    {load} mov ebp, esp                          # 004570c5
    sub esp, 0x8                                 # 004570c7
    mov dword ptr [ebp - local_8], ecx           # 004570ca
    mov eax, dword ptr [ebp - local_8]           # 004570cd
    movsx ecx, word ptr [eax + field_1e]         # 004570d0
    imul ecx, ecx, 0x8d                          # 004570d4
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004570da
    mov dword ptr [ebp - local_4], edx           # 004570e0
    movsx eax, word ptr [0x5957c3]               # 004570e3
    mov ecx, dword ptr [ebp - local_4]           # 004570ea
    movsx edx, word ptr [ecx + 4*eax + field_27] # 004570ed
    mov eax, dword ptr [ebp - local_8]           # 004570f2
    movsx ecx, word ptr [eax + field_28]         # 004570f5
    {load} cmp edx, ecx                          # 004570f9
    jne.d8 L_0045715b                            # 004570fb
    # block 0x004570fd: entered by fall-through of jne at 0x004570fb, 7 instruction(s), ends with jne to 0x0045715b (forward)
    movsx edx, word ptr [0x5957c3]               # 004570fd
    mov eax, dword ptr [ebp - local_4]           # 00457104
    movsx ecx, word ptr [eax + 4*edx + field_29] # 00457107
    mov edx, dword ptr [ebp - local_8]           # 0045710c
    movsx eax, word ptr [edx + field_2a]         # 0045710f
    {load} cmp ecx, eax                          # 00457113
    jne.d8 L_0045715b                            # 00457115
    # block 0x00457117: entered by fall-through of jne at 0x00457115, 6 instruction(s), ends with jne to 0x00457156 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00457117
    movsx edx, word ptr [ecx + field_246]        # 0045711a
    mov dword ptr [4*edx + 0x585801], 0x1        # 00457121
    movsx eax, word ptr [0x5957c3]               # 0045712c
    cmp eax, 0x3                                 # 00457133
    jne.d8 L_00457156                            # 00457136
    # block 0x00457138: entered by fall-through of jne at 0x00457136, 4 instruction(s), falls into the block at 0x00457156
    mov ecx, dword ptr [ebp - local_4]           # 00457138
    movsx edx, word ptr [ecx + field_250]        # 0045713b
    mov dword ptr [4*edx + 0x585801], 0x1        # 00457142
    mov word ptr [0x5957c1], 0x1                 # 0045714d
L_00457156:
    # block 0x00457156: entered by jne at 0x00457136, 1 instruction(s), ends with forward jump to 0x004571dd
    jmp.d32 L_004571dd                           # 00457156
L_0045715b:
    # block 0x0045715b: entered by jne at 0x004570fb; jne at 0x00457115, 4 instruction(s), ends with jne to 0x0045717d (forward)
    mov eax, dword ptr [ebp - local_8]           # 0045715b
    movsx ecx, word ptr [eax + field_28]         # 0045715e
    test ecx, ecx                                # 00457162
    jne.d8 L_0045717d                            # 00457164
    # block 0x00457166: entered by fall-through of jne at 0x00457164, 4 instruction(s), ends with forward jump to 0x004571dd
    mov edx, dword ptr [ebp - local_4]           # 00457166
    movsx eax, word ptr [edx + field_244]        # 00457169
    mov dword ptr [4*eax + 0x585801], 0x1        # 00457170
    jmp.d8 L_004571dd                            # 0045717b
L_0045717d:
    # block 0x0045717d: entered by jne at 0x00457164, 7 instruction(s), ends with jl to 0x004571c8 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0045717d
    movsx edx, word ptr [ecx + field_28]         # 00457180
    movsx eax, word ptr [0x5957c3]               # 00457184
    mov ecx, dword ptr [ebp - local_4]           # 0045718b
    movsx eax, word ptr [ecx + 4*eax + field_27] # 0045718e
    {load} cmp edx, eax                          # 00457193
    jl.d8 L_004571c8                             # 00457195
    # block 0x00457197: entered by fall-through of jl at 0x00457195, 7 instruction(s), ends with jg to 0x004571c8 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 00457197
    movsx edx, word ptr [ecx + field_2a]         # 0045719a
    movsx eax, word ptr [0x5957c3]               # 0045719e
    mov ecx, dword ptr [ebp - local_4]           # 004571a5
    movsx eax, word ptr [ecx + 4*eax + field_29] # 004571a8
    {load} cmp edx, eax                          # 004571ad
    jg.d8 L_004571c8                             # 004571af
    # block 0x004571b1: entered by fall-through of jg at 0x004571af, 4 instruction(s), ends with forward jump to 0x004571dd
    mov ecx, dword ptr [ebp - local_4]           # 004571b1
    movsx edx, word ptr [ecx + field_240]        # 004571b4
    mov dword ptr [4*edx + 0x585801], 0x1        # 004571bb
    jmp.d8 L_004571dd                            # 004571c6
L_004571c8:
    # block 0x004571c8: entered by jl at 0x00457195; jg at 0x004571af, 3 instruction(s), falls into the block at 0x004571dd
    mov eax, dword ptr [ebp - local_4]           # 004571c8
    movsx ecx, word ptr [eax + field_242]        # 004571cb
    mov dword ptr [4*ecx + 0x585801], 0x1        # 004571d2
L_004571dd:
    # block 0x004571dd: entered by jmp at 0x00457156; jmp at 0x0045717b; jmp at 0x004571c6, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004571dd
    pop ebp                                      # 004571df
    ret                                          # 004571e0

