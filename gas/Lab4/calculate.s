.section .bss
    .lcomm tmp1, 8
    .lcomm tmp2, 8

.section .text
.global calc
.type calc, @function

# double calc(float a, double b, double c)
#
# xmm0 = a
# xmm1 = b
# xmm2 = c

calc:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp

    # сохранить аргументы
    movss %xmm0, 0(%rsp)
    movsd %xmm1, 8(%rsp)
    movsd %xmm2, 16(%rsp)

    ####################################################
    # if (a > 0)
    ####################################################

    pxor    %xmm3, %xmm3
    cvtss2sd 0(%rsp), %xmm3

    xorpd   %xmm4, %xmm4

    comisd  %xmm4, %xmm3
    ja      positive_branch

####################################################
# a <= 0
#
# ctg(b)/(sqrt(-a)-c)
####################################################

negative_branch:

    ####################################################
    # tmp1 = sqrt(-a) - c
    ####################################################

    flds    0(%rsp)          # a
    fchs                     # -a
    fsqrt                    # sqrt(-a)

    fsubl   16(%rsp)         # sqrt(-a) - c

    fstpl   tmp1

    ####################################################
    # tmp2 = ctg(b) = 1/tan(b)
    ####################################################

    fldl    8(%rsp)
fptan

fstp    %st(0)      # убрать 1.0
fstpl   tmp2        # tmp2 = tan(b)

fld1
fdivl   tmp2        # ctg(b)

fstpl   tmp2

    ####################################################
    # result = tmp2 / tmp1
    ####################################################

    fldl    tmp2
    fdivl   tmp1

    jmp     finish

####################################################
# a > 0
#
# log_a(pi)
####################################################

positive_branch:

    ####################################################
    # tmp1 = log2(pi)
    ####################################################

    fld1
    fldpi
    fyl2x

    fstpl   tmp1

    ####################################################
    # tmp2 = log2(a)
    ####################################################

    fld1
    flds    0(%rsp)
    fyl2x

    fstpl   tmp2

    ####################################################
    # result = log2(pi)/log2(a)
    ####################################################

    fldl    tmp1
    fdivl   tmp2

finish:

    fstpl   24(%rsp)

    movsd   24(%rsp), %xmm0

    leave
    ret