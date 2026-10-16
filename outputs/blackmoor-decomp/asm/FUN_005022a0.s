# FUN_005022a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005022a0
# extent:       0x005022a0-0x0050236e (206 code bytes)
# span:         0x005022a0-0x00502370 (code 206, tables 0, padding 2)
# sha256:       1fdb7e02cc9eee3ffcb32abfe54fb866c4a27b1e73f8aec686f30beb06da3328
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005022a0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_1; [esp + n] stk_8, stk_c, stk_10
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 84 instruction(s), 8 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_1, 0x1  # offset -0x1
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x005022a0 - 0x401000
.globl FUN_005022a0
FUN_005022a0:
    # block 0x005022a0: entry, 12 instruction(s), ends with jne to 0x005022c3 (forward)
    mov edx, dword ptr [esp + stk_c]             # 005022a0
    mov ecx, dword ptr [esp + stk_10]            # 005022a4
    push esi                                     # 005022a8
    fld dword ptr [edx]                          # 005022a9
    fabs                                         # 005022ab
    fld dword ptr [ecx]                          # 005022ad
    fabs                                         # 005022af
    fld st(1)                                    # 005022b1
    fcomp st(1)                                  # 005022b3
    fnstsw ax                                    # 005022b5
    test ah, 0x41                                # 005022b7
    jne.d8 L_005022c3                            # 005022ba
    # block 0x005022bc: entered by fall-through of jne at 0x005022ba, 2 instruction(s), ends with forward jump to 0x005022c5
    mov esi, 0x1                                 # 005022bc
    jmp.d8 L_005022c5                            # 005022c1
L_005022c3:
    # block 0x005022c3: entered by jne at 0x005022ba, 1 instruction(s), falls into the block at 0x005022c5
    {load} xor esi, esi                          # 005022c3
L_005022c5:
    # block 0x005022c5: entered by jmp at 0x005022c1, 6 instruction(s), ends with je to 0x005022d9 (forward)
    fxch st(1)                                   # 005022c5
    fcomp st(1)                                  # 005022c7
    fnstsw ax                                    # 005022c9
    test ah, 0x1                                 # 005022cb
    fstp st(0)                                   # 005022ce
    je.d8 L_005022d9                             # 005022d0
    # block 0x005022d2: entered by fall-through of je at 0x005022d0, 2 instruction(s), ends with forward jump to 0x005022db
    mov eax, 0x1                                 # 005022d2
    jmp.d8 L_005022db                            # 005022d7
L_005022d9:
    # block 0x005022d9: entered by je at 0x005022d0, 1 instruction(s), falls into the block at 0x005022db
    {load} xor eax, eax                          # 005022d9
L_005022db:
    # block 0x005022db: entered by jmp at 0x005022d7, 2 instruction(s), ends with jne to 0x00502301 (forward)
    {load} sub esi, eax                          # 005022db
    jne.d8 L_00502301                            # 005022dd
    # block 0x005022df: entered by fall-through of jne at 0x005022dd, 8 instruction(s), ends with je to 0x005022fb (forward)
    fld dword ptr [esp + stk_8]                  # 005022df
    fabs                                         # 005022e3
    fld dword ptr [esp + stk_c]                  # 005022e5
    fabs                                         # 005022e9
    fcompp                                       # 005022eb
    fnstsw ax                                    # 005022ed
    test ah, 0x1                                 # 005022ef
    je.d8 L_005022fb                             # 005022f2
    # block 0x005022f4: entered by fall-through of je at 0x005022f2, 2 instruction(s), ends with forward jump to 0x005022fd
    mov eax, 0x1                                 # 005022f4
    jmp.d8 L_005022fd                            # 005022f9
L_005022fb:
    # block 0x005022fb: entered by je at 0x005022f2, 1 instruction(s), falls into the block at 0x005022fd
    {load} xor eax, eax                          # 005022fb
L_005022fd:
    # block 0x005022fd: entered by jmp at 0x005022f9, 1 instruction(s), falls into the block at 0x00502301
    lea esi, [eax + eax - field_minus_1]         # 005022fd
