# Generatory Flex i Bison

W repozytorium znajduje się rozwiązanie zadania akademickiego Dr Jankowskiej dot. generatorów FLEX i BISON.

## Zadanie 6.1.a

> Zbiór danych jest niepustym zbiorem wierszy, z których każdy składa się z liczb nieujemnych bez znaku:
> a) całkowitych zapisanych w układzie dziesiętnym, np. 3256,
> b) całkowitych zapisanych w układzie szesnastkowym, np. 43C3,
> c) rzeczywistych zapisanych w układzie dziesiętnym w formacie stałopozycyjnym, np. 12.93,
> d) rzeczywistych zapisanych w układzie dziesiętnym w formacie zmiennoprzecinkowym, z cechą koniecznie poprzedzoną znakiem, np. 23.64E+12.
> Poszczególne wiersze są niepuste i mają jednorodną postać, tzn. znajdujące się w nich liczby należą do tej samej kategorii (a, b, c lub d). Każda liczba w wierszu jest poprzedzona dowolną (niezerową) liczbą spacji lub znaków tabulacji.
> Skonstruuj wyrażenie regularne/wzorzec definiujące opisany zbiór danych.

### Rozwiązanie

Rozwiązaniem jest następujący regex:

```
[ \t]+(([0-9])|([1-9][0-9]*)|0x[0-9A-F]+|[0-9]+\.[0-9]{2}|[0-9]+\.[0-9]+E("+"|"-")[0-9]+)+[\r]?[\n]*
```

## Zadanie 6.1.b

> Zdefiniuj gramatykę bezkontekstową generującą zbiór zbiorów danych
> scharakteryzowanych w zadaniu 6.

### Rozwiązanie

#### Symbol startowy:

```
FILE
```

#### Symbole terminalne:

```
NUMBER:         '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
ZERO:           '0'
MINUS:          '-'
PLUS:           '+'
AF:             'A' | 'B' | 'C' | 'D' | 'E' | 'F'
X:              'x'
E:              'E'
NEWLINE:        '\n' | '\r' '\n'
SPACE:          ' '
DOT:            '.'
TAB:            '\t'
```

#### Symbole nieterminalne:

```
ALLNUM, WHITE, PLUSMINUS, DECIMAL, ALLHEX, HEX, LEFT_REAL, RIGHT_REAL, S_REAL, F_REAL, FILE, LINE, DECIMAL_LINE, HEX_LINE, S_REAL_LINE, F_REAL_LINE
```

#### Reguły produkcji:

```
ALLNUM      -> NUMBER | ZERO
WHITE       -> TAB | SPACE | WHITE WHITE
PLUSMINUS   -> PLUS | MINUS
DECIMAL     -> NUMBER | DECIMAL ZERO | DECIMAL DECIMAL
ALLHEX      -> NUMBER | AF | ALLHEX ALLHEX
HEX         -> ZERO X ALLHEX
LEFT_REAL   -> DECIMAL | ZERO
RIGHT_REAL  -> DECIMAL | ZERO | RIGHT_REAL RIGHT_REAL
S_REAL      -> LEFT_REAL DOT RIGHT_REAL
F_REAL      -> LEFT_REAL DOT RIGHT_REAL E PLUSMINUS DECIMAL

FILE            -> LINE | FILE LINE
LINE            -> DECIMAL_LINE | HEX_LINE | S_REAL_LINE | F_REAL_LINE | NEWLINE
DECIMAL_LINE    -> WHITE DECIMAL | DECIMAL_LINE DECIMAL_LINE
HEX_LINE        -> WHITE HEX | HEX_LINE HEX_LINE
S_REAL_LINE     -> WHITE S_REAL | S_REAL_LINE S_REAL_LINE
F_REAL_LINE     -> WHITE F_REAL | F_REAL_LINE F_REAL_LINE
```

## Zadanie 6.1.c

> Skonstruuj w języku Bison przetwornik weryfikujący poprawność budowy przedmiotowego zbioru danych i generujący na wyjściu ciąg liczb, w odpowiednich formatach, będących sumami liczb przechowywanych w kolejnych wierszach zbioru.

### Rozwiązanie

Program napisany w FLEX pełni rolę analizatora leksykalnego, który generuje tokeny z wejścia. Tokeny dostarczane są do analizatora składniowego, którym jest program napisany w BISON. Analizator składniowy analizuje tokeny i układa je w struktury, zgodnie z regułami produkcji. Jeżeli dane wejściowe są zgodnę z gramatyką, wykonywany jest kod w języku C (dodawanie kolejnych liczb).
Rozwiązanie oparte jest na gramatyce zdefiniowanej w _zadaniu 6.1.b_.

## Zadanie 6.1.d

> Załóż zmodyfikowaną postać zbioru z liczbami. Modyfikacja polega na jawnym umieszczeniu we wszystkich wierszach – numerów tych wierszy, od numeru 1 poczynając.
> Skonstruuj w języku Bison przetwornik weryfikujący poprawność budowy przedmiotowego zbioru danych i generujący na wyjściu ciąg par liczb, z których pierwsza oznacza numer wiersza, a druga - sumę liczb przechowywanych w odpowiednim wierszu zbioru.

### Rozwiązanie

Rozwiązanie polegało na zmodyfikowaniu kodu z _zadania 6.1.c_. Należało dodać poprawne wyrażenie regularne w analizatorze leksykalnym, tak, aby indeks linii wykrywany był jako dodatkowy token. Następnie w analizatorze składniowym wystarczyło zmienić regułę produkcji odpowiedzialną za pojedyńczą linię.

Wyrażenie regularne dla indeksu linii:

```
^[1-9]+[0-9]*
```

## Kompilacja

```sh
$ bison -dy parser.y
$ flex analizator.l
$ gcc y.tab.c lex.yy.c -lfl
```

## Działanie

```sh
$ ./a.out < test.txt
```

## Licencja

MIT
