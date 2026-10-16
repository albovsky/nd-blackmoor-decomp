# FUN_0045dc8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045dc8a
# extent:       0x0045dc8a-0x0045dd4d (195 code bytes)
# span:         0x0045dc8a-0x0045dd4d (code 195, tables 0, padding 0)
# sha256:       0134903dcc92b21bb1454874dc7acefd36663cb06b92c0fd91bdaf1f0d4e1bec
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045dc8a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_298, field_29e, field_29f, field_2ac, field_39d; [ecx + n] field_1c, field_299, field_2aa, field_2ab, field_2d5, field_3ac; [edx + n] field_29c, field_2cf, field_2d4, field_321, field_3aa, field_3ad
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 43 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_298, 0x298  # offset +0x298
.equ field_299, 0x299  # offset +0x299
.equ field_29c, 0x29c  # offset +0x29c
.equ field_29e, 0x29e  # offset +0x29e
.equ field_29f, 0x29f  # offset +0x29f
.equ field_2aa, 0x2aa  # offset +0x2aa
.equ field_2ab, 0x2ab  # offset +0x2ab
.equ field_2ac, 0x2ac  # offset +0x2ac
.equ field_2cf, 0x2cf  # offset +0x2cf
.equ field_2d4, 0x2d4  # offset +0x2d4
.equ field_2d5, 0x2d5  # offset +0x2d5
.equ field_321, 0x321  # offset +0x321
.equ field_39d, 0x39d  # offset +0x39d
.equ field_3aa, 0x3aa  # offset +0x3aa
.equ field_3ac, 0x3ac  # offset +0x3ac
.equ field_3ad, 0x3ad  # offset +0x3ad

# --- external targets -----------------------------------------------

.org 0x0045dc8a - 0x401000
.globl FUN_0045dc8a
FUN_0045dc8a:
    # block 0x0045dc8a: entry, 43 instruction(s), ends with ret
    push ebp                                     # 0045dc8a
    {load} mov ebp, esp                          # 0045dc8b
    push ecx                                     # 0045dc8d
    mov dword ptr [ebp - local_4], ecx           # 0045dc8e
    mov eax, dword ptr [ebp - local_4]           # 0045dc91
    mov word ptr [eax + field_1e], 0xffff        # 0045dc94
    mov ecx, dword ptr [ebp - local_4]           # 0045dc9a
    mov word ptr [ecx + field_1c], 0xffff        # 0045dc9d
    mov edx, dword ptr [ebp - local_4]           # 0045dca3
    mov byte ptr [edx + field_321], 0x0          # 0045dca6
    mov eax, dword ptr [ebp - local_4]           # 0045dcad
    mov byte ptr [eax + field_39d], 0x0          # 0045dcb0
    mov ecx, dword ptr [ebp - local_4]           # 0045dcb7
    mov byte ptr [ecx + field_2aa], 0x0          # 0045dcba
    mov edx, dword ptr [ebp - local_4]           # 0045dcc1
    mov byte ptr [edx + field_3aa], 0x0          # 0045dcc4
    mov eax, dword ptr [ebp - local_4]           # 0045dccb
    mov byte ptr [eax + field_298], 0x0          # 0045dcce
    mov ecx, dword ptr [ebp - local_4]           # 0045dcd5
    mov byte ptr [ecx + field_299], 0x0          # 0045dcd8
    mov edx, dword ptr [ebp - local_4]           # 0045dcdf
    mov byte ptr [edx + field_29c], 0x0          # 0045dce2
    mov eax, dword ptr [ebp - local_4]           # 0045dce9
    mov byte ptr [eax + field_29e], 0x0          # 0045dcec
    mov ecx, dword ptr [ebp - local_4]           # 0045dcf3
    mov byte ptr [ecx + field_2ab], 0x0          # 0045dcf6
    mov edx, dword ptr [ebp - local_4]           # 0045dcfd
    mov byte ptr [edx + field_2d4], 0x0          # 0045dd00
    mov eax, dword ptr [ebp - local_4]           # 0045dd07
    mov byte ptr [eax + field_2ac], 0x0          # 0045dd0a
    mov ecx, dword ptr [ebp - local_4]           # 0045dd11
    mov byte ptr [ecx + field_3ac], 0x0          # 0045dd14
    mov edx, dword ptr [ebp - local_4]           # 0045dd1b
    mov byte ptr [edx + field_3ad], 0x0          # 0045dd1e
    mov eax, dword ptr [ebp - local_4]           # 0045dd25
    mov word ptr [eax + field_29f], 0xffff       # 0045dd28
    mov ecx, dword ptr [ebp - local_4]           # 0045dd31
    mov word ptr [ecx + field_2d5], 0xffff       # 0045dd34
    mov edx, dword ptr [ebp - local_4]           # 0045dd3d
    mov word ptr [edx + field_2cf], 0xffff       # 0045dd40
    {load} mov esp, ebp                          # 0045dd49
    pop ebp                                      # 0045dd4b
    ret                                          # 0045dd4c

