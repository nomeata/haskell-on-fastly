import Foreign
import Foreign.C.Types
import Foreign.C.String
import Data.Word

newtype ResponseHandle = ResponseHandle Word32 deriving (Show, Storable)
newtype BodyHandle = BodyHandle Word32 deriving (Show, Storable)

foreign import ccall unsafe "http_resp_new"
    http_resp_new_ :: Ptr ResponseHandle -> IO Word32
foreign import ccall unsafe "http_resp_header_insert"
    http_resp_header_insert_ :: ResponseHandle -> Ptr CChar -> Int -> Ptr CChar -> Int -> IO Word32
foreign import ccall unsafe "http_resp_send_downstream"
    http_resp_send_downstream :: ResponseHandle -> BodyHandle -> Word32 -> IO Word32
foreign import ccall unsafe "http_resp_close"
    http_resp_close :: ResponseHandle -> IO Word32
foreign import ccall unsafe "http_body_new"
    http_body_new_ :: Ptr BodyHandle -> IO Word32
foreign import ccall unsafe "http_body_write"
    http_body_write_ :: BodyHandle -> Ptr CChar -> Int -> Word32 -> Ptr Int -> IO Word32

http_resp_new :: IO (ResponseHandle, Word32)
http_resp_new = do
    alloca $ \p -> do
        res <- http_resp_new_ p
        n <- peek p
        return (n, res)

http_body_new :: IO (BodyHandle, Word32)
http_body_new = do
    alloca $ \p -> do
        res <- http_body_new_ p
        n <- peek p
        return (n, res)

http_resp_header_insert :: ResponseHandle -> String -> String -> IO Word32
http_resp_header_insert handle name value =
    withCStringLen name $ \(name_p, name_l) ->
    withCStringLen value $ \(value_p, value_l) ->
    http_resp_header_insert_ handle name_p name_l value_p value_l

http_body_write :: BodyHandle -> String -> IO (Int, Word32)
http_body_write handle text =
    withCStringLen text $ \(text_p, text_l) ->
    alloca $ \p -> do
        res <- http_body_write_ handle text_p text_l 0 p
        n <- peek p
        return (n, res)

main = do
    (handle, _) <- http_resp_new
    http_resp_header_insert handle "Content-Type" "text/plain" >>= print
    (body, _) <- http_body_new
    http_body_write body "Hello World, this is Haskell as WebAssembly on Fastly!" >>= print
    http_resp_send_downstream handle body 0 >>= print