L_00502301:
    # block 0x00502301: entered by jne at 0x005022dd, 3 instruction(s), ends with jne to 0x00502326 (forward)
    cmp esi, 0x1                                 # 00502301
    pop esi                                      # 00502304
    jne.d8 L_00502326                            # 00502305
    # block 0x00502307: entered by fall-through of jne at 0x00502305, 5 instruction(s), ends with jne to 0x0050231e (forward)
    fld dword ptr [edx]                          # 00502307
    fcomp dword ptr [0x52db78]                   # 00502309
    fnstsw ax                                    # 0050230f
    test ah, 0x41                                # 00502311
    jne.d8 L_0050231e                            # 00502314
    # block 0x00502316: entered by fall-through of jne at 0x00502314, 4 instruction(s), ends with forward jump to 0x00502345
    fld dword ptr [edx]                          # 00502316
    fsub dword ptr [ecx]                         # 00502318
    fstp dword ptr [ecx]                         # 0050231a
    jmp.d8 L_00502345                            # 0050231c
L_0050231e:
    # block 0x0050231e: entered by jne at 0x00502314, 4 instruction(s), ends with forward jump to 0x00502345
    fld dword ptr [ecx]                          # 0050231e
    fsub dword ptr [edx]                         # 00502320
    fstp dword ptr [ecx]                         # 00502322
    jmp.d8 L_00502345                            # 00502324
L_00502326:
    # block 0x00502326: entered by jne at 0x00502305, 6 instruction(s), ends with jne to 0x0050233d (forward)
    fld dword ptr [ecx]                          # 00502326
    fld dword ptr [ecx]                          # 00502328
    fcomp dword ptr [0x52db78]                   # 0050232a
    fnstsw ax                                    # 00502330
    test ah, 0x41                                # 00502332
    jne.d8 L_0050233d                            # 00502335
    # block 0x00502337: entered by fall-through of jne at 0x00502335, 3 instruction(s), ends with forward jump to 0x00502341
    fld dword ptr [edx]                          # 00502337
    fsub dword ptr [ecx]                         # 00502339
    jmp.d8 L_00502341                            # 0050233b
L_0050233d:
    # block 0x0050233d: entered by jne at 0x00502335, 2 instruction(s), falls into the block at 0x00502341
    fld dword ptr [ecx]                          # 0050233d
    fsub dword ptr [edx]                         # 0050233f
L_00502341:
    # block 0x00502341: entered by jmp at 0x0050233b, 2 instruction(s), falls into the block at 0x00502345
    fstp dword ptr [ecx]                         # 00502341
    fstp dword ptr [edx]                         # 00502343
L_00502345:
    # block 0x00502345: entered by jmp at 0x0050231c; jmp at 0x00502324, 9 instruction(s), ends with je to 0x0050236b (forward)
    fld dword ptr [edx]                          # 00502345
    fabs                                         # 00502347
    fld dword ptr [ecx]                          # 00502349
    fld st(1)                                    # 0050234b
    fmul qword ptr [0x52e610]                    # 0050234d
    fcompp                                       # 00502353
    fnstsw ax                                    # 00502355
    test ah, 0x1                                 # 00502357
    je.d8 L_0050236b                             # 0050235a
    # block 0x0050235c: entered by fall-through of je at 0x0050235a, 6 instruction(s), ends with ret
    fmul qword ptr [0x52e608]                    # 0050235c
    fstp dword ptr [ecx]                         # 00502362
    fld dword ptr [edx]                          # 00502364
    fchs                                         # 00502366
    fstp dword ptr [edx]                         # 00502368
    ret                                          # 0050236a
L_0050236b:
    # block 0x0050236b: entered by je at 0x0050235a, 2 instruction(s), ends with ret
    fstp st(0)                                   # 0050236b
    ret                                          # 0050236d

# --- data items (not part of the function) -------------------------
.org 0x0050236e - 0x401000
PAD_0050236e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

