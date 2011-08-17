> module RugHH where

    RUGHH 10.8.2011

    Eine Einführung in Haskell

    Timo B. Hübel (@tbh303)
    fortytools gmbh, Hamburg

    Übersicht

      1. Grundlagen und Eigenschaften
      2. Begriffe, Definitionen und Syntax
      3. Sprachelemente von Haskell


1. Grundlagen und Eigenschaften
===============================

Geschichte
----------

 - Benannt nach Haskell Brooks Curry,
   amerikanischer Mathematiker, 1900-1982

 - Entwicklung als einheitliche Basis zur Erforschung
   funktionaler Sprachen, Einfluss durch ML und Miranda

 - Erste Definition der Sprache in 1990, "Haskell 98"
   war lange Standard, aktuell: "Haskell 2010"

 - Heute wird die Entwicklung stark von Microsoft Research
   vorangetrieben, insb. durch Simon Peyton-Jones

Eigenschaften funktionaler Sprachen
-----------------------------------

 - Keine Zuweisungen
 - Keine Schleifen
 - Keine Seiteneffekte
 - Kein Zustand

 - Funktionen höherer Ordnung

 - Variablen im mathematischen Sinn
   (Gleiches durch Gleiches ersetzen)

 - Funktionen im mathematischen Sinn
   (eindeutige Zuordnung von Resultat zu Argument)

Eigenschaften von Haskell
-------------------------

 - Basiert auf dem Lambda-Kalkül (formale Sprache zur
   Definition von Funktionen und deren Auswertung)

 - Strenge statische Typisierung mit Typinferenz nach
   Hindley-Milner

 - Bedarfsauswertung (Lazy-Evaluation)

 - Abbildung von IO durch Monaden

 - Pattern Matching


2. Begriffe, Definitionen und Syntax
====================================

Charakteristische Begriffe:

Funktion, Typ, Ausdruck, Wert, Rekursion, Auswertung

Nicht: Prozedur, Objekt, Methode, Schleife, Ausführung

Grundlegende Syntax
-------------------

wertname :: Typname
wertname = ausdruck

> dieZahlEins :: Integer
> dieZahlEins = 1

> multiplizierteZahl :: Integer
> multiplizierteZahl = 6 * 7

funktionsname :: ArgumentTyp -> ResultatTyp
funktionsname x = ausdruck

> square :: Integer -> Integer
> square x = x * x

Wertnamen beginnen mit Kleinbuchstaben
Funktionsnamen beginnen mit Kleinbuchstaben
Typnamen beginnen mit Großbuchstaben

Eingebaute Typen

String: "abcde"
Integer: 42
Double: 3.14
Tupel: (23, "foo")
Listen: [1,2,3,4,5]

Kommentare: Mit -- bis zum Zeilenende

> kommentar = "test" -- Dies ist ein Kommentar

Oder mit {- -} für Blöcke:

> block = 1 + 2 {- + 3 + 4 -} + 5

Oder .lhs Datei für "Literate Programming" (diese Datei):
Nur Zeilen eingeleitet mit > werden vom Compiler berücksichtigt.

Pattern Matching
----------------

Funktionsdefintion mit Hilfe mehrerer Gleichungen:

> fib :: Integer -> Integer
> fib 0 = 0
> fib 1 = 1
> fib n = fib (n - 2) + fib (n - 1)

> fac :: Integer -> Integer
> fac 0 = 1
> fac n = n * fac (n - 1)

Bedarfsauswertung
-----------------

  square (3 + 4)
=                            { Definition von square }
  x * x where x = 3 + 4
=                            { Definition von + im Teilausdruck }
  x * x where x = 7
=                            { Einsetzen von x }
  7 * 7
=                            { Definition von * }
  49

> three :: Integer -> Integer
> three x = 3

> infinity :: Integer
> infinity = infinity + 1

> fibs :: [Integer]
> fibs = 0 : 1 : (zipWith (+) fibs (tail fibs))

> tenFibs :: [Integer]
> tenFibs = take 10 fibs

Currying
--------

Partielle Funktionsapplikation,
in Ruby 1.9 mit Proc.curry enthalten.

