{-# LANGUAGE PatternSynonyms #-}

module Fastly where

import qualified Data.ByteString as BS
import qualified Data.ByteString.Unsafe as BS
import Foreign
import Foreign.C.Types
import Foreign.C.String
import Data.Word

newtype RequestHandle = RequestHandle Word32 deriving (Show, Storable)
newtype ResponseHandle = ResponseHandle Word32 deriving (Show, Storable)
newtype BodyHandle = BodyHandle Word32 deriving (Show, Storable)

newtype FastlyStatus = FastlyStatus Word32 deriving (Show, Storable, Eq)
pattern Ok = FastlyStatus 0
pattern Error = FastlyStatus 1
pattern Inval = FastlyStatus 2
pattern Badf = FastlyStatus 3
pattern Buflen = FastlyStatus 4

foreign import ccall unsafe "http_req_body_downstream_get"
    http_req_body_downstream_get_ :: Ptr RequestHandle -> Ptr BodyHandle -> IO FastlyStatus
foreign import ccall unsafe "http_req_uri_get"
    http_req_uri_get_ :: RequestHandle -> Ptr CChar -> Int -> Ptr Int -> IO FastlyStatus
foreign import ccall unsafe "http_req_method_get"
    http_req_method_get_ :: RequestHandle -> Ptr CChar -> Int -> Ptr Int -> IO FastlyStatus
foreign import ccall unsafe "http_resp_new"
    http_resp_new_ :: Ptr ResponseHandle -> IO FastlyStatus
foreign import ccall unsafe "http_resp_header_insert"
    http_resp_header_insert_ :: ResponseHandle -> Ptr CChar -> Int -> Ptr CChar -> Int -> IO FastlyStatus
foreign import ccall unsafe "http_resp_send_downstream"
    http_resp_send_downstream :: ResponseHandle -> BodyHandle -> Word32 -> IO FastlyStatus
foreign import ccall unsafe "http_resp_close"
    http_resp_close :: ResponseHandle -> IO FastlyStatus
foreign import ccall unsafe "http_body_new"
    http_body_new_ :: Ptr BodyHandle -> IO FastlyStatus
foreign import ccall unsafe "http_body_write"
    http_body_write_ :: BodyHandle -> Ptr CChar -> Int -> Word32 -> Ptr Int -> IO FastlyStatus

http_req_body_downstream_get :: IO (RequestHandle, BodyHandle, FastlyStatus)
http_req_body_downstream_get =
    alloca $ \p1 ->
    alloca $ \p2 -> do
        res <- http_req_body_downstream_get_ p1 p2
        n1 <- peek p1
        n2 <- peek p2
        return (n1, n2,res)

getBuffer :: (Ptr CChar -> Int -> Ptr Int -> IO FastlyStatus) -> IO (BS.ByteString, FastlyStatus)
getBuffer f = do
    p <- mallocBytes initial_size
    alloca $ \nwritten -> do
        res <- f p initial_size nwritten
        size <- peek nwritten
        if res == Buflen
        then do -- Try again, now that we know how long the data is
            free p
            p <- mallocBytes size
            res <- f p size nwritten
            uri <- BS.unsafePackMallocCStringLen (p, size)
            return (uri, res)
        else do
            uri <- BS.unsafePackMallocCStringLen (p, size)
            return (uri, res)
  where
    initial_size = 128

http_req_uri_get :: RequestHandle -> IO (BS.ByteString, FastlyStatus)
http_req_uri_get rh = getBuffer (http_req_uri_get_ rh)

http_req_method_get :: RequestHandle -> IO (BS.ByteString, FastlyStatus)
http_req_method_get rh = getBuffer (http_req_method_get_ rh)

http_resp_new :: IO (ResponseHandle, FastlyStatus)
http_resp_new = do
    alloca $ \p -> do
        res <- http_resp_new_ p
        n <- peek p
        return (n, res)

http_body_new :: IO (BodyHandle, FastlyStatus)
http_body_new = do
    alloca $ \p -> do
        res <- http_body_new_ p
        n <- peek p
        return (n, res)

http_resp_header_insert :: ResponseHandle -> String -> String -> IO FastlyStatus
http_resp_header_insert handle name value =
    withCStringLen name $ \(name_p, name_l) ->
    withCStringLen value $ \(value_p, value_l) ->
    http_resp_header_insert_ handle name_p name_l value_p value_l

http_body_write :: BodyHandle -> String -> IO (Int, FastlyStatus)
http_body_write handle text =
    withCStringLen text $ \(text_p, text_l) ->
    alloca $ \p -> do
        res <- http_body_write_ handle text_p text_l 0 p
        n <- peek p
        return (n, res)
