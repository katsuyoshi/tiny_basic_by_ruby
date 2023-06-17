# Tiny Basic by Ruby

Tiny BasicをRubyで実装します。  

言語処理系はあまり経験がないので、原点に戻ってTiny BasicをRubyで実装してみようというプロジェクトです。  

[中日電工](https://userweb.alles.or.jp/chunichidenko/index.htm)さんで連載していた[復活！ＴＩＮＹ　ＢＡＳＩＣ](https://userweb.alles.or.jp/chunichidenko/tinybasic_mokuji.html)を元に作っていこうと思ってます。

# 進捗

## print文の実行ができる様になりました。(6/9)

```
% ./tiny_basic 
Tiny Basic by Ruby 0.1.0.

OK
> print 'abc', #4, 123
ABC 123

OK
> print 'abc'; print 123
ABC
   123

OK
> 
```

## LETによる代入ができる様になりました。(6/14)

```
% ./tiny_basic 
Tiny Basic by Ruby 0.1.0.

OK
> let a = 1

OK
> print a
     1

OK
> a = 1, b = 1 + 1, c = a + b

OK
> print a, b, c
     1     2     3

OK
> a = 1, b = 2, c = a * 2; print a; print b; print c
     1
     2
     2

OK
>
```

## RUNとSTOPとGOTOが実行できる様になりました(6/15)

```
Tiny Basic by Ruby 0.1.0.

OK
> 10 print 'a'; stop
> 20 print 'b'
> run
A

OK
> 
```

```
Tiny Basic by Ruby 0.1.0.

OK
> 10 print 'a',; goto 10
> run
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA...
```

## IF文による判定ができるようになりました(6/15)

```
Tiny Basic by Ruby 0.1.0.

OK
> a = 0, b = 0; if a = b print "same"
SAME

OK
> a = 1; if a = b print "same"

OK
> 
```

## FOR文によるループができるようになりました。(6/16)

```
Tiny Basic by Ruby 0.1.0.

OK
> 10 FOR A = 1 TO 9
> 20 FOR B = 1 TO 9
> 30 PRINT #2, A, " X", B, " = ", A * B
> 40 NEXT B
> 50 NEXT A
> r.
 1 X 1 =  1
 1 X 2 =  2
.
.
.
 9 X 6 = 54
 9 X 7 = 63
 9 X 8 = 72
 9 X 9 = 81
```

## GOUSB RETURN によるサブルーチンコールができる様になりました(6/17)

```
Tiny Basic by Ruby 0.1.0.

OK
> 10 GOSUB 100; PRINT "A"
> 20 STOP
> 30 PRINT "B"
> 100 PRINT "C"
> 110 RETURN
> r.
C
A

OK
> 
```

## INPUT文で入力ができる様になりました(6/17)

```
Tiny Basic by Ruby 0.1.0.

OK
> 10 input "score" a, b
> 20 print a, b
> r.
SCORE:(a+1)*2+3
B:12
    11    12

OK
```

ここまででTiny Basicの実装が完了しました。
