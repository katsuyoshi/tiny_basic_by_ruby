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
> 10 print 'a'
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

## IF文による判定ができるようになりました(6/14)

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
