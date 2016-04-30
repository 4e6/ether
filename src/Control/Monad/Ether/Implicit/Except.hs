{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE MagicHash #-}

-- | See "Control.Monad.Ether.Except".

module Control.Monad.Ether.Implicit.Except
    (
    -- * MonadExcept class
      MonadExcept
    , throw
    , catch
    -- * The Except monad
    , Except
    , runExcept
    -- * The ExceptT monad transformer
    , ExceptT
    , exceptT
    , runExceptT
    -- * Handle functions
    , handle
    , handleT
    ) where

import GHC.Prim (Proxy#, proxy#)
import qualified Control.Monad.Ether.Except as Explicit

-- | See 'Control.Monad.Ether.Except.MonadExcept'.
type MonadExcept e = Explicit.MonadExcept e e

-- | See 'Control.Monad.Ether.Except.throw'.
throw :: forall e m a . MonadExcept e m => e -> m a
throw = Explicit.throw (proxy# :: Proxy# e)

-- | See 'Control.Monad.Ether.Except.catch'.
catch :: forall e m a . MonadExcept e m => m a -> (e -> m a) -> m a
catch = Explicit.catch (proxy# :: Proxy# e)

-- | See 'Control.Monad.Ether.Except.Except'.
type Except e = Explicit.Except e e

-- | See 'Control.Monad.Ether.Except.runExcept'.
runExcept :: Except e a -> Either e a
runExcept = Explicit.runExcept proxy#

-- | See 'Control.Monad.Ether.Except.ExceptT'.
type ExceptT e = Explicit.ExceptT e e

-- | See 'Control.Monad.Ether.Except.exceptT'.
exceptT :: m (Either e a) -> ExceptT e m a
exceptT = Explicit.exceptT proxy#

-- | See 'Control.Monad.Ether.Except.runExceptT'.
runExceptT :: ExceptT e m a -> m (Either e a)
runExceptT = Explicit.runExceptT proxy#

-- | See 'Control.Monad.Ether.Except.handle'.
handle :: (e -> a) -> Except e a -> a
handle = Explicit.handle proxy#

-- | See 'Control.Monad.Ether.Except.handleT'.
handleT :: Functor m => (e -> a) -> ExceptT e m a -> m a
handleT = Explicit.handleT proxy#
