module Regression.T7 (test7) where

import Data.Monoid
import Control.Monad

import Control.Monad.Ether
import qualified Control.Monad.Writer as T

import Test.Tasty
import Test.Tasty.QuickCheck

ethereal "WTag" "wTag"

testEther
  :: Num a
  => T.MonadWriter (Sum a) m
  => MonadWriter WTag (Sum a) m
  => [a] -> m ()
testEther xs = do
  forM_ xs $ \x -> do
    T.tell (Sum x)
    tell wTag (Sum 1)

runner1 :: Num a => [a] -> (a, a)
runner1 xs =
  let (s, c) = T.runWriter . execWriterT wTag $ testEther xs
  in (getSum s, getSum c)

runner2 :: Num a => [a] -> (a, a)
runner2 xs =
  let (c, s) = runWriter wTag . T.execWriterT $ testEther xs
  in (getSum s, getSum c)

triangular :: Integral a => a -> a
triangular n = div (n * (n + 1)) 2

test7 :: TestTree
test7 = testGroup "T7: Triangular via Ether"
  [ testProperty "runner₁ works"
    $ \n -> property
    $ let n' = abs n :: Integer
      in runner1 [1..n'] == (n', triangular n')
  , testProperty "runner₂ works"
    $ \n -> property
    $ let n' = abs n :: Integer
      in runner2 [1..n'] == (n', triangular n')
  , testProperty "runner₁ == runner₂"
    $ \(ns :: [Integer]) -> property
    $ runner1 ns == runner2 ns
  ]