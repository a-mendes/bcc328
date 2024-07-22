{
{-# OPTIONS_GHC -Wno-name-shadowing #-}
module Exp.Frontend.Lexer.Lexer (Token (..), Lexeme (..), lexer) where

import Exp.Frontend.Lexer.Token 
}

-- Estuturas de linha e coluna 
%wrapper "posn"

-- Expressão regular (1 + 2 + 3 + ... + 9)
$digit = 0-9            -- digits

-- second RE macros
-- Define que um número é uma sequencia de um ou mais dígitos
@number     = $digit+


-- tokens declarations

tokens :-
      $white+       ; -- Reconhece espaços em branco, descarte
      "//" .*       ; -- Comentários de uma linha. (.*) reconhece toda expressão exceto \n
      @number       {mkNumber}
      "("           {simpleToken TLParen}
      ")"           {simpleToken TRParen}
      "+"           {simpleToken TPlus}
      "*"           {simpleToken TTimes}

{
position :: AlexPosn -> (Int, Int)
position (AlexPn _ x y) = (x,y)

mkNumber :: AlexPosn -> String -> Token
mkNumber p s = Token (position p) (TNumber $ read s)

simpleToken :: Lexeme -> AlexPosn -> String -> Token
simpleToken lx p _ = Token (position p) lx

-- Realiza a análise léxica e retorna a lista de tokens 
lexer :: String -> [Token]
lexer = alexScanTokens
}
