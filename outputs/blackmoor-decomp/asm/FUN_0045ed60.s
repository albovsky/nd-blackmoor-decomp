# FUN_0045ed60
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045ed60
# extent:       0x0045ed60-0x0045ef5a (506 code bytes)
# span:         0x0045ed60-0x0045ef5a (code 506, tables 0, padding 0)
# sha256:       a787d7961c384f0b5fcb393bed0c74bc98e39ab9760b4ea44db4f9b91b4295d5
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045ed60
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_4, field_8, field_c, field_2ad, field_2d4, field_2d5, field_2d7, field_2d9, field_2fd, field_305, field_31d, field_62b and 2 more; [ecx + n] field_4, field_8, field_c, field_2a4, field_2ab, field_2d7, field_2dd, field_62b, field_62f; [edx + n] field_4, field_8, field_c, field_2d3, field_2d5, field_2d7, field_2fd, field_305, field_31d, field_379, field_39e
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      outputs/blackmoor-decomp/src/action_family_f6_runtime.c:slide_common (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 121 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_2a4, 0x2a4  # offset +0x2a4
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_2ad, 0x2ad  # offset +0x2ad
.equ field_2d3, 0x2d3  # offset +0x2d3
.equ field_2d4, 0x2d4  # offset +0x2d4
.equ field_2d5, 0x2d5  # offset +0x2d5
.equ field_2d7, 0x2d7  # offset +0x2d7
.equ field_2d9, 0x2d9  # offset +0x2d9
.equ field_2dd, 0x2dd  # offset +0x2dd
.equ field_2fd, 0x2fd  # offset +0x2fd
.equ field_305, 0x305  # offset +0x305
.equ field_31d, 0x31d  # offset +0x31d
.equ field_379, 0x379  # offset +0x379
.equ field_39e, 0x39e  # offset +0x39e
.equ field_62b, 0x62b  # offset +0x62b
.equ field_62d, 0x62d  # offset +0x62d
.equ field_62f, 0x62f  # offset +0x62f
.equ field_633, 0x633  # offset +0x633

# --- external targets -----------------------------------------------

.org 0x0045ed60 - 0x401000
.globl FUN_0045ed60
FUN_0045ed60:
    # block 0x0045ed60: entry, 52 instruction(s), ends with je to 0x0045eedd (forward)
    push ebp                                     # 0045ed60
    {load} mov ebp, esp                          # 0045ed61
    push ecx                                     # 0045ed63
    mov dword ptr [ebp - local_4], ecx           # 0045ed64
    movsx eax, word ptr [ebp + arg_c]            # 0045ed67
    sub eax, 0x1                                 # 0045ed6b
    mov ecx, dword ptr [ebp - local_4]           # 0045ed6e
    mov word ptr [ecx + field_2d7], ax           # 0045ed71
    mov edx, dword ptr [ebp - local_4]           # 0045ed78
    mov eax, dword ptr [edx + field_31d]         # 0045ed7b
    mov ecx, dword ptr [ebp - local_4]           # 0045ed81
    movsx edx, word ptr [ecx + field_2d7]        # 0045ed84
    shl edx, 0x4                                 # 0045ed8b
    lea eax, [eax + edx + field_633]             # 0045ed8e
    mov ecx, dword ptr [ebp - local_4]           # 0045ed95
    movsx edx, word ptr [ecx + field_2d7]        # 0045ed98
    shl edx, 0x4                                 # 0045ed9f
    mov ecx, dword ptr [ebp - local_4]           # 0045eda2
    lea edx, [ecx + edx + field_2dd]             # 0045eda5
    mov ecx, dword ptr [eax]                     # 0045edac
    mov dword ptr [edx], ecx                     # 0045edae
    mov ecx, dword ptr [eax + field_4]           # 0045edb0
    mov dword ptr [edx + field_4], ecx           # 0045edb3
    mov ecx, dword ptr [eax + field_8]           # 0045edb6
    mov dword ptr [edx + field_8], ecx           # 0045edb9
    mov eax, dword ptr [eax + field_c]           # 0045edbc
    mov dword ptr [edx + field_c], eax           # 0045edbf
    mov ecx, dword ptr [ebp - local_4]           # 0045edc2
    movsx edx, word ptr [ecx + field_2d7]        # 0045edc5
    shl edx, 0x4                                 # 0045edcc
    mov eax, dword ptr [ebp - local_4]           # 0045edcf
    lea ecx, [eax + edx + field_2ad]             # 0045edd2
    mov edx, dword ptr [ebp - local_4]           # 0045edd9
    movsx eax, word ptr [edx + field_2d7]        # 0045eddc
    shl eax, 0x4                                 # 0045ede3
    mov edx, dword ptr [ebp - local_4]           # 0045ede6
    lea eax, [edx + eax + field_2fd]             # 0045ede9
    mov edx, dword ptr [ecx]                     # 0045edf0
    mov dword ptr [eax], edx                     # 0045edf2
    mov edx, dword ptr [ecx + field_4]           # 0045edf4
    mov dword ptr [eax + field_4], edx           # 0045edf7
    mov edx, dword ptr [ecx + field_8]           # 0045edfa
    mov dword ptr [eax + field_8], edx           # 0045edfd
    mov ecx, dword ptr [ecx + field_c]           # 0045ee00
    mov dword ptr [eax + field_c], ecx           # 0045ee03
    mov edx, dword ptr [ebp - local_4]           # 0045ee06
    mov al, byte ptr [ebp + arg_8]               # 0045ee09
    mov byte ptr [edx + field_2d3], al           # 0045ee0c
    mov ecx, dword ptr [ebp + arg_8]             # 0045ee12
    and ecx, 0xff                                # 0045ee15
    test ecx, ecx                                # 0045ee1b
    je.d32 L_0045eedd                            # 0045ee1d
    # block 0x0045ee23: entered by fall-through of je at 0x0045ee1d, 41 instruction(s), ends with forward jump to 0x0045ef1d
    mov edx, dword ptr [ebp - local_4]           # 0045ee23
    mov word ptr [edx + field_2d5], 0x0          # 0045ee26
    mov eax, dword ptr [ebp - local_4]           # 0045ee2f
    movsx ecx, word ptr [eax + field_2d7]        # 0045ee32
    shl ecx, 0x4                                 # 0045ee39
    mov edx, dword ptr [ebp - local_4]           # 0045ee3c
    mov eax, dword ptr [edx + field_31d]         # 0045ee3f
    movsx edx, word ptr [eax + field_62d]        # 0045ee45
    mov eax, dword ptr [ebp - local_4]           # 0045ee4c
    mov eax, dword ptr [eax + field_31d]         # 0045ee4f
    movsx eax, word ptr [eax + field_62b]        # 0045ee55
    sub eax, 0x1                                 # 0045ee5c
    imul edx, eax                                # 0045ee5f
    mov eax, dword ptr [ebp - local_4]           # 0045ee62
    mov ecx, dword ptr [eax + ecx + field_2fd]   # 0045ee65
    {load} sub ecx, edx                          # 0045ee6c
    mov edx, dword ptr [ebp - local_4]           # 0045ee6e
    movsx eax, word ptr [edx + field_2d7]        # 0045ee71
    shl eax, 0x4                                 # 0045ee78
    mov edx, dword ptr [ebp - local_4]           # 0045ee7b
    mov dword ptr [edx + eax + field_2fd], ecx   # 0045ee7e
    mov eax, dword ptr [ebp - local_4]           # 0045ee85
    movsx ecx, word ptr [eax + field_2d7]        # 0045ee88
    shl ecx, 0x4                                 # 0045ee8f
    mov edx, dword ptr [ebp - local_4]           # 0045ee92
    mov eax, dword ptr [edx + field_31d]         # 0045ee95
    movsx edx, word ptr [eax + field_62d]        # 0045ee9b
    mov eax, dword ptr [ebp - local_4]           # 0045eea2
    mov eax, dword ptr [eax + field_31d]         # 0045eea5
    movsx eax, word ptr [eax + field_62b]        # 0045eeab
    sub eax, 0x1                                 # 0045eeb2
    imul edx, eax                                # 0045eeb5
    mov eax, dword ptr [ebp - local_4]           # 0045eeb8
    mov ecx, dword ptr [eax + ecx + field_305]   # 0045eebb
    {load} sub ecx, edx                          # 0045eec2
    mov edx, dword ptr [ebp - local_4]           # 0045eec4
    movsx eax, word ptr [edx + field_2d7]        # 0045eec7
    shl eax, 0x4                                 # 0045eece
    mov edx, dword ptr [ebp - local_4]           # 0045eed1
    mov dword ptr [edx + eax + field_305], ecx   # 0045eed4
    jmp.d8 L_0045ef1d                            # 0045eedb
L_0045eedd:
    # block 0x0045eedd: entered by je at 0x0045ee1d, 10 instruction(s), ends with jne to 0x0045ef13 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0045eedd
    mov ecx, dword ptr [eax + field_31d]         # 0045eee0
    movsx edx, word ptr [ecx + field_62b]        # 0045eee6
    sub edx, 0x1                                 # 0045eeed
    mov eax, dword ptr [ebp - local_4]           # 0045eef0
    mov word ptr [eax + field_2d5], dx           # 0045eef3
    mov ecx, dword ptr [ebp - local_4]           # 0045eefa
    movsx edx, word ptr [ecx + field_2a4]        # 0045eefd
    cmp edx, 0x1                                 # 0045ef04
    jne.d8 L_0045ef13                            # 0045ef07
    # block 0x0045ef09: entered by fall-through of jne at 0x0045ef07, 2 instruction(s), falls into the block at 0x0045ef13
    mov eax, dword ptr [ebp - local_4]           # 0045ef09
    mov byte ptr [eax + field_2d4], 0x1          # 0045ef0c
L_0045ef13:
    # block 0x0045ef13: entered by jne at 0x0045ef07, 2 instruction(s), falls into the block at 0x0045ef1d
    mov ecx, dword ptr [ebp - local_4]           # 0045ef13
    mov byte ptr [ecx + field_2ab], 0x0          # 0045ef16
L_0045ef1d:
    # block 0x0045ef1d: entered by jmp at 0x0045eedb, 14 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ret 0xc
    mov edx, dword ptr [ebp - local_4]           # 0045ef1d
    mov dword ptr [edx + field_39e], 0x3         # 0045ef20
    mov eax, dword ptr [ebp - local_4]           # 0045ef2a
    mov ecx, dword ptr [ebp + arg_10]            # 0045ef2d
    mov dword ptr [eax + field_2d9], ecx         # 0045ef30
    call dword ptr [0x52a23c]                    # 0045ef36
    mov edx, dword ptr [ebp - local_4]           # 0045ef3c
    mov ecx, dword ptr [edx + field_31d]         # 0045ef3f
    add eax, dword ptr [ecx + field_62f]         # 0045ef45
    mov edx, dword ptr [ebp - local_4]           # 0045ef4b
    mov dword ptr [edx + field_379], eax         # 0045ef4e
    {load} mov esp, ebp                          # 0045ef54
    pop ebp                                      # 0045ef56
    ret 0xc                                      # 0045ef57