In Haskell für Funktionsdefinitionen mit mehreren Parametern.

> smaller :: (Integer, Integer) -> Integer
> smaller (x, y) = if x <= y then x else y

> smallerc :: Integer -> Integer -> Integer
> smallerc x y = if x <= y then x else y

Andere Sichtweise:

In smallerc wird EIN Argument entgegengenommen und als Ergebnis eine
Funktion vom Typ Integer -> Integer berechnet.

> plusc :: Integer -> Integer -> Integer
> plusc x y = x + y

> incrc :: Integer -> Integer
> incrc = plusc 1

> twice :: (Integer -> Integer) -> (Integer -> Integer)
> twice f x = f (f x)

> quad :: Integer -> Integer
> quad = twice square

Funktionskomposition mit dem . Operator

> quad2 x = square (square x)

> quad3 = square . square

Polymorphe Typen
----------------

square :: Integer -> Integer
sqrt :: Integer -> Float

square . square :: Integer -> Integer
sqrt . square :: Integer -> Float

Welchen Typ besitzt . ?

Typen, die eine Typvariable enthalten, heißen polymorphe Typen.

Typvariablen beginnen immer mit einem Kleinbuchstaben!

Typklassen
----------

Problem: Plus Operator für Integer, Float, Double, ...?

> plusInt :: Integer -> Integer -> Integer
> plusInt x y = x + y

> plusFloat :: Float -> Float -> Float
> plusFloat x y = x + y

Also: plus :: a -> a -> a

Zu Allgemein!

Typklassen beschreiben Typen, welche eine bestimmte zusätzliche
Eigenschaft besitzen.

Vgl. Interfaces in Java. Aber: Typklassen können auch nachträglich
hinzugefügt werden.

(+) :: Num a => a -> a -> a

Die Haskell-Standardbibliothek bringt div. vordefinierte Typklassen
mit, z.B. für Gleicheit, Ordnung, Arithmetik, ...


3. Sprachelemente von Haskell
=============================

Einfache Datentypen
-------------------

Definition von neuen Datentypen:

> data Day = Mon | Tue | Wed | Thu | Fri | Sat | Sun

> dayOfWeek :: Day -> Integer
> dayOfWeek Mon = 0
> dayOfWeek Tue = 1
> dayOfWeek Wed = 2
> dayOfWeek Thu = 3
> dayOfWeek Fri = 4
> dayOfWeek Sat = 5
> dayOfWeek Sun = 6

Datentypen mit Typvariablen:

> data Perhaps a = An a | None

> perhaps :: b -> (a -> b) -> Perhaps a -> b
> perhaps x f None = x
> perhaps x f (An y) = f y

Typklassen instantiieren:

> instance Eq Day where
>   (==) Mon Mon = True
>   (==) Tue Tue = True
>   (==) Wed Wed = True
>   (==) Thu Thu = True
>   (==) Fri Fri = True
>   (==) Sat Sat = True
>   (==) Sun Sun = True
>   (==) _ _ = False

Listen und Listenfunktionen
---------------------------

Konzeptioneller Hintergrund von Listen in Haskell:

> data List a = Nil | Cons a (List a)

> oneToThree = Cons 1 (Cons 2 (Cons 3 Nil))

Eigene Syntax:

Nil = []
Cons = (:)

Wichtigster Operator: ++

> append :: [a] -> [a] -> [a]
> append [] ys = ys
> append (x:xs) ys = x : (xs ++ ys)

Unendliche Listen:

Siehe Definition von fibs oben.

Einfache Syntax:

> evens :: [Integer]
> evens = [0,2..]

> odds :: [Integer]
> odds = [1,3..]

> from :: Integer -> [Integer]
> from x = x : from (x + 1)

> from2 x = [x..]

[0] ++ from 1 = ???
from 1 ++ [0] = ???

Wichtige Funktionen:
head, tail, last, init, reverse, concat, take, drop

Listenfunktionen höherer Ordnung:

"map", "fold" und "filter"
für häufig wiederkehrende Verarbeitungsmuster in Listen

Äquivalent in Ruby:

Enumerable.collect, Enumerable.reduce, Enumerable.select

> collect :: (a -> b) -> [a] -> [b]
> collect f [] = []
> collect f (x:xs) = f x : collect f xs

> select :: (a -> Bool) -> [a] -> [a]
> select p [] = []
> select p (x:xs) = if p x then x : rest else rest
>   where
>   rest = filter p xs

> reduce :: (a -> b -> b) -> b -> [a] -> b
> reduce op e [] = e
> reduce op e (x:xs) = x `op` (reduce op e xs)

List Comprehensions als Kurzschreibweise für "map" und "filter":

  [x * x | x <- [1..5], odd x]
=
  (map square . filter odd) [1..5]

Quicksort mit List Comprehension:

> qsort :: Ord a => [a] -> [a]
> qsort [] = []
> qsort (x:xs) = qsort lesser ++ [x] ++ qsort greater
>   where
>   lesser = [y | y <- xs, y < x]
>   greater = [y | y <- xs, y >= x]

Ein-/Ausgabe mit Monaden
------------------------

Problem: Wie soll Ein-/Ausgabe ohne Seiteneffekte passieren?

Klassischerweise ist I/O immer ein Seiteneffekt: Zeichen erscheint
auf dem Bildschirm oder Daten werden auf Speichermedium geschrieben.

Andere Sichtweise: Ein-/Ausgabe verändert den Weltzustand. D.h. wir
brauchen den aktuellen Weltzustand immer als Argument und den
veränderten Weltzustand als Resultat einer Funktion.

Allgemeines Konzept: Einen Zustand durch Funktionen
                     "hindurchschleifen"

Noch allgemeiner: "Irgendetwas" hindurchschleifen

Beispiel:

> data State a = State a

> f1 :: a -> State s -> (b, State s)
> f1 = undefined

> f2 :: b -> State s -> (c, State s)
> f2 = undefined

> f3 :: c -> State s -> (d, State s)
> f3 = undefined

Gesucht wird jetzt:

> f :: a -> State s -> (d, State s)

Gewünscht:

f x = \s -> f3 (f2 (f1 x s))

f x = \s -> (f3 . f2 . f1 x) s

Aber:

> f x = \s -> let (x1, s1) = f1 x s in
>             let (x2, s2) = f2 x1 s1 in
>                            f3 x2 s2

Ziel: Komposition wie von normalen Funktionen

Monaden liefern Kombinator für das Hintereinanderausführen von
Berechnungen mit zusätzlichen Effekten.

class Monad m where
  return :: a -> m a
  (>>=) :: m a -> (a -> m b) -> m b

Umsetzung für das Beispiel:

> instance Monad State where
>   return x = State x
>   (State x) >>= f = f x

> fm x = f1 x >>= f2 >>= f3

Jetzt auch nutzbar für den "Weltzustand": Die IO-Monade IO ()

Beispiele: putChar, putStrLn, main

Jedes Haskell-Programm beginnt mit einer main-Funktion, welche
den Weltzustand mit als eingabe bekommt:

> main :: IO ()
> main = putStrLn "Hello World!"

Haskell unterstützt einfache Notation für >>= Operator: do-Notation

> main2 :: IO ()
> main2 = do
>   c <- getChar
>   putStrLn ""
>   putStr "You entered: "
>   putChar c
>   putStrLn ""

Großer Vorteil: Zustandsverändernde Funktionen sind an ihrer
Signatur erkennbar!

Aufrufe von "reinen" Funktionen aus monadischen heraus ist kein
Problem, andersherum aber durch das Typsystem verboten.

D.h. bei Funktionen, die eine "reine" Signatur haben, ist für den
Entwickler garantiert (auch ohne den Quelltext zu lesen), dass diese
sich deterministisch verhalten und keine Seiteneffekte verursachen.

Hieraus ergibt sich wiederum ein großer Vorteil bei der
Parallelisierung von Programmen: "Reine" Funktionen lassen sich sehr
einfach parallel ausführen, da auf keinerlei Synchronisation und
geteilte Daten Rücksicht genommen werden muss.


                      Fragen?
                      =======

Weiteres Material: http://learnyouahaskell.com
                   http://book.realworldhaskell.org
                   http://tryhaskell.org
                   http://haskell.org
                   http://hayoo.info

